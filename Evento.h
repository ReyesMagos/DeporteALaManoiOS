//
//  Evento.h
//  DeporteALaMano
//
//  Created by Felipe on 14/11/13.
//  Copyright (c) 2013 Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Escenario.h"

@interface Evento : NSObject

@property (nonatomic, strong) NSString * nombre;
@property (nonatomic, strong) NSString * tipo;
@property (nonatomic, strong) NSString * fechadesde;
@property (nonatomic, strong) NSString * fechahasta;
@property (nonatomic, strong) NSString * pais;
@property (nonatomic, strong) NSString * lugar;
@property (nonatomic, strong) NSString * territorio;
@property (nonatomic, strong) NSString * entidad;
@property int escenario;
@property (nonatomic, strong) Escenario * escenarioF;
@property (nonatomic, strong) NSString * descripciondelevento;
@property (nonatomic, strong) NSString * paginaweb;
@property (nonatomic, strong) NSString * email;

-(id) initWithNSDictionaty: (NSDictionary *) dicc;
-(NSString *) recuperarInformacion;

@end
