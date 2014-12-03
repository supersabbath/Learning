//
//  GroupedFlightsTableControllerViewController.m
//  Odigeo
//
//  Created by Fernando Canon on 03/12/14.
//  Copyright (c) 2014 Fernando Canon. All rights reserved.
//

#import "GroupedFlightsTableControllerViewController.h"
#import "PriceTableViewCell.h"
#import "Flight.h"
#import "Ticket.h"

@interface GroupedFlightsTableControllerViewController ()

@end

@implementation GroupedFlightsTableControllerViewController



-(void) configFetchDataSouce
{
    self.fetchDataSource.delegate = self;
    self.fetchDataSource.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.mainRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"sectionIdentifier" cacheName:nil];
    self.fetchDataSource.reuseIdentifier = @"PriceTableViewCell";
}

// the delegate will query this method
-(BOOL) sectionableTable
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -FetchedResultsControllerDataSource

- (void)configureCell:(PriceTableViewCell *)cell withObject:(Flight*) flight
{
    Ticket *tmp = flight.ticket;
    
    cell.priceLabel.text = [self formatPriceForLabel:tmp.euroPrice];
    
    NSSet *set = [tmp flights];
    
    [set enumerateObjectsUsingBlock:^(Flight *obj, BOOL *stop) {
        NSLog(@"airlien %@",obj.airline);
        if ([obj.isInBound boolValue]) {
            [self configureLabelsForInBoundFlight:obj inCell:cell];
        }else{
            [self configureLabelsForOutBountFlight:obj inCell:cell];
        }
    }];
}


@end
