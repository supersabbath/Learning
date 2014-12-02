//
//  AirlinesListTableViewController.m
//  Odigeo
//
//  Created by Fernando Canon on 02/12/14.
//  Copyright (c) 2014 Fernando Canon. All rights reserved.
//

#import "AirlinesListTableViewController.h"
#import "AirlineTableViewCell.h"

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

-(void) configureCoreDateFetchRequest{
    
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"InBoundFlight"];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"airline"
                                                                   ascending:YES];
    
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
   
    
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setReturnsDistinctResults:YES];
    [fetchRequest setPropertiesToFetch:@[@"airline"]];
    [fetchRequest setFetchBatchSize:20];
    self.fetchDataSource.delegate = self;
    
    self.fetchDataSource.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}

@end
