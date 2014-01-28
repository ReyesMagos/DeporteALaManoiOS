//
//  Marcador.h
//  DeporteALaMano
//
//  Created by imaclis on 20/11/13.
//  Copyright (c) 2013 Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Escenario.h"
#import "Evento.h"

@interface Marcador : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordenada;
@property (nonatomic, strong) NSString * titulo, *subtitulo;

@property (nonatomic, strong) Escenario* escenario;
@property (nonatomic, strong) Evento* evento;
@property (nonatomic, strong) NSMutableArray * listaEventos;

-(id)initWithCoordenada:(CLLocationCoordinate2D)laCordenada andTitulo:(NSString *)elTitulo andSubtitulo:(NSString *)elSubtitulo;

@end
