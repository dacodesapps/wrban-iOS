//
//  HomeCategoryTableViewCell.h
//  Wrban
//
//  Created by Dacodes on 31/12/15.
//  Copyright © 2015 Dacodes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCategoryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UICollectionView *myCollection;
@property (weak, nonatomic) IBOutlet UIImageView *servicePic;
@property (weak, nonatomic) IBOutlet UILabel *serviceName;

@end
