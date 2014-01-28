//
//  Json.h
//  DeporteALaMano
//
//  Created by Felipe on 8/11/13.
//  Copyright (c) 2013 Felipe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Json : NSObject

-(void)consuma: (NSData*) data;
-(NSDictionary*) jsonConContenidoDeURLString: (NSString*) url;
@end
