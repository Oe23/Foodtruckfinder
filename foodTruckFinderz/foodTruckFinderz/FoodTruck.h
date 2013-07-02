//
//  FoodTruck.h
//  foodTruckFinderz
//
//  Created by Oski on 3/3/13.
//  Copyright (c) 2013 Oscar Edmond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>


@interface FoodTruck : NSManagedObject <MKAnnotation>

@property (nonatomic, retain) NSString * fileName;
@property (nonatomic, retain) NSNumber * isFavorite;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber *lat;
@property (nonatomic, retain) NSNumber *lng;
@property (nonatomic, retain) NSNumber *distance;
@property (nonatomic, copy, readwrite) NSString *subtitle;


- (CLLocationCoordinate2D)coordinate;




+ (FoodTruck *) initWithTitle: (NSString *)incomingTitle
                     fileName: (NSString *) imageNamed
                   forContext: (NSManagedObjectContext *) incomingContext;


@end
