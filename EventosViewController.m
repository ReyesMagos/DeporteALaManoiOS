//
//  EventosViewController.m
//  DeporteALaMano
//
//  Created by Felipe on 7/11/13.
//  Copyright (c) 2013 Felipe. All rights reserved.
//

#import "EventosViewController.h"
#import "Evento.h"
#import "Escenario.h"
#import "Entidad.h"
#import "Json.h"
#import "MapaViewController.h"
#import "DetalleEventosViewController.h"
#import "Reachability.h"
#import "UIDevice-Hardware.h"
#import <QuartzCore/QuartzCore.h>

@interface EventosViewController ()

@property (nonatomic, strong) Evento* eventoCompartir;

@end

@implementation EventosViewController
@synthesize paises, eventosFinales, eveDepartamentos, eveMunicipios, eveEventos, eventoCompartir;
@synthesize txtDepartamentos, txtEventos, txtMunicipios, txtPaises;
@synthesize pickerDepartamentos, pickerMunicipios, pickerEventos;
@synthesize autoCompletarTableView, posiblesPaises, indicadorActividad, botonMostrar, botonLimpiar;

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
    
    //Invoco una notificacion para detectar cuando hay cambios en la conexión a internet
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:kReachabilityChangedNotification object:nil];
    //Busco de qué familia iDevice se ejecuta esta aplicación
    UIDeviceFamily familia = [[UIDevice currentDevice]deviceFamily];
    
    //Inicializo los objetos para la opcion de autocompletar
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
    
    
    //Recupero el listado de Paises en la carpeta de soporte
    NSBundle* paquete = [NSBundle mainBundle];
    NSString * ruta = [paquete pathForResource:@"Paises" ofType:@"plist"];
    
    //Inicializo los arrays
    self.eventosFinales = [[NSMutableArray alloc]init];
    self.paises = [[NSArray alloc] initWithContentsOfFile:ruta];
    self.eveDepartamentos = [[NSMutableArray alloc]init];
    self.eveMunicipios = [[NSMutableArray alloc]init];
    self.eventosFinales = [[NSMutableArray alloc]init];
    self.posiblesPaises = [[NSMutableArray alloc]init];
    self.eveEventos = [[NSMutableArray alloc]init];
    
    //Poniendole color a los botones
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
    txtPaises.enabled = NO;
    [[self labelNoConexion] setHidden:NO];
    botonMostrar.enabled = NO;
    
}
-(void) habilitarTodo{
    txtPaises.enabled = YES;
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

-(void)consumaJson:(NSString *)pais{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    NSString * completo = [NSString stringWithFormat:@"http://servicedatosabiertoscolombia.cloudapp.net/v1/coldeportes/consolidadoeventos?$filter=pais eq '%@' &$format=json", pais];
    
    NSDictionary * json = [[[Json alloc] init]jsonConContenidoDeURLString:completo];
    
    NSArray *events = [json objectForKey:@"d"];
    
    [self llenaEventos:events];
    
}

-(void)llenaEventos:(NSArray *)array{
    
    [eventosFinales removeAllObjects];
    for (int i = 0; i < [array count]; i++) {
        Evento * evenAux = [[Evento alloc]initWithNSDictionaty:[array objectAtIndex:i]];
        [eventosFinales addObject:evenAux];
    }
}

-(void)buscarEntradasAutocompletarConSubstring:(NSString *)substring{
    [posiblesPaises removeAllObjects];
    
    for (NSString * pais in paises) {
        NSRange subStringRango = [pais rangeOfString:substring];
        if (subStringRango.location == 0) {
            [posiblesPaises addObject:pais];
        }
    }
    [autoCompletarTableView reloadData];
}

-(void)buscarPorDepartamento{
    [eveDepartamentos removeAllObjects];
    for (Evento * even in eventosFinales) {
        NSString * aux = even.territorio;
        if (![eveDepartamentos containsObject:aux] && ![aux isEqualToString:@""]) {
            [eveDepartamentos addObject:aux];
        }
    }
    [eveDepartamentos sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [eveDepartamentos insertObject:@"Seleccione" atIndex:0];
    [pickerDepartamentos reloadAllComponents];
}

-(void)buscarPorMunicipio{
    [eveMunicipios removeAllObjects];
    if (txtDepartamentos.text == nil || [txtDepartamentos.text isEqualToString:@""] ) {
        for (Evento * even in eventosFinales) {
            NSString * aux = even.lugar;
            if (![eveMunicipios containsObject:aux] && ![aux isEqualToString:@""] ) {
                [eveMunicipios addObject:aux];
            }
        }
    }else{
        for (Evento * even in eventosFinales) {
            if ([even.territorio isEqualToString: txtDepartamentos.text]) {
                NSString * aux = even.lugar;
                if (![eveMunicipios containsObject:aux] && ![aux isEqualToString:@""]) {
                    [eveMunicipios addObject:aux];
                }
            }
        }
    }
    [eveMunicipios sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [eveMunicipios insertObject:@"Seleccione" atIndex:0];
    [pickerMunicipios reloadAllComponents];
}
-(void) buscarPorEvento{
    [eveEventos removeAllObjects];
    if ((txtDepartamentos.text == nil || [txtDepartamentos.text isEqualToString:@""]) ) {
        if (txtMunicipios.text == nil || [txtMunicipios.text isEqualToString:@""]) {
            for (Evento * even in eventosFinales){
                NSString * aux = even.nombre;
                [eveEventos addObject:aux];
            }
        }else{
            for (Evento * even in eventosFinales){
                NSString * aux = even.nombre;
                if ([even.lugar isEqualToString:txtMunicipios.text]) {
                    [eveEventos addObject:aux];
                }
            }
            
        }
        
    }else if (txtMunicipios.text == nil || [txtMunicipios.text isEqualToString:@""]){
        for (Evento * even in eventosFinales){
            NSString * aux = even.nombre;
            if ([even.territorio isEqualToString:txtDepartamentos.text] ) {
                [eveEventos addObject:aux];
            }
        }
    }else{
        for (Evento * even in eventosFinales){
            NSString * aux = even.nombre;
            if ([even.lugar isEqualToString:txtMunicipios.text] && [even.territorio isEqualToString:txtDepartamentos.text]) {
                [eveEventos addObject:aux];
            }
        }
    }
    [eveEventos sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [eveEventos insertObject:@"Seleccione" atIndex:0];
    [pickerEventos reloadAllComponents];
}

-(NSMutableArray*) filtarEventos: (NSMutableArray*) arreglo paraCaso: (int) caso{
    NSMutableArray * arrayAux = [[NSMutableArray alloc]initWithArray:arreglo];
    if (caso == 0) {
        NSString* depto = txtDepartamentos.text;
        for (Evento * evento in arreglo) {
            if (! [evento.territorio isEqualToString:depto]) {
                [arrayAux removeObject:evento];
            }
        }
    }else if (caso == 1){
        NSString* muni = txtMunicipios.text;
        for (Evento * evento in arreglo) {
            if (! [evento.lugar isEqualToString:muni]) {
                [arrayAux removeObject:evento];
            }
        }
    }else{
        NSString* ev = txtEventos.text;
        for (Evento * evento in arreglo) {
            if (! [evento.nombre isEqualToString:ev]) {
                [arrayAux removeObject:evento];
            }
        }
    }
    return arrayAux;
}

-(void)buscarEscenariosSegunEventos:(NSMutableArray *)eventos{
    Json * consumeJson = [[Json alloc]init];
    
    NSMutableArray* escenariosJoin = [[NSMutableArray alloc] init];
    [indicadorActividad setHidden:NO];
    [indicadorActividad startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        for (Evento * event in eventos) {
            if ([event escenario] == 0) {
                continue;
            }
            NSString *completo = [NSString stringWithFormat:@"http://servicedatosabiertoscolombia.cloudapp.net/v1/coldeportes/consolidadoescenarios?$filter=codigo eq '%d'&$format=json", [event escenario]];
            NSDictionary* json = [consumeJson jsonConContenidoDeURLString:completo];
            NSArray* posibles = [json objectForKey:@"d"];
            
            Escenario * escenario = [[Escenario alloc] initWithNSDictionary:[posibles objectAtIndex:0]];
            if (escenario != nil) {
                event.escenarioF = escenario;
            }
            //Esto que sigue no sirve de nada, no lo borro porque no se si daña otra cosa
            Escenario * esceObtenido = [self obtenerEscenario:escenario enElArreglo:escenariosJoin];
            if (esceObtenido == nil) {
                escenario.listaEventos = [[NSMutableArray alloc] init];
                [escenario.listaEventos addObject:event];
                [escenariosJoin addObject:escenario];
            }else{
                [esceObtenido.listaEventos addObject:event];
            }
            ////////////
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([eventos count] < 2) {
                Evento * recuperado = [eventos objectAtIndex:0];
                if ([recuperado escenarioF] != nil) {
                    Entidad* en =[Entidad sharedManager];
                    en.evento = recuperado;
                    en.escenarios = nil;
                    
                    UITabBarController *mapaIr2 = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"MenuTab"];
                    mapaIr2.navigationItem.title = @"Mapa";
                    [mapaIr2 setSelectedIndex:1];
                    [self.navigationController pushViewController:mapaIr2 animated:YES];
                }else{
                    NSString * mensaje = [NSString stringWithFormat: @"%@", [recuperado recuperarInformacion]];
                    self.eventoCompartir = recuperado;
                    UIAlertView * alerta = [[UIAlertView alloc] initWithTitle:[recuperado nombre] message:mensaje delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:@"Compartir",nil];
                    [alerta show];
                }
            }else{
                [self mostrarEnDetalleLosEventos:eventos];
                
            }
            [indicadorActividad stopAnimating];
        });
    });
    
}

-(Escenario*) obtenerEscenario : (Escenario*) evento enElArreglo: (NSMutableArray *) arreglo{
    for (Escenario * even in arreglo) {
        if ([even.nombre isEqualToString:evento.nombre]) {
            return even;
        }
    }
    return nil;
}
-(void) limpiarView{
    //Elimino todos los objetos en los siguientes Arrays
    [posiblesPaises removeAllObjects];
    [eventosFinales removeAllObjects];
    [eveDepartamentos removeAllObjects];
    [eveMunicipios removeAllObjects];
    
    posiblesPaises = [[NSMutableArray alloc] init];
    eventosFinales = [[NSMutableArray alloc ] init];
    eveDepartamentos = [[NSMutableArray alloc] init];
    eveMunicipios = [[NSMutableArray alloc] init];
    
    //Limpo los campos de cada textfield y los habilito
    txtPaises.text = nil;
    txtPaises.enabled = YES;
    txtDepartamentos.text = nil;
    txtDepartamentos.placeholder = @"Ingrese primero país";
    txtDepartamentos.enabled = NO;
    txtMunicipios.text = nil;
    txtMunicipios.placeholder = @"Ingrese primero país";
    txtMunicipios.enabled = NO;
    txtEventos.text = NO;
    txtEventos.enabled = NO;
    botonMostrar.enabled = NO;
    botonLimpiar.enabled = NO;
    
    //Actualizo los pickers
    [pickerDepartamentos reloadAllComponents];
    [pickerMunicipios reloadAllComponents];
    [pickerEventos reloadAllComponents];
    [indicadorActividad stopAnimating];
}
- (IBAction)botonLimpiar:(id)sender {
   
    [self limpiarView];
}

- (IBAction)botonMostrar:(id)sender {
    
    NSMutableArray * envio = [[NSMutableArray alloc] initWithArray:eventosFinales];
    if (txtDepartamentos.text != nil && ![txtDepartamentos.text isEqualToString:@""]) {
        envio = [self filtarEventos:envio paraCaso:0];
    }
    if (txtMunicipios.text != nil && ![txtMunicipios.text isEqualToString:@""]){
        envio = [self filtarEventos:envio paraCaso:1];
    }
    if (txtEventos.text != nil && ![txtEventos.text isEqualToString:@""]){
        envio = [self filtarEventos:envio paraCaso:2];
        
    }
    
    if ([txtPaises.text isEqualToString:@"Colombia"]) {
        
        [self buscarEscenariosSegunEventos:envio];
    }else{
        if ([envio count] < 2) {
            self.eventoCompartir = [envio objectAtIndex:0];
            Evento * recuperado = [envio objectAtIndex:0];
            NSString * mensaje = [NSString stringWithFormat: @"%@", [recuperado recuperarInformacion]];
            UIAlertView * alerta = [[UIAlertView alloc] initWithTitle:@"Descripción del Evento" message:mensaje delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:@"Compartir",  nil];
            [alerta show];
        }else
            [self mostrarEnDetalleLosEventos:envio];
    }
    
}

-(void) mostrarEnDetalleLosEventos: (NSMutableArray *) events{
    DetalleEventosViewController * detalle = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"DetalleEventosViewController"];
    [detalle setListaEventos: events];
    detalle.title = @"Detalle";
    [self.navigationController pushViewController:detalle animated:YES];
}

