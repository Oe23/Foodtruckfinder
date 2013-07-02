//
//  MapViewController.h
//  foodTruckFinderz
//
//  Created by Oski on 3/3/13.
//  Copyright (c) 2013 Oscar Edmond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>



@interface MapViewController : UIViewController
@property NSManagedObjectContext *context;
@property (nonatomic, strong) NSString *zipCode;

@end
