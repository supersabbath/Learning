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


static NSString *const reuseCellID = @"OdigeoCell";

@interface TicketsTableViewController () <FetchedResultsControllerDataSourceDelegate>


@property (strong, nonatomic) IBOutlet FetchedResultsControllerDataSource *fetchDataSource;

@end

@implementation TicketsTableViewController

#pragma mark -ViewController livecycle
- (void)viewDidLoad
{
   
    
    [super viewDidLoad];
    
    UINib *cellNib = [UINib nibWithNibName:@"Cell" bundle:nil];
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

- (void)configureCell:(UITableViewCell *)cell withObject:(Ticket*) flightTicket
{
    cell.textLabel.text = [flightTicket.amount stringValue];
    cell.detailTextLabel.text = flightTicket.currency;
}

- (void)deleteObject:(id)object
{
    
}

@end
