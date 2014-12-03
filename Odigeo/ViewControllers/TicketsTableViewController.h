//
//  TicketsListViewControllerTableViewController.h
//  Odigeo
//
//  Created by Fernando Canon on 29/11/14.
//  Copyright (c) 2014 Fernando Canon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FetchedResultsControllerDataSource.h"

@class  FetchedResultsControllerDataSource;
@class Ticket;
@class Flight;
@class WSCurrencyConverter;
@class PriceTableViewCell;

@interface TicketsTableViewController : UITableViewController  <FetchedResultsControllerDataSourceDelegate>

- (instancetype)initWithNibName:(NSString *)nibNameOrNil andFetchRequest:(NSFetchRequest*)fetch;


@property(strong,nonatomic) NSFetchRequest *mainRequest;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet FetchedResultsControllerDataSource *fetchDataSource;
@property (strong, nonatomic) NSString *externalTitle;
 
@end

/*
 Subclass available methods
 */
@interface TicketsTableViewController ()

-(void) configureLabelsForInBoundFlight:(Flight*) flight inCell:(PriceTableViewCell*) cell;
-(void) configureLabelsForOutBountFlight:(Flight*) flight inCell:(PriceTableViewCell*) cell;
-(NSString*) formatPriceForLabel:(NSDecimalNumber*) price;

@end
