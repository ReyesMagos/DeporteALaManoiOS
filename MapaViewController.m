//
//  MapaViewController.m
//  DeporteALaMano
//
//  Created by Reyes Magos on 14/11/13.
//  Copyright (c) 2013 Reyes Magos. All rights reserved.
//

#import "MapaViewController.h"
#import "Escenario.h"
#import "Entidad.h"
#import "Evento.h"
#import "Marcador.h"
#import "DetalleMarcadorViewController.h"

#import <AddressBook/AddressBook.h>

@interface MapaViewController ()
@property (nonatomic, strong) Evento * event;
@end

@implementation MapaViewController

@synthesize mapa, escenariosFin, event;

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
    
    //Mostramos la localizacion del usuario
    //mapa.showsUserLocation = YES;
    
    escenariosFin = [[NSMutableArray alloc]init];
    
    MKCoordinateRegion region;
    region.center.latitude = 4.60971;
    region.center.longitude = -74.08175;
    region.span.latitudeDelta = 14;
    region.span.longitudeDelta = 14;
    [mapa setRegion:region animated:NO];
    
}

-(void)imprimeMarcadores{
    if (event == nil) {
        for (Escenario* escenario in escenariosFin) {
            CLLocationCoordinate2D posicionMarcador;
            posicionMarcador.latitude = escenario.latitud;
            posicionMarcador.longitude = escenario.longitud;
            Marcador * marcadorAux = [[Marcador alloc] initWithCoordenada:posicionMarcador andTitulo:escenario.nombre andSubtitulo:escenario.direccion];
            [marcadorAux setEscenario:escenario];
            [mapa addAnnotation:marcadorAux];
        }
    }else{
        Escenario* escenario = event.escenarioF;
        CLLocationCoordinate2D posicionMarcador;
        posicionMarcador.latitude = escenario.latitud;
        posicionMarcador.longitude = escenario.longitud;
        Marcador * marcadorAux = [[Marcador alloc]initWithCoordenada:posicionMarcador andTitulo:event.nombre andSubtitulo:escenario.nombre];
        [marcadorAux setEvento:event];
        [marcadorAux setEscenario:escenario];
        [mapa addAnnotation:marcadorAux];
    }
    
    [self zoomToFitMapAnnotations:mapa];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"Marcador";
    if ([annotation isKindOfClass:[Marcador class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [mapa dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.pinColor = MKPinAnnotationColorGreen;
        annotationView.canShowCallout = YES;
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton setTitle:annotation.title forState:UIControlStateNormal];
        [annotationView setRightCalloutAccessoryView:rightButton];
        
        return annotationView;
    }
    
    return nil; 
}

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    if ([(UIButton*)control buttonType] == UIButtonTypeDetailDisclosure){
        DetalleMarcadorViewController * mapDetailViewController = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"DetalleMarcadorViewController"];
        Marcador *capturado = (Marcador*)[view annotation];
        mapDetailViewController.evento = [capturado evento];
        mapDetailViewController.escenario = [ capturado escenario];
        [[self navigationController] pushViewController:mapDetailViewController animated:YES];
    }
}

- (void)zoomToFitMapAnnotations:(MKMapView *)mapView {
    if ([mapView.annotations count] == 0) return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(id<MKAnnotation> annotation in mapView.annotations) {
        if ([[annotation title] isEqualToString:@"Current Location"]) {
            continue;
        }
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1;
    
    // Añado un pequeño espacio en los sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1;
    
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    Entidad * enn = [Entidad sharedManager];
    escenariosFin = enn.escenarios;
    event = enn.evento;
    if ( escenariosFin == nil && event == nil ) {
        return;
    }
    // Borro los marcadores que estaban en el mapa
    NSMutableArray * marcadoresAEliminar = [mapa.annotations mutableCopy];
    [mapa removeAnnotations:marcadoresAEliminar];
    [self imprimeMarcadores];
    
}

- (void)viewDidUnload {
    [self setMapa:nil];
    [super viewDidUnload];
}

@end
