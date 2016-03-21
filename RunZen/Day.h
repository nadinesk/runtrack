//
//  Day.h
//  RunZen
//
//  Created by Nadine Khattak on 3/13/16.
//  Copyright © 2016 Ensach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>



@interface Day : NSManagedObject

@property (nullable, nonatomic, retain) NSNumber *miles;
@property (nullable, nonatomic, retain) NSDate *date;


@end
