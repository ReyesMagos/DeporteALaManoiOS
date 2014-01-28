//
//  Marcador.m
//  DeporteALaMano
//
//  Created by imaclis on 20/11/13.
//  Copyright (c) 2013 Felipe. All rights reserved.
//

#import "Marcador.h"
#import "Escenario.h"

@implementation Marcador

@synthesize coordenada;
@synthesize titulo, subtitulo, escenario, listaEventos;

-(id)initWithCoordenada:(CLLocationCoordinate2D)laCordenada andTitulo:(NSString *)elTitulo andSubtitulo:(NSString *)elSubtitulo{
    self.coordenada = laCordenada;
    self.titulo = elTitulo;
    self.subtitulo = elSubtitulo;
    return self;
}

-(NSString *)title{
    return titulo;
}

-(NSString *)subtitle{
    return  subtitulo;
}

-(CLLocationCoordinate2D)coordinate{
    return coordenada;
}

@end