-(void)publicarEnRedSocialElEvento: (Evento *)evento{
    
    NSString * info = [NSString stringWithFormat:@"Voy a ir a: %@, Organizado por: %@, el día: %@, en: %@ - %@", [evento nombre], [evento entidad], [evento fechadesde], [evento lugar], [evento pais]];
    
    //Compruebo la versión del sistema iOS para ver como hábilito Compartir
    if ([[[UIDevice currentDevice] systemVersion] compare:@"6.0" options:NSNumericSearch] == NSOrderedAscending) {
        UIAlertView * alerta = [[UIAlertView alloc] initWithTitle:@"Opción no disponible" message:@"Esta opción solo está disponbile para equipos con iOS 6.0 o superior." delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
        [alerta show];
        
    }else{
        NSArray * datos;
        datos = @[info];
        UIActivityViewController * actividadController = [[UIActivityViewController alloc] initWithActivityItems:datos applicationActivities:nil];
        [self presentViewController:actividadController animated:YES completion:nil];
    }
}

#pragma mark UIView methods

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (![autoCompletarTableView isHidden]) {
        txtPaises.text = nil;
        autoCompletarTableView.hidden = YES;
    }
    if (txtPaises.text == nil || [txtPaises.text isEqualToString:@""] ) {
        txtDepartamentos.text = txtMunicipios.text = txtEventos.text = nil;
        txtDepartamentos.enabled = txtMunicipios.enabled = txtEventos.enabled = NO;
    }else if ((txtDepartamentos.text == nil || [txtDepartamentos.text isEqualToString:@""]) && [txtPaises.text isEqualToString:@"Colombia"] ) {
        txtMunicipios.text = txtEventos.text = nil;
        txtMunicipios.enabled = NO;
        txtMunicipios.placeholder = @"Ingrese primero depto";
    }else if ((txtMunicipios.text == nil || [txtMunicipios.text isEqualToString:@""])) {
        txtEventos.text = nil;
    }
    
    [[self view] endEditing:TRUE];
}

