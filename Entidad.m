//
//  Entidad.m
//  DeporteALaMano
//
//  Created by Felipe on 14/11/13.
//  Copyright (c) 2013 Felipe. All rights reserved.
//

#import "Entidad.h"

@implementation Entidad

@synthesize escenarios, evento;

+(Entidad *)sharedManager{
    static Entidad * shareMyManager = nil;
    if (!shareMyManager) {
        shareMyManager = [[self alloc]init];
    }
    return shareMyManager;
}

@end