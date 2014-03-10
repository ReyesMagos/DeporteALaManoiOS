//
//  DetalleEventosViewController.m
//  DeporteALaMano
//
//  Created by Felipe on 22/11/13.
//  Copyright (c) 2013 Felipe. All rights reserved.
//

#import "DetalleEventosViewController.h"
#import "EventoTableViewCell.h"
#import "Evento.h"
#import "Entidad.h"
#import <Social/Social.h>

@interface DetalleEventosViewController ()

@property (nonatomic,strong) Evento * eventoSeleccionado;

@end

@implementation DetalleEventosViewController

@synthesize eventoSeleccionado;

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
    //[[self listaEventos] removeObjectAtIndex:0];

}

-(void)publicarEnRedSocial: (NSString *) redSocial elEvento: (Evento *)evento{
    
    NSString * info = [NSString stringWithFormat:@"Voy a ir a: %@, Organizado por:%@, el día: %@, en: %@ - %@", [evento nombre], [evento entidad], [evento fechadesde], [evento lugar], [evento pais]];
    
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

#pragma marl - UIAlertView delegate

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
    return [[self listaEventos] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"celdaTable";
    
    EventoTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[EventoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    int roww = [indexPath row];
    NSLog(@"row %d", roww);
    
    Evento * ind = [self.listaEventos objectAtIndex:roww];
    int num = [ind escenario];
    NSString *esc = [ NSString stringWithFormat:@"%d",num];
    NSMutableString *escMutable = [NSMutableString stringWithString:[ind nombre]];
   	
    if (![esc isEqual:@"0"]) {
        
        [escMutable appendFormat: @"- Ver Mapa"];
        cell.nombreEvento.text = escMutable;
        cell.lugarEvento.text = [ind entidad];
        cell.fechaEvento.text = [ind fechadesde];
    }else{
        cell.nombreEvento.numberOfLines = 0;
        cell.nombreEvento.lineBreakMode = UILineBreakModeWordWrap;
        cell.lugarEvento.numberOfLines = 0;
        cell.lugarEvento.lineBreakMode = UILineBreakModeWordWrap;
        cell.nombreEvento.text = [ind nombre];
        cell.lugarEvento.text = [ind entidad];
        cell.fechaEvento.text = [ind fechadesde];
    }
    
   
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    eventoSeleccionado = [[self listaEventos] objectAtIndex:[indexPath row]];
    
    //NSString * titulo = @"Información";
    NSString * mensaje = [NSString stringWithFormat: @"%@", [eventoSeleccionado recuperarInformacion]];
    if (eventoSeleccionado.escenarioF != nil) {
        Entidad* en =[Entidad sharedManager];
        en.evento = eventoSeleccionado;
        en.escenarios = nil;
        
        UITabBarController *mapaIr2 = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"MenuTab"];
        mapaIr2.navigationItem.title = @"Mapa";
        [mapaIr2 setSelectedIndex:1];
        [self.navigationController pushViewController:mapaIr2 animated:YES];
    }else{
        UIAlertView * alerta = [[UIAlertView alloc] initWithTitle:@"Información" message:mensaje delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Compartir", nil];
        [alerta show];
    }
    
    
    
}

@end