#pragma mark UIPickerViewDatasource methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag == 1) {
        return [eveDepartamentos count];
    }else if(pickerView.tag == 2){
        return [eveMunicipios count];
    }
    else{
        return [eveEventos count];
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView.tag == 1) {
        return [eveDepartamentos objectAtIndex:row];
    }else if(pickerView.tag == 2)
        return [eveMunicipios objectAtIndex:row];
    else{
        NSLog(@"titulo y %d", row);
        
        if ([eveEventos count] > row) {
            return [eveEventos objectAtIndex:row];
        }
        return 0;
    }
}

#pragma mark UIPickerViewDelegate methods

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (row == 0) {
        return;
    }
    if (pickerView.tag == 1) {
        txtDepartamentos.text = [eveDepartamentos objectAtIndex:row];
        txtMunicipios.enabled = YES;
        txtMunicipios.text = txtEventos.text = nil;
        txtMunicipios.placeholder = @"Seleccione ciudad";
    }else if(pickerView.tag == 2){
        txtMunicipios.text = [eveMunicipios objectAtIndex:row];
        txtEventos.text = nil;
    }else{
        txtEventos.text = [eveEventos objectAtIndex:row];
        
    }
    [[self view] endEditing:TRUE];
    [pickerView removeFromSuperview];
}

