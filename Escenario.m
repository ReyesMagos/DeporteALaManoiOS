//
//  Escenario.m
//  DeporteALaMano
//
//  Created by Felipe on 8/11/13.
//  Copyright (c) 2013 Felipe. All rights reserved.
//

#import "Escenario.h"
#import "Evento.h"

@implementation Escenario

@synthesize claseUbicacion, departamento, deporte, descripcion, direccion, email, localidadComuna, codigo, tipo;
@synthesize municipo, nombre, paginaweb, razonSocial, telefono, ubicacion, latitud, longitud, imagenurl;

-(id)initWithNSDictionary:(NSDictionary *)dicc{
    self.nombre = [dicc objectForKey:@"nombre"];
    self.codigo = [[dicc objectForKey:@"codigo"] intValue];
    self.tipo = [dicc objectForKey:@"tipo"];
    self.deporte = [dicc objectForKey:@"deporte"];
    self.direccion = [dicc objectForKey:@"direccion"];
    self.telefono = [dicc objectForKey:@"telefono"];
    self.municipo = [dicc objectForKey:@"municipio"];
    self.departamento = [dicc objectForKey:@"departamento"];
    self.paginaweb = [dicc objectForKey:@"paginaweb"];
    self.email = [dicc objectForKey:@"email"];
    self.ubicacion = [dicc objectForKey:@"ubicacion"];
    self.razonSocial = [dicc objectForKey:@"razonsocial"];
    self.claseUbicacion = [dicc objectForKey:@"claseubicacion"];
    self.localidadComuna = [dicc objectForKey:@"localidadcomuna"];
    self.descripcion = [dicc objectForKey:@"descripcion"];
    self.latitud = [[dicc objectForKey:@"latitud"] floatValue];
    self.longitud = [[dicc objectForKey:@"longitud"] floatValue];
    self.imagenurl = [NSURL URLWithString: [dicc objectForKey:@"imagenurl"]];
    
    return self;
}
-(NSString *)recuperarInformacion{
    NSString * texto = [NSString stringWithFormat:@"Nombre: %@ \nTipo: %@ \nDeporte: %@ \nLocalización: %@ - %@ \nDirección: %@ \nDescripción: %@ \nTeléfono: %@", self.nombre, self.tipo, self.deporte, self.departamento, self.municipo, self.direccion, self.descripcion, self.telefono];
    return texto;
}


-(NSString *)recuperarInformacionDeEventos{
    NSString * textoEventos = @"";
    for (Evento* evento in self.listaEventos) {
        NSString * complemento = [NSString stringWithFormat:@"%@", [evento recuperarInformacion]];
        textoEventos = [textoEventos stringByAppendingString:complemento];
    }
    return textoEventos;
}


@end
