//
//  flipSegueBack.m
//  foodTruckFinderz
//
//  Created by Oski on 3/5/13.
//  Copyright (c) 2013 Oscar Edmond. All rights reserved.
//

#import "flipSegueBack.h"
#import "MapViewController.h"
#import "TableViewController.h"

@implementation flipSegueBack
- (void)perform
{
    MapViewController *destVC = (MapViewController *)self.destinationViewController;
    TableViewController *sourceVC = (TableViewController *)self.sourceViewController;
    //destVC.context = sourceVC.context;
    
    [UIView transitionFromView:sourceVC.view
                        toView:destVC.view
                      duration:3
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    completion:^(BOOL finished) {
                        [sourceVC.navigationController popViewControllerAnimated:YES];
                    }];
}
@end