#pragma marl - UIAlertView delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex != 0) {
        [self publicarEnRedSocialElEvento: self.eventoCompartir];
    }
    
}

#pragma mark UITextFieldDelegate methods

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag != 0) return NO;
    autoCompletarTableView.hidden = NO;
    
    NSString *subString = [NSString stringWithString:textField.text];
    subString = [subString stringByReplacingCharactersInRange:range withString:string];
    
    [self buscarEntradasAutocompletarConSubstring:subString];
    
    return YES;
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag == 1) {
        [self buscarPorDepartamento];
        pickerDepartamentos.hidden =  NO;
        textField.inputView = pickerDepartamentos;
    }else if (textField.tag == 2){
        [self buscarPorMunicipio];
        pickerMunicipios.hidden = NO;
        textField.inputView = pickerMunicipios;
    }else if(textField.tag == 3){
        [self buscarPorEvento];
        pickerEventos.hidden = NO;
        textField.inputView = pickerEventos;
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
    return [posiblesPaises count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString * nombreCeldas = @"celdasdPais";
    UITableViewCell * celda = [tableView dequeueReusableCellWithIdentifier:nombreCeldas];
    if (celda == nil) {
        celda = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nombreCeldas];
        
    }
    
    celda.textLabel.text = [posiblesPaises objectAtIndex:indexPath.row];
    return celda;
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString * paisSelec = [NSString stringWithString:selectedCell.textLabel.text];
    txtPaises.text = paisSelec;
    autoCompletarTableView.hidden = YES;
    txtDepartamentos.text = txtMunicipios.text = txtEventos.text = nil;
    indicadorActividad.hidden = NO;
    
    [indicadorActividad startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        [self consumaJson: txtPaises.text];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view endEditing:YES];
            
            if ([eventosFinales count] == 0) {
                txtPaises.text = nil;
                UIAlertView * alerta = [[UIAlertView alloc] initWithTitle:@"Alerta" message:@"No se encontró ningún registro" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
                [alerta show];
                [indicadorActividad stopAnimating];
                return;
                
                
            }else if ([paisSelec isEqualToString:@"Colombia"]) {
                txtDepartamentos.enabled = YES;
                txtDepartamentos.placeholder = @"Seleccione depto";
                txtMunicipios.placeholder = @"Ingrese primero depto";
                
                
            }else{
                txtDepartamentos.placeholder = @"Válido para Colombia";
                txtDepartamentos.enabled = NO;
                txtMunicipios.enabled = YES;
                txtMunicipios.placeholder = @"Seleccione ciudad";
                
            }
            txtEventos.placeholder = @"Selecione evento";
            txtEventos.enabled = YES;
            [indicadorActividad stopAnimating];
            [indicadorActividad setHidden:YES];
            botonMostrar.enabled = YES;
            botonLimpiar.enabled = YES;
            
            
        });
    });
    
}

-(void)viewDidAppear:(BOOL)animated{
    //Se compurba que hay conexion a internet
    if (![[Reachability reachabilityWithHostname:@"www.google.com"] isReachable]) {
        [self deshabilitarTodo];
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setPickerDepartamentos:nil];
    [self setPickerMunicipios:nil];
    [self setPickerMunicipios: nil];
    [self setIndicadorActividad:nil];
    [self setTxtPaises:nil];
    [self setTxtDepartamentos:nil];
    [self setTxtMunicipios:nil];
    [self setTxtEventos:nil];
    [super viewDidUnload];
}
@end
