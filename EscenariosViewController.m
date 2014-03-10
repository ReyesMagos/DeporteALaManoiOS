//
//  EscenariosViewController.m
//  DeporteALaMano
//
//  Created by Felipe on 7/11/13.
//  Copyright (c) 2013 Felipe. All rights reserved.
//

#import "EscenariosViewController.h"
#import "Json.h"
#import "Escenario.h"
#import "MapaViewController.h"
#import "Entidad.h"
#import "Reachability.h"
#import "UIDevice-Hardware.h"

@interface EscenariosViewController ()

@end

@implementation EscenariosViewController

@synthesize txtDepartamento, txtMunicipio, txtEscenario;
@synthesize autoCompletarTableView, departamentos, posiblesDepartamentos;
@synthesize indicadorActividad, pickerMunicipios, pickerEscenarios, botonLimpiar, botonMostrar;
@synthesize escenariosFinales, esceMunicipios, esceDepartamentos, escenariosfiltrados;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Busco de qué familia iDevice se ejecuta esta aplicación
    UIDeviceFamily familia = [[UIDevice currentDevice]deviceFamily];
    
    //Invoco una notificacion para detectar cuando hay cambios en la conexión a internet
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:kReachabilityChangedNotification object:nil];
	
    //Inicializo los mutablearrays
    self.posiblesDepartamentos = [[NSMutableArray alloc]init];
    self.escenariosFinales = [[NSMutableArray alloc]init];
    self.esceMunicipios = [[NSMutableArray alloc]init];
    self.escenariosfiltrados = [[NSMutableArray alloc]init];
    
    //Creamos un UITableView y lo añadimos a la actual View
    switch (familia) {
        case UIDeviceFamilyiPhone: case UIDeviceFamilyiPod:
            NSLog(@"iphone");
            //Si es retina 4x
            if ([UIScreen mainScreen].bounds.size.height == 568.0) {
                autoCompletarTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 170, 325, 120) style:UITableViewStylePlain];
            }else{
                autoCompletarTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 115, 325, 88) style:UITableViewStylePlain];
            }
            break;
        case UIDeviceFamilyiPad :
            autoCompletarTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 200, 1136, 130) style:UITableViewStylePlain];
            NSLog(@"ipad");
            break;
            
        case UIDeviceFamilySimulator:
            if ([[UIDevice currentDevice] platformType] == UIDeviceSimulatoriPhone) {
                if ([UIScreen mainScreen].bounds.size.height == 568.0) {
                    autoCompletarTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 170, 325, 120) style:UITableViewStylePlain];
                }else{
                    autoCompletarTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 115, 325, 88) style:UITableViewStylePlain];
                }
            }else{
                autoCompletarTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 200, 1136, 130) style:UITableViewStylePlain];
            }
            break;
            
        default:
            autoCompletarTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 110, 325, 120) style:UITableViewStylePlain];
            break;
    }
    
    autoCompletarTableView.delegate  = self;
    autoCompletarTableView.dataSource = self;
    autoCompletarTableView.scrollEnabled = YES;
    autoCompletarTableView.hidden = YES;
    [self.view addSubview:autoCompletarTableView];
    
    //Escondo el ActivityIndicator del view
    indicadorActividad.hidden = YES;
    
    //Recupero el listado de Departamentos en la carpeta de soporte
    NSBundle * paquete = [NSBundle mainBundle];
    NSString *ruta = [paquete pathForResource:@"Departamentos" ofType:@"plist"];
    departamentos = [[NSArray alloc] initWithContentsOfFile:ruta];
    
    
    //Poniendo fondo a los botones
    [[botonLimpiar layer] setBorderWidth:1.0f];
    [[botonLimpiar layer] setCornerRadius:8.0f];
    [[botonLimpiar layer] setBackgroundColor:[UIColor whiteColor].CGColor];
    [[botonLimpiar layer]setBorderColor:[UIColor blueColor].CGColor];
    
    [[botonMostrar layer] setBorderWidth:1.0f];
    [[botonMostrar layer] setCornerRadius:8.0f];
    [[botonMostrar layer] setBackgroundColor:[UIColor whiteColor].CGColor];
    [[botonMostrar layer] setBorderColor:[UIColor blueColor].CGColor];
    
}

