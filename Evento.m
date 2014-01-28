//
//  Evento.m
//  DeporteALaMano
//
//  Created by Felipe on 14/11/13.
//  Copyright (c) 2013 Felipe. All rights reserved.
//

#import "Evento.h"

@implementation Evento

@synthesize nombre, tipo, fechadesde, fechahasta, pais, lugar, territorio, entidad, escenarioF;
@synthesize escenario, descripciondelevento, paginaweb, email;

-(id)initWithNSDictionaty:(NSDictionary *)dicc{
    self.nombre = [dicc objectForKey:@"nombre"];
    self.tipo = [dicc objectForKey:@"tipo"];
    self.fechadesde = [dicc objectForKey:@"fechadesde"];
    self.fechahasta = [dicc objectForKey:@"fechahasta"];
    self.pais = [dicc objectForKey:@"pais"];
    self.lugar = [dicc objectForKey:@"lugar"];
    self.territorio = [dicc objectForKey:@"territorio"];
    self.entidad = [dicc objectForKey:@"entidad"];
    self.escenario = [[dicc objectForKey:@"escenario"] intValue];
    self.descripciondelevento = [dicc objectForKey:@"descripciondelevento"];
    self.paginaweb = [dicc objectForKey:@"paginaweb"];
    self.email = [dicc objectForKey:@"email"];
    
    return self;
}

-(NSString *)recuperarInformacion{
    NSString * nombreEscenario = [self.escenarioF nombre];
    //Si el evento no tiene un escenario disponble:
    if (!nombreEscenario) {
        nombreEscenario = @"Sin información";
    }
    NSString * complemento = [NSString stringWithFormat:@"Evento: %@ \nEntidad: %@ \nTipo: %@ \nFecha inicio: %@ \nFecha finalización: %@ \nLocalización: %@ - %@ \nEscenario: %@ \nDescripción: %@ \nPágina Web: %@ \nEmail: %@", self.nombre, self.entidad, self.tipo, self.fechadesde, self.fechahasta, self.pais, self.lugar, nombreEscenario, self.descripciondelevento, self.paginaweb, self.email];
    return complemento;
}

@end
