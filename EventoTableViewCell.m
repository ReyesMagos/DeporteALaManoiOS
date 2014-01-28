//
//  EventoTableViewCell.m
//  DeporteALaMano
//
//  Created by Felipe on 15/11/13.
//  Copyright (c) 2013 Felipe. All rights reserved.
//

#import "EventoTableViewCell.h"

@implementation EventoTableViewCell
@synthesize nombreEvento, lugarEvento, fechaEvento;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
