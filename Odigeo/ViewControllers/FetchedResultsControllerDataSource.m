//
// Created by Chris Eidhof
//


#import <CoreData/CoreData.h>
#import "FetchedResultsControllerDataSource.h"



@interface FetchedResultsControllerDataSource ()

@property (nonatomic, strong) IBOutlet UITableView* tableView;

@end

@implementation FetchedResultsControllerDataSource

#pragma -DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return self.fetchedResultsController.sections.count;
}


- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    id<NSFetchedResultsSectionInfo> section = self.fetchedResultsController.sections[sectionIndex];
  
    return  section.numberOfObjects;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    id object = [self objectAtIndexPath:indexPath];
    
    id cell = [tableView dequeueReusableCellWithIdentifier:_reuseIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell=[UIView viewFromNib:_reuseIdentifier];
    }
  
    if ([self.delegate respondsToSelector:@selector(configureCell:withObject:)]) {
        [self.delegate configureCell:cell withObject:object];
    }
    
    return cell;
}


- (id)objectAtIndexPath:(NSIndexPath*)indexPath
{
    return [self.fetchedResultsController objectAtIndexPath:indexPath];

}

- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.delegate deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    }
}


#pragma mark NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController*)controller
{
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController*)controller
{
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController*)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath*)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath*)newIndexPath
{
    if (type == NSFetchedResultsChangeInsert) {
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else if (type == NSFetchedResultsChangeMove) {
        [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
    } else if (type == NSFetchedResultsChangeDelete) {
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else if (type == NSFetchedResultsChangeUpdate) {
        if ([self.tableView.indexPathsForVisibleRows containsObject:indexPath]) {
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    } else {
        NSAssert(NO,@"");
    }
}

- (void)setFetchedResultsController:(NSFetchedResultsController*)fetchedResultsController
{
    _fetchedResultsController = fetchedResultsController;
 
    //_fetchedResultsController.delegate = self;
    NSError *error =nil;
   
        if ([_fetchedResultsController performFetch:NULL] == NO) {
            NSLog(@"Invalid sort, %@",[error.userInfo debugDescription]);
        }
  
   
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:NSSelectorFromString(@"sectionableTable")]) {
        
    
    id <NSFetchedResultsSectionInfo> theSection = [[_fetchedResultsController sections] objectAtIndex:section];
    
        static NSDateFormatter *formatter = nil;
        
        if (!formatter)
        {
            formatter = [[NSDateFormatter alloc] init];
            [formatter setCalendar:[NSCalendar currentCalendar]];
            
            NSString *formatTemplate = [NSDateFormatter dateFormatFromTemplate:@"yyyy MMMM d" options:0 locale:[NSLocale currentLocale]];
            [formatter setDateFormat:formatTemplate];
        }
        
      
        
        NSArray *numericSection = [[theSection name] componentsSeparatedByString:@"-"];
        NSInteger year = [numericSection [0] integerValue];
        NSInteger month =  [numericSection [1] integerValue];
        NSInteger day = [numericSection[2] integerValue];
        
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        dateComponents.year = year;
        dateComponents.month = month;
        dateComponents.day = day;
        dateComponents.hour = [numericSection [2] integerValue];
        
        NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
        
        NSString *titleString = [formatter stringFromDate:date];
        
        NSInteger min = [numericSection [3] integerValue];
        switch (min) {
            case 0:
                titleString =[titleString stringByAppendingString:@" Morning"];
                break;
           case 1:
                titleString =[titleString stringByAppendingString:@" Afternoon"];
                break;
                case 2:

                titleString =[titleString stringByAppendingString:@" Evening"];
                break;
            default:
                break;
        }
        
        return titleString;
        
    }
    else return nil;
}


- (id)selectedItem
{
    NSIndexPath* path = self.tableView.indexPathForSelectedRow;
    return path ? [self.fetchedResultsController objectAtIndexPath:path] : nil;
}


- (void)setPaused:(BOOL)paused
{
    _paused = paused;
    if (paused) {
        self.fetchedResultsController.delegate = nil;
    } else {
        self.fetchedResultsController.delegate = self;
        [self.fetchedResultsController performFetch:NULL];
        [self.tableView reloadData];
    }
}


@end