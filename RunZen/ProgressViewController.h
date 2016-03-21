//
//  ProgressViewController.h
//  RunZen
//
//  Created by Nadine Khattak on 3/13/16.
//  Copyright © 2016 Ensach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "Day.h"
#import "Week.h"



@interface ProgressViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *weekGoalsSet;
@property (weak, nonatomic) IBOutlet UILabel *dailySum;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UILabel *weekDateRange;

@property (nonatomic, copy) NSDate *lastSunday;
@property (nonatomic, copy) NSDate *nextSaturday;

@property (nonatomic, copy) NSNumber *runSum;

@property (nonatomic, copy) NSString *runSumString;



@end


