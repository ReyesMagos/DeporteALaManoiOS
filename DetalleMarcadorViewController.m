//
//  DetalleMarcadorViewController.m
//  DeporteALaMano
//
//  Created by imaclis on 20/11/13.
//  Copyright (c) 2013 Felipe. All rights reserved.
//

#import "DetalleMarcadorViewController.h"
#import "Reachability.h"
#import <Social/Social.h>

@interface DetalleMarcadorViewController ()

@end

@implementation DetalleMarcadorViewController

@synthesize escenario, imageViewUrl, textViewDetalles, indicadorActividad, labelNoDisponible, evento;

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:kReachabilityChangedNotification object:nil];
    [self cargarImagenDeUrl:escenario.imagenurl];
    if (evento != nil) {
        textViewDetalles.text = [textViewDetalles.text stringByAppendingString: [evento recuperarInformacion]];
    }else{
        textViewDetalles.text = [escenario recuperarInformacion];
    }
    textViewDetalles.backgroundColor = nil;
    
 
}

//Este metodo se encarga de notificar a este view si hubo cambios en la conexión a internet
- (void)reachabilityDidChange:(NSNotification *)notification {
    Reachability *reachability = (Reachability *)[notification object];
    if ([reachability isReachable]) {
    } else {
        NSLog(@"Sin conexión a internet");
    }
}

-(void) cargarImagenDeUrl: (NSURL *) url{
    
    indicadorActividad.hidden = NO;
    [indicadorActividad startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *datosImagen = [NSData dataWithContentsOfURL:url];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (datosImagen == nil) {
                self.imageViewUrl.image = [UIImage imageNamed: @"escenariodefecto.png"];
                self.imageViewUrl.contentMode = UIViewContentModeCenter;
                labelNoDisponible.hidden = NO;
            }else{
                self.imageViewUrl.image = [UIImage imageWithData:datosImagen];
            }
            [indicadorActividad stopAnimating];
            indicadorActividad.hidden = YES;
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)botonCompartir:(id)sender {
    
    
//    [[sender layer] setBorderWidth:1.0f];
//    [[sender layer] setCornerRadius:8.0f];
//    [[sender layer] setBackgroundColor:[UIColor whiteColor].CGColor];
//    [[sender layer] setBorderColor:[UIColor blueColor].CGColor];
    
    NSString * info;
    
    if (evento != nil) {
        info = [NSString stringWithFormat:@"Voy a ir a: %@, Organizado por: %@, el día: %@, en: %@ ", [evento nombre], [evento entidad], [evento fechadesde], [evento.escenarioF nombre]];
    }else{
        info = [NSString stringWithFormat:@"Nombre: %@ \nDirección: %@ \nTeléfono: %@ \nCiudad: %@ - %@", [escenario nombre], [escenario direccion], [escenario telefono], [escenario municipo], [escenario departamento]];
        if ([info length] > 140) {
            info = [NSString stringWithFormat:@"Nombre: %@ \nDirección: %@ \nTeléfono: %@", [escenario nombre], [escenario direccion], [escenario telefono]];
        }
        
    }
    
    

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
@end
