//
//  EventosNoveTableViewController.m
//  DeporteALaMano
//
//  Created by Reyes Magos on 15/11/13.
//  Copyright (c) 2013 Reyes Magos. All rights reserved.
//

#import "EventosNoveTableViewController.h"
#import "Reachability.h"
#import "Json.h"
#import "Evento.h"
#import "Entidad.h"
#import "EventoTableViewCell.h"
#import "Social/Social.h"

@interface EventosNoveTableViewController ()

@property (nonatomic, strong) Evento * eventoSeleccionado;
@property (nonatomic, strong) NSString * tituloFooter;
@end

@implementation EventosNoveTableViewController
@synthesize diaHoy, primerDiaMes, posiblesFechas, consumidos, eventoSeleccionado, eventosEnCurso, eventosSemana, botonIrAlMapa, diaUnaSemana, tituloFooter;

- (id)initWithStyle:(UITableViewStyle)style
{
    
    self = [super initWithStyle:style];
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
    //Inicializo los arrays
    posiblesFechas = [[NSMutableArray alloc]init];
    consumidos = [[NSMutableArray alloc]init];
    eventosEnCurso = [[NSMutableArray alloc]init];
    eventosSemana = [[NSMutableArray alloc]init];
    eventoSeleccionado = [[Evento alloc]init];
    
    [self obtenerFechas];
    if ([[Reachability reachabilityWithHostname:@"www.google.com"] isReachable]) {
        NSLog(@"Conectado a internet");
        [self consumaJson];
    }else{
        UIAlertView * alerta = [[UIAlertView alloc] initWithTitle:@"No hay conexión a internet" message:@"No se ha podido detectar ninguna conexión a internet. \n\nUsted podrá navegar por la aplicación pero algunas opciones no estarán disponibles hasta que restaure la conexión a internet." delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        [alerta show];
        tituloFooter = @"Esperando Conexión a internet para mostrar el listado de eventos...";
    }
}

//Este metodo se encarga de notificar a este view si hubo cambios en la conexión a internet
- (void)reachabilityDidChange:(NSNotification *)notification {
    Reachability *reachability = (Reachability *)[notification object];
    if ([reachability isReachable]) {
        NSLog(@"Conectado a internet");
        [self consumaJson];
        if ([eventosSemana count] == 0) {
            tituloFooter = @"No se encontró ningun evento está semana";
            [self.tableView reloadData];
        }else{
            tituloFooter = @"Este es el listado de los eventos que comenzarán esta semana a nivel nacional e internacional";
        }
        
        [self.tableView reloadData];
    } else {
        NSLog(@"Sin conexión a internet");
    }
}

-(void)obtenerFechas{
    //Obtengo el calendario actual
    NSCalendar * calendarioActual = [NSCalendar currentCalendar];
    
    //Formato que debe tener las fechas: Dia-Mes-Año
    NSDateFormatter *formato = [[NSDateFormatter alloc]init];
    [formato setDateFormat:@"dd/MM/yyyy"];
    
    //Se obtiene la fecha actual y la convierto a string
    diaHoy = [formato stringFromDate:[NSDate date]];

    //Convierto la fecha en string
    //diaUnaSemana = [formato stringFromDate:fechaSemana];
    
    //Obtengo la fecha del primer dia del mes y convierto a string
    
    NSDateComponents *comp = [calendarioActual components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate: [NSDate date]];
    [comp setDay:1];
    NSDate * fechaPrimero = [calendarioActual dateFromComponents:comp];
    primerDiaMes = [formato stringFromDate:fechaPrimero];
    
    NSDateComponents * componen = [[NSDateComponents alloc]init];
    
    
    for(int i = 0; i < 6; i++){
        [componen setDay:i];
        NSDate * fch = [calendarioActual dateByAddingComponents:componen toDate:[NSDate date] options:0];
        NSString * prueba = [formato stringFromDate:fch];
        [posiblesFechas addObject:prueba];
        
    }
    
    
}

//Este metodo obtiene todas las fechas desde el primer dia del mes hasta el dia despues de una semana --
-(void) buscarFechasSemana{
    NSDateFormatter *formato = [[NSDateFormatter alloc]init];
    [formato setDateFormat:@"dd/MM/yyyy"];
    NSCalendar * calendarioActual = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendarioActual components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate: [NSDate date]];
    //Lleno el array de las posibles fechas, comenzando con el primer dia de la semana hasta el dia después de una semana
    for (int i =1; i<= [[self diaUnaSemana] intValue]; i++) {
        [comp setDay:i];
        NSString* fch = [formato stringFromDate:[calendarioActual dateFromComponents:comp]];
        [posiblesFechas addObject:fch];
    }
}

