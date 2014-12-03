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
#import "Flight.h"
#import "PriceTableViewCell.h"
#import "WSCurrencyConverter.h"

static NSString *const reuseCellID = @"PriceTableViewCell";

@interface TicketsTableViewController () <FetchedResultsControllerDataSourceDelegate>

@end

@implementation TicketsTableViewController


#pragma mark -ViewController livecycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil andFetchRequest:(NSFetchRequest*)fetch
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    
    if (self) {
        _mainRequest =fetch;
    }
    return self;
}

- (void)viewDidLoad
{
    self.title =(_externalTitle)?_externalTitle :NSStringFromClass([self class]);
    [self cellFromNib];
    [self configFetchDataSouce];
    [self configureEdgeLayout];
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:@"FTCCoreDataImportFinish" object:nil];
}


-(void) reloadData:(NSNotification*) notifications {
    
    NSError * err=nil;
    [self.fetchDataSource.fetchedResultsController performFetch:&err];
    [self.tableView reloadData];
    
}

-(void) cellFromNib
{    
    UINib *cellNib = [UINib nibWithNibName:reuseCellID bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:reuseCellID];
    
}



-(void) configFetchDataSouce
{
    self.fetchDataSource.delegate = self;
    self.fetchDataSource.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:_mainRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
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
    
    cell.priceLabel.text = [self formatPriceForLabel:flightTicket.euroPrice];
    
    NSSet *set = [flightTicket flights];
    
    [set enumerateObjectsUsingBlock:^(Flight *obj, BOOL *stop) {
        NSLog(@"airlien %@",obj.airline);
        if ([obj.isInBound boolValue]) {
            [self configureLabelsForInBoundFlight:obj inCell:cell];
        }else{
            [self configureLabelsForOutBountFlight:obj inCell:cell];
        }
    }];
}



-(void) configureLabelsForOutBountFlight:(Flight*) flight inCell:(PriceTableViewCell*) cell
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd hh:mm"];
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormat setTimeZone:gmt];
    
    
    cell.fromLabel.text =[self concatDateString:[dateFormat stringFromDate:flight.departureDate] withCity: flight.origin];
    cell.destinationLabel.text = [self concatDateString:[dateFormat stringFromDate:flight.arrivalDate] withCity:flight.destiny];
    
}


-(void) configureLabelsForInBoundFlight:(Flight*) flight inCell:(PriceTableViewCell*) cell
{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YY-MM-dd hh:mm"];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormat setTimeZone:gmt];
    
    cell.inBoundOrigin.text =[self concatDateString:[dateFormat stringFromDate:flight.departureDate] withCity: flight.origin];
    cell.inBoundDestination.text  = [self concatDateString:[dateFormat stringFromDate:flight.arrivalDate] withCity:flight.destiny];
}   



#pragma mark -Currency string processing and formating
-(NSString*) concatDateString:(NSString*) dateString withCity:(NSString*) city {
    
    
    return [dateString stringByAppendingFormat:@" %@", city ];
}

-(NSString*) formatPriceForLabel:(NSDecimalNumber*) price {
    
    NSString *priceLabel = [NSString stringWithFormat:@"%.02f €",price.floatValue];
    return priceLabel;
}

- (void)deleteObject:(id)object
{
    
}



#pragma mark - TableViewDelegates

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 142;
}

@end
