//
//  DetalleMarcadorViewController.h
//  DeporteALaMano
//
//  Created by imaclis on 20/11/13.
//  Copyright (c) 2013 Felipe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Escenario.h"
#import "Evento.h"

@interface DetalleMarcadorViewController : UIViewController

@property (nonatomic, strong) Escenario * escenario;
@property (nonatomic, strong) Evento* evento;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewUrl;
@property (strong, nonatomic) IBOutlet UILabel *labelNoDisponible;

@property (strong, nonatomic) IBOutlet UIButton *botonCompartir;

@property (weak, nonatomic) IBOutlet UITextView *textViewDetalles;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicadorActividad;

- (IBAction)botonCompartir:(id)sender;

@end
