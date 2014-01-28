//
//  EventosNoveTableViewController.h
//  DeporteALaMano
//
//  Created by Felipe on 15/11/13.
//  Copyright (c) 2013 Felipe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventosNoveTableViewController : UITableViewController <UIAlertViewDelegate>

@property (nonatomic, strong) NSString * diaHoy;
@property (nonatomic, strong) NSString * diaUnaSemana;

@property (nonatomic, strong) NSMutableArray * posiblesFechas;
@property (nonatomic, strong) NSMutableArray * eventosEnCurso;
@property (nonatomic, strong) NSMutableArray * eventosSemana;

@property (nonatomic, strong) NSString * primerDiaMes;

@property (nonatomic, strong) NSArray * consumidos;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *botonIrAlMapa;

-(void) consumaJson;

@end
