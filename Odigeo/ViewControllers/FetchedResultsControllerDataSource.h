//
// Created by Chris Eidhof
//


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@class NSFetchedResultsController;

@protocol FetchedResultsControllerDataSourceDelegate<NSObject>

- (void)configureCell:(id)cell withObject:(id)object;
- (void)deleteObject:(id)object;

@end



@interface FetchedResultsControllerDataSource : NSObject <UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;
@property (nonatomic, weak) id<FetchedResultsControllerDataSourceDelegate> delegate;
@property (nonatomic, copy) NSString* reuseIdentifier;
@property (nonatomic) BOOL paused;

 
- (id)objectAtIndexPath:(NSIndexPath*)indexPath;
- (id)selectedItem;

@end