-(void)consumaJson{
    NSMutableString* completo = [NSMutableString stringWithFormat:@"http://servicedatosabiertoscolombia.cloudapp.net/v1/coldeportes/consolidadoeventos?$orderby=fechadesde asc&$filter=fechadesde eq '%@'", [posiblesFechas objectAtIndex:0]];
    
    for (int i = 1; i< [posiblesFechas count]; i++) {
        NSString* aux =[NSString stringWithFormat: @" or fechadesde eq '%@'", [posiblesFechas objectAtIndex:i]];
        [completo appendString:aux];
    
    }
    
    [completo appendString:@"&$format=json"];
    
    NSDictionary * json = [[[Json alloc] init]jsonConContenidoDeURLString:completo];
    
    NSArray* posibles = [json objectForKey:@"d"];
    
    
    if ([posibles count] == 0) {
        NSLog(@"No se encontro nada");
        return;
    }
    
    [self buscaEventos:posibles];

}

-(void)buscaEventos:(NSArray *)posibles{
    for (int i = 0; i< [posibles count]; i++) {
        NSDictionary * diccAux = (NSDictionary *)[posibles objectAtIndex:i];
        [eventosSemana addObject:[[Evento alloc]initWithNSDictionaty:diccAux]];
    }
}


-(BOOL) posiblesFechasEstanEntre: (int) desde y: (int) hasta{
    int hoy = [diaHoy intValue];
    for (int i = hoy; i < [posiblesFechas count]; i++) {
        int posibleI = [[posiblesFechas objectAtIndex:i] intValue];
        if (posibleI >= desde && posibleI <= hasta) {
            return YES;
        }
    }
    return NO;
    
}



-(void)publicarEnRedSocial: (NSString *) redSocial elEvento: (Evento *)evento{
    NSString * info = [NSString stringWithFormat:@"Voy a ir a: %@,  el día: %@, en: %@ - %@", [evento nombre], [evento fechadesde], [evento lugar], [evento pais]];
    
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UIAlertView delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex != 0) {
        [self publicarEnRedSocial:nil elEvento: eventoSeleccionado];
    }
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [eventosSemana count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Eventos esta semana";

}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    //return @"Este es el listado de los eventos que comenzarán esta semana a nivel nacional e internacional";
    return tituloFooter;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"celdaEventosTable";
    
    EventoTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[EventoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configuración de cada celda
    int roww = [indexPath row];

    Evento * ind = [self.eventosSemana objectAtIndex:roww];
    cell.nombreEvento.text = [ind nombre];
    cell.lugarEvento.text = [NSString stringWithFormat:@"%@ - %@", [ind lugar], [ind pais]];
    cell.fechaEvento.text = [ind fechadesde];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    eventoSeleccionado = [eventosSemana objectAtIndex:[indexPath row]];

    NSString *nombreEsc;
    NSString * titulo = @"Descripción del Evento";
    
    
    if (eventoSeleccionado.escenarioF != nil) {
        nombreEsc = eventoSeleccionado.escenarioF.nombre;
    }else{
        nombreEsc = @"Sin información";
    }
    
    NSString * mensaje = [NSString stringWithFormat: @"Evento: %@ \nEntidad: %@ \nTipo: %@ \nFecha inicio: %@ \nFecha finalización: %@ \nLocalización: %@ - %@ \nEscenario: %@, \nDescripción: %@ \nPagina Web: %@ \nEmail: %@", [eventoSeleccionado nombre], [eventoSeleccionado entidad], [eventoSeleccionado tipo], [eventoSeleccionado fechadesde], [eventoSeleccionado fechahasta], [eventoSeleccionado pais], [eventoSeleccionado lugar], nombreEsc, [eventoSeleccionado descripciondelevento], [eventoSeleccionado paginaweb], [eventoSeleccionado email]];
    UIAlertView * alerta;
    alerta = [[UIAlertView alloc] initWithTitle:titulo message:mensaje delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Compartir evento", nil];
    [alerta show];
}

@end
