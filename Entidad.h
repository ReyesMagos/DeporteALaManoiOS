//
//  Entidad.h
//  DeporteALaMano
//
//  Created by Felipe on 14/11/13.
//  Copyright (c) 2013 Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Evento.h"

@interface Entidad : NSObject

@property (nonatomic, strong) NSMutableArray * escenarios;
@property (nonatomic, strong) Evento * evento;

+(Entidad *) sharedManager;

@end
