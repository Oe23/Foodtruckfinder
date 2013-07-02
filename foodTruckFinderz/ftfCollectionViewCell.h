//
//  ftfCollectionViewCell.h
//  foodTruckFinderz
//
//  Created by Oski on 3/7/13.
//  Copyright (c) 2013 Oscar Edmond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodTruck.h"

@interface ftfCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *favoriteTruckView;
@property (nonatomic, strong) FoodTruck *incomingFoodTruckObject;

@end
