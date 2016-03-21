//
//  Week.h
//  RunZen
//
//  Created by Nadine Khattak on 3/13/16.
//  Copyright © 2016 Ensach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>



@interface Week : NSManagedObject

@property (nullable, nonatomic, retain) NSNumber *miles;
@property (nullable, nonatomic, retain) NSDate *firstDate;
@property (nullable, nonatomic, retain) NSDate *lastDate;


@end
