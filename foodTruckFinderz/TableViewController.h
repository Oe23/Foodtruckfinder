//
//  TableViewController.h
//  foodTruckFinderz
//
//  Created by Oski on 3/3/13.
//  Copyright (c) 2013 Oscar Edmond. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TableViewController : UITableViewController


@property NSManagedObjectContext *context;
@property NSArray *foodtruckList;
@property NSMutableArray *downloadedfoodtrucks;


@end
