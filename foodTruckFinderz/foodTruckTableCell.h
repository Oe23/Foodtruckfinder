//
//  foodTruckTableCell.h
//  foodTruckFinderz
//
//  Created by Oski on 4/3/13.
//  Copyright (c) 2013 Oscar Edmond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface foodTruckTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *truckImage;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;


@end
