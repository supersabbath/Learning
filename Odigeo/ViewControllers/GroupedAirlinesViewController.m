//
//  GroupedAirlinesViewController.m
//  Odigeo
//
//  Created by Fernando Canon on 03/12/14.
//  Copyright (c) 2014 Fernando Canon. All rights reserved.
//

#import "GroupedAirlinesViewController.h"
#import "AirlineTableViewCell.h"
#import "FCPCoreDataStore.h"

#import "GroupedFlightsTableControllerViewController.h"

@interface GroupedAirlinesViewController ()

@end

@implementation GroupedAirlinesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) configFetchDataSouce {
    
    self.fetchDataSource.delegate = self;
    self.fetchDataSource.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.mainRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.fetchDataSource.reuseIdentifier = @"airlineCellID";
}

#pragma mark -FetchedResultsControllerDataSource

- (void)configureCell:(AirlineTableViewCell *)cell withObject:(id) result
{
    cell.airlineName.text = result[@"airline"];
    
}

#pragma  mark -overide delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSDictionary *airlines = [self.fetchDataSource.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSString* airline = airlines[@"airline"] ;
    
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Flight"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"departureDate"
                                                                   ascending:YES];
    

    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"airline LIKE[c]  %@ ",airline];
    
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    
    [fetchRequest setFetchBatchSize:20];
    
    GroupedFlightsTableControllerViewController *ticketsList =[[GroupedFlightsTableControllerViewController alloc] initWithNibName:@"TicketsTableViewController" andFetchRequest:fetchRequest]; // Request pass as a dependency
    [ticketsList setManagedObjectContext:[FCPCoreDataStore mainQueueContext]];
    ticketsList.externalTitle = airline;
    
    [self.navigationController pushViewController:ticketsList animated:YES];
    
    
}

@end
