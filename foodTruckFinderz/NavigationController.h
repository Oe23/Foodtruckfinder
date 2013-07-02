//
//  NavigationController.h
//  foodTruckFinderz
//
//  Created by Oski on 3/3/13.
//  Copyright (c) 2013 Oscar Edmond. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NavigationController : UINavigationController


@property NSManagedObjectContext *context;
@property NSArray *foodTruckList;
@property NSMutableArray *favoritesList;



@end
