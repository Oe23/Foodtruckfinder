//
//  JSONNetworking.m
//  foodTruckFinderz
//
//  Created by Oski on 3/13/13.
//  Copyright (c) 2013 Oscar Edmond. All rights reserved.
//

#import "JSONNetworking.h"
#import "FoodTruck.h"

@implementation JSONNetworking





-(id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void) fetchedData:(NSData *)responseData
{
    NSError *error;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
    NSDictionary *truckDictionary = [json objectAtIndex:0];
    for (NSDictionary *truckDict in json){
        FoodTruck *truckObject = [NSArray arrayWithObject:truckDictionary];
        truckObject.title = [truckDict objectForKey:@"Title"];
        float lat = [[truckDict objectForKey:@"Latitude"] floatValue];
        NSLog(@"title:%@", truckObject.title);
        truckObject.lat = [NSNumber numberWithFloat:lat];
        NSLog(@"Latitude:%@", truckObject.lat);
        float lng = [[truckDict objectForKey:@"Longitude"] floatValue];
        truckObject.lng = [NSNumber numberWithFloat:lng];
        NSLog(@"Longitude:%@", truckObject.lng);
        truckObject.fileName = [truckDict objectForKey:@"FileName"];
        NSLog(@"filename:%@", truckObject.fileName);
    }
}

-(void)jsonData
{
    //access file to get json data
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"json" ofType:@"txt"];
    
    //convert the contents of the file to data
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    
}


@end
