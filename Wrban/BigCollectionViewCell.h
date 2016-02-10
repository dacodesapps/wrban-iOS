//
//  BigCollectionViewCell.h
//  Wrban
//
//  Created by Pablo on 1/22/16.
//  Copyright © 2016 Dacodes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BigCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *heartImageView;
@property (weak, nonatomic) IBOutlet UILabel *meGustaLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@end
