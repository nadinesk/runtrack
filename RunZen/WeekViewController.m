//
//  WeekViewController.m
//  RunZen
//
//  Created by Nadine Khattak on 3/13/16.
//  Copyright © 2016 Ensach. All rights reserved.
//

#import "WeekViewController.h"
#import "AppDelegate.h"

@interface WeekViewController ()

@end


@implementation WeekViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = delegate.managedObjectContext;
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] ;
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    long weekday = [comps weekday];
    NSLog(@"the wee %ld",weekday);
    NSDate *lastSunday = [[NSDate date] dateByAddingTimeInterval:-3600*24*(weekday-1)];
    NSDate *nextSaturday = [[NSDate date] dateByAddingTimeInterval:3600*24*((7 - weekday)%7)];
    
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateStyle:NSDateFormatterShortStyle];
    
    [defaults setObject:lastSunday forKey:@"firstDateRange"];
    [defaults setObject:nextSaturday forKey:@"lastDateRange"];
    
    NSNumber *goalNum = [defaults objectForKey:@"weekMilesGoal"];
    
    NSLog(@"goalNum, %@ ", goalNum);
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.weekGoal.text = @"";
}



- (IBAction)saveWeekGoal:(id)sender {

    NSString *weekGoaltext = self.weekGoal.text;
    
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *goalNumber = [f numberFromString:weekGoaltext];
    
    //NSError *error;
    

     if (weekGoaltext && weekGoaltext.length)
     {
         ;     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
         [defaults setObject:goalNumber forKey:@"weekMilesGoal"];
         
         
         NSNumber *goalNum = [defaults objectForKey:@"weekMilesGoal"];
         
         NSLog(@"goalNum, %@ ", goalNum);
         
     }
    
    
    
     else {
    // Show Alert View
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Your Weeks Miles Needs a Number" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
     }


}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
