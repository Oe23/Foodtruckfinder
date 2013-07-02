//
//  DetailViewController.h
//  foodTruckFinderz
//
//  Created by Oski on 3/3/13.
//  Copyright (c) 2013 Oscar Edmond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "FoodTruck.h"
#import "NavigationController.h"


@interface DetailViewController : UIViewController

@property (nonatomic, strong) FoodTruck *incomingFoodTruckObject;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (weak, readonly) IBOutlet UILabel *textLabel;
@property (weak, readonly) IBOutlet UIImageView *imageView;

- (void)setLabel;


@end
