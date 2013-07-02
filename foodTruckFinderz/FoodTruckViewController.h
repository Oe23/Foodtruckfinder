//
//  FoodTruckViewController.h
//  foodTruckFinderz
//
//  Created by Oski on 3/3/13.
//  Copyright (c) 2013 Oscar Edmond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "NavigationController.h"


@interface FoodTruckViewController : UIViewController <NSFetchedResultsControllerDelegate>
@property NSManagedObjectContext *context;
@property NSArray *foodtruckList;
@property NSArray *favoritesList;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end
