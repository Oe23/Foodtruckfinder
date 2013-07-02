//
//  flipSegue.m
//  foodTruckFinderz
//
//  Created by Oski on 3/4/13.
//  Copyright (c) 2013 Oscar Edmond. All rights reserved.
//

#import "flipSegue.h"
#import "MapViewController.h"
#import "TableViewController.h"

@implementation flipSegue


- (void)perform
{
    TableViewController *destVC = (TableViewController *)self.destinationViewController;
    MapViewController *sourceVC = (MapViewController *)self.sourceViewController;
    destVC.context = sourceVC.context;
    
    [UIView transitionFromView:sourceVC.view
                        toView:destVC.view
                      duration:1
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    completion:^(BOOL finished) {
                        [sourceVC.navigationController pushViewController:destVC
                                                                 animated:NO];
                    }];
}
@end
