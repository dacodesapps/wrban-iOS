//
//  SellProfileTableViewCell.h
//  Nearmart
//
//  Created by Carlos Vela on 03/12/14.
//  Copyright (c) 2014 Carlos Vela. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SellProfileTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *titlePhoto;
@property (weak, nonatomic) IBOutlet UILabel *pricePhoto;
@property (weak, nonatomic) IBOutlet UILabel *stockPhoto;
@property (weak, nonatomic) IBOutlet UILabel *descriptionPhoto;
@property (weak, nonatomic) IBOutlet UIButton *interestingButton;
@property (weak, nonatomic) IBOutlet UIButton *contactButton;
@property (weak, nonatomic) IBOutlet UILabel *meGustaLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIImageView *heartImageView;

@end
