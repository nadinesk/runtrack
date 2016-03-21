//
//  WeekViewController.h
//  RunZen
//
//  Created by Nadine Khattak on 3/13/16.
//  Copyright © 2016 Ensach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface WeekViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *weekGoal;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@end
