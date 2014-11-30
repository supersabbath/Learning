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
    
    TicketsTableViewController *ticketsList =[[TicketsTableViewController alloc] initWithNibName:@"TicketsTableViewController" bundle:nil];
    [ticketsList setManagedObjectContext:[FCPCoreDataStore mainQueueContext]];
    [self pushViewController:ticketsList];
}



- (IBAction)presentAirlinesList:(id)sender
{

}


- (IBAction)presentTimeTablesLIst:(id)sender
{

}

-(void) pushViewController:(UIViewController*) viewController {
    
    [self.navigationController pushViewController:viewController animated:YES];
    
}
@end