-(void) deshabilitarTodo{
    txtDepartamento.enabled = NO;
    [[self labelNoConexion] setHidden:NO];
    botonMostrar.enabled = NO;
    
}
-(void) habilitarTodo{
    txtDepartamento.enabled = YES;
    [[self labelNoConexion] setHidden:YES];
    botonMostrar.enabled = YES;
}

//Este metodo se encarga de notificar a este view si hubo cambios en la conexión a internet
- (void)reachabilityDidChange:(NSNotification *)notification {
    Reachability *reachability = (Reachability *)[notification object];
    if ([reachability isReachable]) {
        [self habilitarTodo];
    } else {
        [self deshabilitarTodo];
    }
}

-(void) buscarEntradasAutocompletarConSubstring : (NSString *) substring{
    [posiblesDepartamentos removeAllObjects];
    
    for (NSString * departamento in departamentos) {
        NSRange subStringRango = [departamento rangeOfString:substring];
        if (subStringRango.location == 0) {
            [posiblesDepartamentos addObject:departamento];
        }
    }
    [autoCompletarTableView reloadData];
}

-(void)consumaJson:(NSString *)depar{
    NSString * completo = [[NSString alloc]init];
    if (depar == nil) {
        completo = [NSString stringWithFormat:@"http://servicedatosabiertoscolombia.cloudapp.net/v1/coldeportes/consolidadoescenarios?&$format=json"];
    }else{
        completo = [NSString stringWithFormat:@"http://servicedatosabiertoscolombia.cloudapp.net/v1/coldeportes/consolidadoescenarios?$filter=departamento eq '%@' &$format=json", depar];
    }
    
    NSDictionary * json = [[[Json alloc] init]jsonConContenidoDeURLString:completo];
    
    NSArray *escenaris = [json objectForKey:@"d"];
    [self llenaEscenarios:escenaris];
    
}
-(void)llenaEscenarios:(NSArray *)array{
    [escenariosFinales removeAllObjects];
    for (int i = 0; i < array.count; i++) {
        Escenario * escenario = [[Escenario alloc] initWithNSDictionary:[array objectAtIndex:i]];
        [escenariosFinales addObject:escenario];
        
    }
}

-(void)filtraEscenarios:(NSString *)muni conNombre:(NSString *)nom{
    NSMutableArray * arrayAux = [[NSMutableArray alloc]initWithArray:escenariosFinales];
    if (muni != nil) {
        for (Escenario * esc in arrayAux) {
            if (esc.municipo != muni) {
                [escenariosFinales removeObject:esc];
                
            }
        }
    }else if (nom != nil){
        for (Escenario * esc in arrayAux) {
            if (esc.nombre != nom) {
                [escenariosFinales removeObject:esc];
            }
        }
    }
    
}

- (IBAction)botonNvaBusqueda:(id)sender {
    
    //Elimino todos los objetos en los siguientes Arrays
    [posiblesDepartamentos removeAllObjects];
    [escenariosFinales removeAllObjects];
    [esceMunicipios removeAllObjects];
    [escenariosfiltrados removeAllObjects];
    
    //Limpo los campos de cada textfield y los habilito
    txtDepartamento.text = nil;
    txtDepartamento.enabled = YES;
    txtMunicipio.text = nil;
    txtMunicipio.enabled = NO;
    txtMunicipio.placeholder = @"Ingrese primero Depto";
    txtEscenario.text = nil;
    txtEscenario.enabled = NO;
    txtEscenario.placeholder = @"Ingrese primero Depto";
    
    //Actualizo los pickers
    [pickerEscenarios reloadAllComponents];
    [pickerMunicipios reloadAllComponents];
}

