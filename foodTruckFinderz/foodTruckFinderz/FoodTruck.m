//
//  FoodTruck.m
//  foodTruckFinderz
//
//  Created by Oski on 3/3/13.
//  Copyright (c) 2013 Oscar Edmond. All rights reserved.
//

#import "FoodTruck.h"


@implementation FoodTruck

@dynamic fileName;
@dynamic isFavorite;
@dynamic title;
@dynamic lat;
@dynamic lng;
@dynamic distance;
@synthesize subtitle = _subtitle;

-(CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D temp;
    temp.latitude = [self.lat floatValue];
    temp.longitude = [self.lng floatValue];
    
    
    
    return temp;
}


+ (FoodTruck *) initWithTitle: (NSString *)incomingTitle
                     fileName: (NSString *) imageNamed
                   forContext: (NSManagedObjectContext *) incomingContext;
{
    FoodTruck *foodTruckObject = [NSEntityDescription insertNewObjectForEntityForName:@"FoodTruck" inManagedObjectContext:incomingContext];
    
    foodTruckObject.title = incomingTitle;
    foodTruckObject.fileName = imageNamed;
    foodTruckObject.isFavorite = [NSNumber numberWithBool:0];
    
    return foodTruckObject;
}

@end
