//
//  FlowLayout.m
//  foodTruckFinderz
//
//  Created by Oski on 3/19/13.
//  Copyright (c) 2013 Oscar Edmond. All rights reserved.
//

#import "FlowLayout.h"

@implementation FlowLayout



-(id)init {
    self = [super init];
    if (self) {
        self.itemSize = CGSizeMake(100, 100);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.sectionInset = UIEdgeInsetsMake(25, 0, 25, 0);
        self.minimumLineSpacing = 25.0;
        

    }
    return self;
}


@end
