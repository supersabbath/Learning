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
@class WSCurrencyConverter;


@interface TicketsTableViewController : UITableViewController  <FetchedResultsControllerDataSourceDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) IBOutlet FetchedResultsControllerDataSource *fetchDataSource;

 
@end

