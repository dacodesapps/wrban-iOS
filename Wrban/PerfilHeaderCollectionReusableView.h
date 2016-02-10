//
//  PerfilHeaderCollectionReusableView.h
//  Wrban
//
//  Created by Pablo on 1/20/16.
//  Copyright © 2016 Dacodes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PerfilHeaderCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nombreLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@end
