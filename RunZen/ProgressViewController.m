//
//  ProgressViewController.m
//  RunZen
//
//  Created by Nadine Khattak on 3/13/16.
//  Copyright © 2016 Ensach. All rights reserved.
//

#import "ProgressViewController.h"
#import "AppDelegate.h"
#import "Day.h"
#import "Week.h"
#import <Social/Social.h>


@interface ProgressViewController ()

@end


@implementation ProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDate *today = [[NSDate alloc] init];
    
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday
                                                       fromDate:today];
    
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay: 0 - ([weekdayComponents weekday] - 1)];
    
    NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract
                                                         toDate:today options:0];
    
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setDay: ((7 - [weekdayComponents weekday])%7)];
    
    NSDate *endingOfWeek = [gregorian dateByAddingComponents:componentsToAdd
                                                      toDate:today options:0];
    
    
    
    NSDateComponents *beginningComponents =
    [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth|
                           NSCalendarUnitDay) fromDate: beginningOfWeek];
    
    self.lastSunday = [gregorian dateFromComponents:beginningComponents];
    NSLog(@"begnningOfWeek, %@", self.lastSunday);
    
    NSDateComponents *endingComponents =
    [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth|
                           NSCalendarUnitDay) fromDate: endingOfWeek];
    
    self.nextSaturday = [gregorian dateFromComponents:endingComponents];
    NSLog(@"endingOfWeek, %@", self.nextSaturday);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    
    NSString *lastSundayString = [formatter stringFromDate:self.lastSunday];
    
    NSString *nextSaturdayString = [formatter stringFromDate:self.nextSaturday];
    
    NSString *dateRangeString = [NSString stringWithFormat:@"%@ %@ %@", lastSundayString, @"to", nextSaturdayString];
    
    self.weekDateRange.text = dateRangeString;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = delegate.managedObjectContext;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSNumber *weekMiles = [defaults objectForKey:@"weekMilesGoal"];
    
    NSString *weekMileString = [weekMiles stringValue];
    
    if (weekMiles != NULL)
    {
        self.weekGoalsSet.text = [weekMileString stringByAppendingString:@" mi"];
    }
    
    else
    {
        self.weekGoalsSet.text = [@"0" stringByAppendingString:@" mi"];
    }
    
    
    [self addWeeklyMiles];
    
    NSString *runString = [self.runSum stringValue];
    
    self.dailySum.text = [runString stringByAppendingString:@" mi"];

}



- (void)addWeeklyMiles {
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = delegate.managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Day"];
    
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (!results) {
        NSLog(@"Error fetching Employee objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    else {
        NSLog(@"results, %@", results);
    }
    
 //   NSCalendar *gregorianz = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] ;
  //  NSDateComponents *comps = [gregorianz components:NSCalendarUnitWeekday fromDate:[NSDate date]];

    //long weekday = [comps weekday];
    //NSLog(@"the wee %ld",weekday);
    //self.lastSunday = [[NSDate date] dateByAddingTimeInterval:-3600*24*(weekday-1)];
   // self.nextSaturday = [[NSDate date] dateByAddingTimeInterval:3600*24*((7 - weekday)%7)];
    
    /*

    NSDate *today = [[NSDate alloc] init];
    
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    // Get the weekday component of the current date
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday
                                                       fromDate:today];
    
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay: 0 - ([weekdayComponents weekday] - 1)];
    
    NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract
                                                         toDate:today options:0];
    
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setDay: ((7 - [weekdayComponents weekday])%7)];
    
    NSDate *endingOfWeek = [gregorian dateByAddingComponents:componentsToAdd
                                                         toDate:today options:0];
    

    
    NSDateComponents *beginningComponents =
    [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth|
                           NSCalendarUnitDay) fromDate: beginningOfWeek];

    self.lastSunday = [gregorian dateFromComponents:beginningComponents];
    NSLog(@"begnningOfWeek, %@", self.lastSunday);
    
    NSDateComponents *endingComponents =
    [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth|
                           NSCalendarUnitDay) fromDate: endingOfWeek];
    
    self.nextSaturday = [gregorian dateFromComponents:endingComponents];
    NSLog(@"endingOfWeek, %@", self.nextSaturday);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDate *lastSunday = [defaults objectForKey:@"firstDateRange"];
    
    NSDate *nextSaturday = [defaults objectForKey:@"lastDateRange"];*/
    
    
    double sum = 0;

    for (NSObject *result in results)
    {
        NSDate *dateMilesRan = [result valueForKey:@"date"];
        
        NSLog(@"dateMileRan, %@ ", dateMilesRan);
        
        if ((([dateMilesRan compare:self.lastSunday] == NSOrderedDescending) || ([dateMilesRan compare:self.lastSunday] == NSOrderedSame)) && (([dateMilesRan compare:self.nextSaturday] == NSOrderedAscending) || ([dateMilesRan compare:self.nextSaturday] == NSOrderedSame)))
        {

                NSString *milesRunDayString = [result valueForKey:@"miles"];
                
                NSNumber *milesRunDayNum = [NSNumber numberWithInteger: [milesRunDayString integerValue]];
                
                double milesRunDayDouble = [milesRunDayNum doubleValue];
                
                sum += milesRunDayDouble;
                
                NSLog(@"blahDouble, %f ", milesRunDayDouble);


        }
        
        
        
    }
    
    NSLog(@"sumasf, %f ", sum);
    
    self.runSum = [NSNumber numberWithDouble:sum];
    
    self.runSumString = [self.runSum stringValue];
    
   

}

- (IBAction)shareTwitter:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:[@"I've run " stringByAppendingString:[self.runSumString stringByAppendingString:@" miles this week!"]]];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    
}

- (IBAction)shareFB:(id)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:[@"I've run " stringByAppendingString:[self.runSumString stringByAppendingString:@" miles this week!"]]];
        [self presentViewController:controller animated:YES completion:Nil];
        
    }
    
    NSLog(@"FB");
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
