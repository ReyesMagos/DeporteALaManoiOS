//
//  AcercaDeViewController.m
//  DeporteALaMano
//
//  Created by imaclis on 23/11/13.
//  Copyright (c) 2013 Felipe. All rights reserved.
//

#import "AcercaDeViewController.h"

@interface AcercaDeViewController ()

@end

@implementation AcercaDeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self textViewAdvertencia] setBackgroundColor:nil];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)volverBoton:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
