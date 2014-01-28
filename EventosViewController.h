//
//  EventosViewController.h
//  DeporteALaMano
//
//  Created by Felipe on 7/11/13.
//  Copyright (c) 2013 Felipe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventosViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NSArray* paises;
@property (nonatomic, strong) NSMutableArray * eventosFinales;
@property (nonatomic, strong) NSMutableArray * eveDepartamentos;
@property (nonatomic, strong) NSMutableArray * eveMunicipios;
@property (nonatomic, strong) NSMutableArray * eveEventos;

//Propiedades para los pickers
@property (strong, nonatomic) IBOutlet UIPickerView *pickerDepartamentos;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerMunicipios;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerEventos;


// IBOultes para cada textfield del view
@property (strong, nonatomic) IBOutlet UITextField *txtPaises;
@property (strong, nonatomic) IBOutlet UITextField *txtDepartamentos;
@property (strong, nonatomic) IBOutlet UITextField *txtMunicipios;
@property (strong, nonatomic) IBOutlet UITextField *txtEventos;
@property (strong, nonatomic) IBOutlet UILabel *labelNoConexion;

// Propiedades para opcion de autocompletar
@property (nonatomic, strong) UITableView *autoCompletarTableView;
@property (nonatomic, strong) NSMutableArray *posiblesPaises;

//Propiedades para los elemenentos del view
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicadorActividad;
@property (strong, nonatomic) IBOutlet UIButton *botonMostrar;
@property (strong, nonatomic) IBOutlet UIButton *botonLimpiar;

-(void) buscarEntradasAutocompletarConSubstring : (NSString *) substring;

-(void) consumaJson:(NSString *)pais;
-(void) llenaEventos: (NSArray*) array;
-(void) buscarPorDepartamento;
-(void) buscarPorMunicipio;
-(void)buscarEscenariosSegunEventos: (NSArray * ) eventos;

//Actions para los dos botones
- (IBAction)botonLimpiar:(id)sender;
- (IBAction)botonMostrar:(id)sender;


@end
