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
    
    NSString *weekMileString = [NSString stringWithFormat:@"%.2f", [weekMiles doubleValue]];
    
    if (weekMiles != NULL)
    {
        self.weekGoalsSet.text = [weekMileString stringByAppendingString:@" mi"];
    }
    
    else
    {
        self.weekGoalsSet.text = [@"0" stringByAppendingString:@" mi"];
    }
    
    
    [self addWeeklyMiles];
    
    NSString *runString = [NSString stringWithFormat:@"%.2f", [self.runSum doubleValue]];
    
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

    
    
    double sum = 0.0;

    for (NSObject *result in results)
    {
        NSDate *dateMilesRan = [result valueForKey:@"date"];
        
        NSLog(@"dateMileRan, %@ ", dateMilesRan);
        
        if ((([dateMilesRan compare:self.lastSunday] == NSOrderedDescending) || ([dateMilesRan compare:self.lastSunday] == NSOrderedSame)) && (([dateMilesRan compare:self.nextSaturday] == NSOrderedAscending) || ([dateMilesRan compare:self.nextSaturday] == NSOrderedSame)))
        {

                NSString *milesRunDayString = [result valueForKey:@"miles"];
                
                NSNumber *milesRunDayNum = [NSNumber numberWithDouble:[milesRunDayString doubleValue]];
                
                double milesRunDayDouble = [milesRunDayNum doubleValue];
                
                sum += milesRunDayDouble;
                
                NSLog(@"blahDouble, %f ", milesRunDayDouble);


        }
        
        
        
    }
    
    NSLog(@"sumasf, %f ", sum);
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    
    self.runSum = [NSNumber numberWithDouble:sum];
    
    self.runSumString = [formatter stringFromNumber: [NSNumber numberWithFloat:sum]];
    
   

}

- (IBAction)shareTwitter:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:[@"I've run " stringByAppendingString:[self.runSumString stringByAppendingString:@" miles this week! #RunZenApp"]]];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Please Login to a Twitter Account to Tweet Your Progress" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}

- (IBAction)shareFB:(id)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:[@"I've run " stringByAppendingString:[self.runSumString stringByAppendingString:@" miles this week! #RunZenApp"]]];
        [self presentViewController:controller animated:YES completion:Nil];
        
    }
    
    else {
      
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Please Login to a Facebook Account to Share Your Progress" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
