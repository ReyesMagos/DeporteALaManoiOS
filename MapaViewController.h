//
//  MapaViewController.h
//  DeporteALaMano
//
//  Created by Felipe on 14/11/13.
//  Copyright (c) 2013 Felipe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "EscenariosViewController.h"

@interface MapaViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapa;

@property (nonatomic, strong) NSMutableArray* escenariosFin;

-(void) imprimeMarcadores;
@end