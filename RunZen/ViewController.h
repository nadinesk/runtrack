//
//  ViewController.h
//  RunZen
//
//  Created by Nadine Khattak on 3/13/16.
//  Copyright © 2016 Ensach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *dailyMiles;
@property (weak, nonatomic) IBOutlet UILabel *todayDate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

