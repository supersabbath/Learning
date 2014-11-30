//
//  TicketsListViewControllerTableViewController.m
//  Odigeo
//
//  Created by Fernando Canon on 29/11/14.
//  Copyright (c) 2014 Fernando Canon. All rights reserved.
//

#import "TicketsTableViewController.h"
#import "FetchedResultsControllerDataSource.h"
#import "Ticket.h"
#import "InBoundFlight.h"
#import "OutBoundFlight.h"
#import "PriceTableViewCell.h"

static NSString *const reuseCellID = @"PriceTableViewCell";

@interface TicketsTableViewController () <FetchedResultsControllerDataSourceDelegate>


@property (strong, nonatomic) IBOutlet FetchedResultsControllerDataSource *fetchDataSource;

@end

@implementation TicketsTableViewController

#pragma mark -ViewController livecycle
 

- (void)viewDidLoad
{
   
    
    [super viewDidLoad];
    
    [self configureEdgeLayout];
    
    UINib *cellNib = [UINib nibWithNibName:reuseCellID bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:reuseCellID];

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Ticket"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"amount" ascending:YES]];
    [request setFetchBatchSize:20];
    
    self.fetchDataSource.delegate = self;
    self.fetchDataSource.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.fetchDataSource.reuseIdentifier = reuseCellID;
 
}

-(void) viewDidAppear:(BOOL)animated
{
    [self.fetchDataSource.fetchedResultsController performFetch:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark -FetchedResultsControllerDataSource

- (void)configureCell:(PriceTableViewCell *)cell withObject:(Ticket*) flightTicket
{
    
    cell.fromLabel.text = [flightTicket.inBoundFlight origin];
    cell.priceLabel.text = [flightTicket.amount stringValue];
    cell.destinationLabel.text = flightTicket.inBoundFlight.destiny;
}

- (void)deleteObject:(id)object
{
    
}

@end
