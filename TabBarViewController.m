//
//  TabBarViewController.m
//  DeporteALaMano
//
//  Created by imaclis on 29/11/13.
//  Copyright (c) 2013 Felipe. All rights reserved.
//

#import "TabBarViewController.h"
#import "EscenariosViewController.h"
#import "EventosNoveTableViewController.h"

@interface TabBarViewController ()
@property (nonatomic, strong) UIBarButtonItem * regresarNovedades;
@property (nonatomic, strong) UIBarButtonItem * regresarAnterior;
@end

@implementation TabBarViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    self.regresarNovedades = [[UIBarButtonItem alloc] initWithTitle:@"Novedades" style:UIBarButtonItemStyleBordered target:self action:@selector(popToRootAlertAction:)];
    self.regresarAnterior = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(popToBack:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    int tamano = [self.navigationController.viewControllers indexOfObject:self];
    
    //Si no ha realidado alguna busqueda, entonces los view controles en el navigation serán 2 entonces que se salga
    if (tamano < 2) {
        return;
    }
    
    //Esto es para cambiar tanto el titulo como el boton de atras en el navigation para cuando se selecciona un especifico tab
    if ([[viewController title] isEqualToString:@"Mapa"]) {
        self.navigationItem.title = @"Mapa";
        NSString *txt = [[self.navigationController.viewControllers objectAtIndex:tamano -1] title];
        self.regresarAnterior.title = txt;
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.leftBarButtonItem = [self regresarAnterior];
        
    }else{
        self.navigationItem.title = @"Búsqueda";
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.leftBarButtonItem = [self regresarNovedades];
    }
    
    
}
//Al ejecutarse que me devuelva al view raiz de la aplicación
-(void)popToRootAlertAction: (UIBarButtonItem*) sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
    //[self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
}
//Al ejecutarse que me devuelva al view anterior en la pila del navigation
-(void)popToBack: (UIBarButtonItem *) sender{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
