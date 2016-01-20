//
//  HomeFlow.m
//  Wrban
//
//  Created by Dacodes on 03/01/16.
//  Copyright © 2016 Dacodes. All rights reserved.
//

#import "HomeFlow.h"

@implementation HomeFlow

- (CGSize)collectionViewContentSize
{
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    
    double w = (self.collectionView.frame.size.width -5) / 3;
    //if(self.view.frame.size.width >= 375) {
        w = (self.collectionView.frame.size.width - 6) / 3;
    //}
    
    return CGSizeMake(w*itemCount+16, self.collectionView.frame.size.height);
}

@end
