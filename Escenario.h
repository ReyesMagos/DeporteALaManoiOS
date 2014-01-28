//
//  Escenario.h
//  DeporteALaMano
//
//  Created by Felipe on 8/11/13.
//  Copyright (c) 2013 Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Escenario : NSObject

@property (nonatomic, strong) NSString * nombre;
@property (nonatomic, strong) NSString * tipo;
@property (nonatomic, strong) NSString * deporte;
@property (nonatomic, strong) NSString * direccion;
@property (nonatomic, strong) NSString * telefono;
@property (nonatomic, strong) NSString * municipo;
@property (nonatomic, strong) NSString * departamento;
@property (nonatomic, strong) NSString * paginaweb;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * ubicacion;
@property (nonatomic, strong) NSString * razonSocial;
@property (nonatomic, strong) NSString * claseUbicacion;
@property (nonatomic, strong) NSString * localidadComuna;
@property (nonatomic, strong) NSString * descripcion;
@property float latitud;
@property float longitud;
@property int codigo;
@property (nonatomic, strong) NSURL * imagenurl;
@property (nonatomic, strong) NSMutableArray * listaEventos;

-(id) initWithNSDictionary: (NSDictionary*) dicc;
-(NSString *) recuperarInformacion;
-(NSString *) recuperarInformacionDeEventos;

@end
