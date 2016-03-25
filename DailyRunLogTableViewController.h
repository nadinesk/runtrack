//
//  DailyRunLogTableViewController.h
//  RunZen
//
//  Created by Nadine Khattak on 3/15/16.
//  Copyright © 2016 Ensach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface DailyRunLogTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong) NSMutableArray *theMiles;

@property UIView *nomatchesView;

@end
