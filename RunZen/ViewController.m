//
//  ViewController.m
//  RunZen
//
//  Created by Nadine Khattak on 3/13/16.
//  Copyright © 2016 Ensach. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <Social/Social.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = delegate.managedObjectContext;
    
    NSDate *todaysDate = [NSDate date];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateStyle:NSDateFormatterShortStyle];
    
    self.todayDate.text = [format stringFromDate:todaysDate];
    

}

- (void)viewWillAppear:(BOOL)animated
{
    self.dailyMiles.text = @"";
}



- (IBAction)saveDailyMiles:(id)sender {

    NSString *dailyMilesText = self.dailyMiles.text;
    
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *milesNumber = [f numberFromString:dailyMilesText];
    

    
    NSLog(@"milesNumber, %@", milesNumber);
    
    if (dailyMilesText && dailyMilesText.length) {
        //Create Entity
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Day" inManagedObjectContext:self.managedObjectContext];
        
        //Initialize Record
        NSManagedObject *record = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
        
        //Populate Record
        [record setValue:milesNumber forKey:@"miles"];
        
        [record setValue:[NSDate date] forKey:@"date"];
        
        //Save Record
        NSError *error = nil;
        
        if ([self.managedObjectContext save:&error]) {
            //Dismiss View Controller
            // [self dismissViewControllerAnimated:YES completion:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            if (error) {
                NSLog(@"Unable to save record");
                NSLog(@"%@, %@", error, error.localizedDescription);
            }
            
            //Show Alert View
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Your Daily Miles Could Not Be Saved" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
    } else {
        // Show Alert View
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Your Daily Miles Need a Number" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
   

     NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
     
     NSEntityDescription *entity = [NSEntityDescription entityForName:@"Day" inManagedObjectContext:self.managedObjectContext];
     [fetchRequest setEntity:entity];
     
     NSError *error = nil;
     NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
     
     if (error) {
     NSLog(@"Unable to execute fetch request.");
     NSLog(@"%@, %@", error, error.localizedDescription);
     
     } else {
     NSLog(@"%@", result);
     }
     
  /*   NSManagedObject *goal = (NSManagedObject *)[result objectAtIndex:1];
     
     
     NSLog(@"asdfasdf %@ %@", [goal valueForKey:@"miles"], [goal valueForKey:@"date"]); */




}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
