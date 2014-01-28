//
//  EscenariosViewController.h
//  DeporteALaMano
//
//  Created by Felipe on 7/11/13.
//  Copyright (c) 2013 Felipe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Json.h"

@class EscenariosViewController;
@protocol PasarEscenarioMapa <NSObject>

-(void) agregarEscenarioViewController: (EscenariosViewController *) controller conEscenarios: (NSArray*) escenarios;

@end

@interface EscenariosViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>


@property (nonatomic, weak) id <PasarEscenarioMapa> delegate;


@property (strong, nonatomic) IBOutlet UITextField *txtDepartamento;
@property (strong, nonatomic) IBOutlet UITextField *txtMunicipio;
@property (strong, nonatomic) IBOutlet UITextField *txtEscenario;

@property (nonatomic, strong) UITableView *autoCompletarTableView;
@property (nonatomic, strong) NSArray *departamentos;
@property (nonatomic, strong) NSMutableArray *posiblesDepartamentos;

@property (strong, nonatomic) IBOutlet UIPickerView *pickerMunicipios;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerEscenarios;

@property (nonatomic, strong) NSMutableArray * escenariosFinales;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicadorActividad;

@property (nonatomic, strong) NSMutableArray * esceDepartamentos;
@property (nonatomic, strong) NSMutableArray * esceMunicipios;

@property (nonatomic, strong) NSMutableArray * escenariosfiltrados;

@property (strong, nonatomic) IBOutlet UIButton *botonMostrar;
@property (strong, nonatomic) IBOutlet UIButton *botonLimpiar;

@property (strong, nonatomic) IBOutlet UILabel *labelNoConexion;


-(IBAction)textFieldReturn:(id)sender;

-(void) buscarEntradasAutocompletarConSubstring : (NSString *) substring;

-(void) consumaJson: (NSString*) depar;

-(void) llenaEscenarios: (NSArray *) array;

-(void) buscaPorMunicipio;

-(void) filtraEscenarios: (NSString *) muni conNombre: (NSString*) nom;

- (IBAction)botonNvaBusqueda:(id)sender;
- (IBAction)MostrarBoton:(id)sender;



@end
