//
//  Json.m
//  DeporteALaMano
//
//  Created by Felipe on 8/11/13.
//  Copyright (c) 2013 Felipe. All rights reserved.
//

#import "Json.h"

@implementation Json

/*
 Este metodo permite obtener los datos en formato JSON del set de datos. 
 Serializa los datos y lo retorna en formato NSDictionary.
 @params url: direccion web de la localizacion del set de datos
 @return NSDictionary con la informacion JSON Serializada
 */
-(NSDictionary*) jsonConContenidoDeURLString: (NSString*) url{
    
    //Codificamos la url que entra en el formato UTF 8. Esto a raiz de si la url contiene tildes o espacios
    NSString *codificado = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"imprimo codificado: %@", codificado);
    
    //Se obtiene el contenido de la url, se almacena como NSData
    NSData* data = [NSData dataWithContentsOfURL: [NSURL URLWithString: codificado]];
    __autoreleasing NSError* error = nil;
    
    //Se inicializa el diccionario
    NSDictionary *retorno = [[NSDictionary alloc]init];
    
    //del NSData usando el metodo JSONOBjectData se serializa los datos y se guarga en el diccionario
    retorno = [NSJSONSerialization JSONObjectWithData: data options:kNilOptions error:&error];
    if (error != nil) {
        return nil ;
    }
    return retorno;
}

-(void)consuma: (NSData*) data{
    
}

@end