- (IBAction)MostrarBoton:(id)sender {
    
    Entidad* en =[Entidad sharedManager];
    NSMutableArray * final = [[NSMutableArray alloc] init];
    if (txtDepartamento.text == nil || [txtDepartamento.text isEqualToString:@""]) {
        [self consumaJson:nil];
//        UIAlertView * alerta = [[UIAlertView alloc] initWithTitle:@"Advertencia" message:@"A continuación se mostrarán todos los escenarios del país" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
//        [alerta show];
        en.escenarios = escenariosFinales;
    }
    else if ((txtMunicipio.text == nil|| [txtMunicipio.text isEqualToString:@""]) && (txtEscenario.text == nil|| [txtEscenario.text isEqualToString:@""])){
        en.escenarios = escenariosFinales;
    }else{
        if (txtEscenario.text == nil|| [txtEscenario.text isEqualToString:@""]) {
            for (Escenario * esce in escenariosFinales) {
                if ([esce.municipo isEqualToString:txtMunicipio.text]) {
                    [final addObject: esce];
                }
            }
        }else if (txtMunicipio.text == nil|| [txtMunicipio.text isEqualToString:@""]) {
            for (Escenario * esce in escenariosFinales) {
                if ([esce.nombre isEqualToString:txtEscenario.text]) {
                    [final addObject: esce];
                }
            }
        }else{
            for (Escenario * esce in escenariosFinales) {
                if ([esce.municipo isEqualToString:txtMunicipio.text] && [esce.nombre isEqualToString:txtEscenario.text]) {
                    [final addObject: esce];
                }
            }
        }
        en.escenarios = final;
    }
    en.evento = nil;
    UITabBarController *mapaIr2 = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"MenuTab"];
    mapaIr2.navigationItem.title = @"Mapa";
    [mapaIr2 setSelectedIndex:1];
    [self.navigationController pushViewController:mapaIr2 animated:YES];
}

-(void)buscaPorMunicipio{
    [esceMunicipios removeAllObjects];
    for (Escenario * esce in escenariosFinales ) {
        NSString * aux = esce.municipo;
        if (![esceMunicipios containsObject:aux]) {
            [esceMunicipios addObject: esce.municipo];
        }
        
    }
    [esceMunicipios sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [esceMunicipios insertObject:@"Seleccione" atIndex:0];
    [pickerMunicipios reloadAllComponents];
}

-(void)buscarEscenariosPorMunicipio: (NSString*) municipio{
    [escenariosfiltrados removeAllObjects];
    if (municipio == nil || [municipio isEqualToString:@""]) {
        for (Escenario * esce in escenariosFinales) {
            [escenariosfiltrados addObject: esce.nombre];
        }
    }else{
        for (Escenario * esce in escenariosFinales) {
            if ([esce.municipo isEqualToString:municipio]) {
                [escenariosfiltrados addObject: esce.nombre];
            }
        }
    }
    [escenariosfiltrados sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [escenariosfiltrados insertObject:@"Seleccione" atIndex:0];
    [pickerEscenarios reloadAllComponents];
}

#pragma mark UIView methods

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (![autoCompletarTableView isHidden]) {
        txtDepartamento.text = nil;
        autoCompletarTableView.hidden = YES;
    }
    if (txtDepartamento.text == nil || [txtDepartamento.text isEqualToString:@""] ) {
        txtMunicipio.text = txtEscenario.text = nil;
        txtMunicipio.enabled = txtEscenario.enabled = NO;
        txtMunicipio.placeholder = txtEscenario.placeholder = @"Ingrese primero Depto";
    }else if (txtMunicipio.text == nil || [txtMunicipio.text isEqualToString:@""]){
        txtEscenario.text = nil;
    }
    [[self view] endEditing:TRUE];
}

#pragma mark UIPickerViewDatasource methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag == 1) {
        return [esceMunicipios count];
    }else
        return [escenariosfiltrados count];
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView.tag == 1) {
        return [esceMunicipios objectAtIndex:row];
    }else
        return [escenariosfiltrados objectAtIndex:row];
}

