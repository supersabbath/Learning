//
//  AirlinesListTableViewController.m
//  Odigeo
//
//  Created by Fernando Canon on 02/12/14.
//  Copyright (c) 2014 Fernando Canon. All rights reserved.
//

#import "AirlinesListTableViewController.h"
#import "AirlineTableViewCell.h"
#import "FCPCoreDataStore.h"

static NSString *const airlineCellID = @"airlineCellID";
@interface AirlinesListTableViewController ()

@end

@implementation AirlinesListTableViewController

- (void)viewDidLoad {

    [super viewDidLoad];

}

-(void) cellFromNib {
    
    UINib *cellNib = [UINib nibWithNibName:@"AirlineTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:airlineCellID];
    
}

-(void) configFetchDataSouce {
    
    self.fetchDataSource.delegate = self;
    self.fetchDataSource.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.mainRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.fetchDataSource.reuseIdentifier = airlineCellID;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
     
}


#pragma mark -FetchedResultsControllerDataSource

- (void)configureCell:(AirlineTableViewCell *)cell withObject:(NSDictionary*) result
{
    cell.airlineName.text = result[@"airline"];
}


#pragma mark - TableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {


    NSDictionary *airlines = [self.fetchDataSource.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSString* airline = airlines[@"airline"] ;
  
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Ticket"];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"euroPrice" ascending:YES];
   
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                                     @"ANY flights.airline LIKE[c]  %@ ",airline];
    
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
 
    [fetchRequest setFetchBatchSize:20];
    
    TicketsTableViewController *ticketsList =[[TicketsTableViewController alloc] initWithNibName:@"TicketsTableViewController" andFetchRequest:fetchRequest]; // Request pass as a dependency
    [ticketsList setManagedObjectContext:[FCPCoreDataStore mainQueueContext]];
    ticketsList.externalTitle = airline;
    
    [self.navigationController pushViewController:ticketsList animated:YES];
    

}





@end
