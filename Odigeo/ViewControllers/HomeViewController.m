//
//  ViewController.m
//  Odigeo
//
//  Created by Fernando Canon on 30/11/14.
//  Copyright (c) 2014 Fernando Canon. All rights reserved.
//

#import "HomeViewController.h"
#import "TicketsTableViewController.h"
#import "UIImage+ImageEffects.h"
#import "FCPCoreDataStore.h"
#import "AnimationMessageView.h"
#import "AirlinesListTableViewController.h"
#import "GroupedAirlinesViewController.h"

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet AnimationMessageView *messageView;
@property (weak, nonatomic) IBOutlet UIImageView *plane;
@end

@implementation HomeViewController

#pragma mark -ViewController livecycle

- (void)viewDidLoad
{
    self.title =NSStringFromClass([self class]);
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_backImageView setImage:[self blurWithImageEffects:[UIImage imageNamed:@"backImage.png"]]];
    [_messageView animateArc:_plane];
    [self configureEdgeLayout];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)blurWithImageEffects:(UIImage *)image
{
    return [image applyBlurWithRadius:10 tintColor:[UIColor colorWithWhite:1 alpha:0.2] saturationDeltaFactor:1.5 maskImage:nil];
}

#pragma mark - UI Actions
- (IBAction)presentPriceList:(id)sender
{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Ticket"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"euroPrice" ascending:YES]];
    [request setFetchBatchSize:20];
    
    TicketsTableViewController *ticketsList =[[TicketsTableViewController alloc] initWithNibName:@"TicketsTableViewController" andFetchRequest:request]; // REquest pass as a dependency
    [ticketsList setManagedObjectContext:[FCPCoreDataStore mainQueueContext]];
    [self pushViewController:ticketsList];
}



- (IBAction)presentAirlinesList:(id)sender
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Flight"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"airline"
                                                                   ascending:YES];
    
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setReturnsDistinctResults:YES];
    [fetchRequest setPropertiesToFetch:@[@"airline"]];
    [fetchRequest setFetchBatchSize:20];
    
    AirlinesListTableViewController* airlinesListViewController =[[AirlinesListTableViewController alloc] initWithNibName:@"AirlinesListTableViewController" andFetchRequest:fetchRequest];
    [airlinesListViewController setManagedObjectContext:[FCPCoreDataStore mainQueueContext]];
    [self pushViewController:airlinesListViewController];
}


- (IBAction)presentTimeTablesLIst:(id)sender
{

    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Flight"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"airline"
                                                                   ascending:YES];
    
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setReturnsDistinctResults:YES];
    [fetchRequest setPropertiesToFetch:@[@"airline"]];
    [fetchRequest setFetchBatchSize:20];
    
    GroupedAirlinesViewController* groupedAirlinesTVC =[[GroupedAirlinesViewController alloc] initWithNibName:@"AirlinesListTableViewController" andFetchRequest:fetchRequest];
    [groupedAirlinesTVC setManagedObjectContext:[FCPCoreDataStore mainQueueContext]];
    [self pushViewController:groupedAirlinesTVC];
    
}

-(void) pushViewController:(UIViewController*) viewController {
    
    [self.navigationController pushViewController:viewController animated:YES];
    
}
@end