#pragma mark UIPickerViewDelegate methods

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (row == 0) {
        return;
    }
    if (pickerView.tag == 1) {
        txtMunicipio.text = [esceMunicipios objectAtIndex:row];
        txtEscenario.text = nil;
    }else{
        txtEscenario.text = [escenariosfiltrados objectAtIndex:row];
    }
    [[self view] endEditing:TRUE];
    [pickerView removeFromSuperview];
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel * txtLabel = (UILabel*)view;
    if (!txtLabel) {
        txtLabel = [[UILabel alloc]init];
        txtLabel.font = [UIFont systemFontOfSize:15];
        txtLabel.lineBreakMode = UILineBreakModeWordWrap;
        
        CGRect frameaux = txtLabel.frame;
        frameaux.size.height = 60;
        txtLabel.frame = frameaux;
        
        txtLabel.numberOfLines = 0;
        txtLabel.backgroundColor = [UIColor clearColor];
    }
    if (pickerView.tag == 1) {
        txtLabel.text = [esceMunicipios objectAtIndex:row];
    }else{
        txtLabel.text = [escenariosfiltrados objectAtIndex:row];
    }
    return txtLabel;
}

#pragma mark UITextFieldDelegate methods

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 1) {
        autoCompletarTableView.hidden = NO;
        
        NSString *subString = [NSString stringWithString:textField.text];
        subString = [subString stringByReplacingCharactersInRange:range withString:string];
        
        [self buscarEntradasAutocompletarConSubstring:subString];
        
    }
    return YES;
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag == 2) {
        [self buscaPorMunicipio];
        pickerMunicipios.hidden =  NO;
        textField.inputView = pickerMunicipios;
    }else if (textField.tag == 3){
        [self buscarEscenariosPorMunicipio:[txtMunicipio text] ];
        pickerEscenarios.hidden = NO;
        textField.inputView = pickerEscenarios;
    }
    
}

-(void)textFieldReturn:(id)sender{
    [sender resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    return [posiblesDepartamentos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString * nombreCeldas = @"celdasdDepartamento";
    UITableViewCell * celda = [tableView dequeueReusableCellWithIdentifier:nombreCeldas];
    if (celda == nil) {
        celda = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nombreCeldas];
        
    }
    
    celda.textLabel.text = [posiblesDepartamentos objectAtIndex:indexPath.row];
    return celda;
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    txtDepartamento.text = selectedCell.textLabel.text;
    autoCompletarTableView.hidden = YES;
    indicadorActividad.hidden = NO;
    txtMunicipio.text = txtEscenario.text = nil;
    
    [indicadorActividad startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        
        [self consumaJson: txtDepartamento.text];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.view endEditing:YES];
            
            if ([escenariosFinales count] == 0) {
                txtDepartamento.text = nil;
                UIAlertView * alerta = [[UIAlertView alloc] initWithTitle:@"Alerta" message:@"No se encontró ningún registro" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
                [alerta show];
                NSLog(@"No se encontro nada");
                
                
            }else{
                txtMunicipio.enabled = YES;
                txtEscenario.enabled = YES;
                txtMunicipio.placeholder =  @"Seleccione ciudad";
                txtEscenario.placeholder = @"Seleccione escenario";
                botonMostrar.enabled = YES;
                botonLimpiar.enabled = YES;
            }
            [indicadorActividad stopAnimating];
            [indicadorActividad setHidden:YES];
        });
    });
    
}

-(void)viewDidAppear:(BOOL)animated{
    //Se compurba que hay conexion a internet
    if (![[Reachability reachabilityWithHostname:@"www.google.com"] isReachable]) {
        [self deshabilitarTodo];
    }
}

- (void)viewDidUnload {
    [self setTxtDepartamento:nil];
    [self setTxtMunicipio:nil];
    [self setTxtEscenario:nil];
    [self setIndicadorActividad:nil];
    [self setPickerMunicipios:nil];
    [self setPickerEscenarios:nil];
    [super viewDidUnload];
}
@end