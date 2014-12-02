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
#import "WSCurrencyConverter.h"

static NSString *const reuseCellID = @"PriceTableViewCell";

@interface TicketsTableViewController () <FetchedResultsControllerDataSourceDelegate>

@property(strong,nonatomic)NSDateFormatter*dateFormat;
@end

@implementation TicketsTableViewController
@synthesize dateFormat;
#pragma mark -ViewController livecycle
 

- (void)viewDidLoad
{

    
    self.title =NSStringFromClass([self class]);
    
    [self cellFromNib];
   
    [self configureCoreDateFetchRequest];
    
    [self configureEdgeLayout];
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:@"FTCCoreDataImportFinish" object:nil];
}
-(void) reloadData:(NSNotification*) notifications {
    
    NSError * err=nil;
    [self.fetchDataSource.fetchedResultsController performFetch:&err];
      [self.tableView reloadData];
    
}

-(void) cellFromNib {
    
    UINib *cellNib = [UINib nibWithNibName:reuseCellID bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:reuseCellID];
    
}

-(void) configureCoreDateFetchRequest{


    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Ticket"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"euroPrice" ascending:YES]];
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


-(void) dealloc {
    
    [self stopObservingSALocaliztionNotifications];
}
#pragma mark -FetchedResultsControllerDataSource

- (void)configureCell:(PriceTableViewCell *)cell withObject:(Ticket*) flightTicket
{
  
    
    cell.fromLabel.text = [@"from: " stringByAppendingString:flightTicket.outBountFlight.origin];
    
    cell.destinationLabel.text = [@"to: " stringByAppendingString:flightTicket.outBountFlight.destiny];
    cell.priceLabel.text = [self formatPriceForLabel:flightTicket.euroPrice];
    
    cell.inBoundOrigin.text = [@"from: " stringByAppendingString:flightTicket.inBoundFlight.origin];
    cell.inBoundDestination.text = [@"from: " stringByAppendingString:flightTicket.inBoundFlight.destiny];

    
}


-(NSString*) formatPriceForLabel:(NSDecimalNumber*) price {
    
    NSString *priceLabel = [NSString stringWithFormat:@"%.02f €",price.floatValue];
    return priceLabel;
}

- (void)deleteObject:(id)object
{
    
}

#pragma mark -Currency Process
 


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 142;
}

@end
