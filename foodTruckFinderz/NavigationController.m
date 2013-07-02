//
//  NavigationController.m
//  foodTruckFinderz
//
//  Created by Oski on 3/3/13.
//  Copyright (c) 2013 Oscar Edmond. All rights reserved.
//

#import "NavigationController.h"
#import "FoodTruck.h"
@interface NavigationController ()

@end

@implementation NavigationController


@synthesize context = _context;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void) fetchedData:(NSData *)responseData
{
    NSError *error;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
//    NSDictionary *truckDictionary = [json objectAtIndex:0];
    for (NSDictionary *truckDict in json){
        FoodTruck *truckObject = [NSEntityDescription insertNewObjectForEntityForName:@"FoodTruck" inManagedObjectContext:_context];
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
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //access file to get json data
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"json" ofType:@"txt"];
    
    //convert the contents of the file to data
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    

    
    //save the context to the database, record error
    
    NSError *error;
    
    if (![_context save:&error])
    {
        NSLog(@"Error saving - %@", [error localizedDescription]);

    }
    //read from the database to check if saving works
    NSFetchRequest *dataFetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *dataEntity = [NSEntityDescription entityForName:@"FoodTruck" inManagedObjectContext:_context];
    [dataFetchRequest setEntity:dataEntity];
    
    NSArray *fetchedObjects = [_context executeFetchRequest:dataFetchRequest error:&error];
    
    for (int counter = 0; counter <[fetchedObjects count]; counter++)
    {
        FoodTruck *tempObject;
        tempObject = [fetchedObjects objectAtIndex:counter];
        NSLog(@"Fetched: %@", tempObject.title);
    }
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
