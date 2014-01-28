//
//  EventoTableViewCell.h
//  DeporteALaMano
//
//  Created by Felipe on 15/11/13.
//  Copyright (c) 2013 Felipe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventoTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nombreEvento;
@property (strong, nonatomic) IBOutlet UILabel *lugarEvento;
@property (strong, nonatomic) IBOutlet UILabel *fechaEvento;




@end
