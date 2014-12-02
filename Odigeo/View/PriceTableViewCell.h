//
//  CellViewTableViewCell.h
//  Odigeo
//
//  Created by Fernando Canon on 30/11/14.
//  Copyright (c) 2014 Fernando Canon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PriceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *inBoundOrigin;
@property (weak, nonatomic) IBOutlet UILabel *inBoundDestination;

@end
