//
//  CompanyViewController.m
//  Wrban
//
//  Created by Dacodes on 26/01/16.
//  Copyright © 2016 Dacodes. All rights reserved.
//

#import "CompanyViewController.h"
#import "PerfilHeaderCollectionReusableView.h"
#import "SmallCollectionViewCell.h"
#import "BigCollectionViewCell.h"

@interface CompanyViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    CGFloat height;
    NSString *str;
    NSInteger selectedIndex;
    NSArray *imagenes;
    BOOL firstTime;
}

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@end

@implementation CompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    self.myCollectionView.backgroundColor = [UIColor clearColor];
    
    height = 300;
    firstTime = YES;
    selectedIndex = 0;
    str = @"";
    
    imagenes = @[@"mit.jpg", @"staticmap.png", @"MexicoCityStreet.jpg", @"Fridays.jpg"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return imagenes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (selectedIndex == 0) {
        NSString *reuseIdentifier = @"Cell";
        SmallCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        
        cell.fullCellImageView.image = [UIImage imageNamed:imagenes[indexPath.row]];
        cell.fullCellImageView.contentMode = UIViewContentModeScaleAspectFill;
        cell.fullCellImageView.clipsToBounds = YES;
        // Configure the cell
        
        [cell layoutIfNeeded];
        [cell setNeedsLayout];
        
        return cell;
    } else {
//        NSLog(@"entro");
//        
//        NSString *reuseIdentifier = @"Cell2";
//        BigCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//        
//        cell.logoImageView.layer.cornerRadius = 22;
//        cell.logoImageView.clipsToBounds = YES;
//        //        cell.logoImageView.layer.borderWidth = 3.0f;
//        //        cell.logoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
//        cell.bigImageView.image = [UIImage imageNamed:imagenes[indexPath.row]];
//        cell.bigImageView.clipsToBounds = YES;
//        cell.bigImageView.contentMode = UIViewContentModeScaleAspectFit;
//        cell.nameLabel.text = @"Boston's";
//        cell.timeLabel.text = @"20min";
//        cell.descriptionLabel.text = @"DescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescription";
//        cell.descriptionLabel.numberOfLines = 0;
//        
//        [cell layoutIfNeeded];
//        [cell setNeedsLayout];
//        
//        // Configure the cell
//        
//        return cell;
        static NSString *identifier = @"Cell3";
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        //UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
        
        //recipeImageView.image = [UIImage imageNamed:@"500px-Tgi_fridays_logo13.svg.png"];
        //recipeImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        cell.backgroundColor = [UIColor blackColor];
        
        [cell layoutIfNeeded];
        [cell setNeedsLayout];
        
        return cell;
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(0, height);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (selectedIndex == 0) {
        
        double w = (self.view.frame.size.width -5) / 3.0;
        if(self.view.frame.size.width >= 375) {
            w = (self.view.frame.size.width -6) / 3.0;
        }
        return CGSizeMake(w, w);
    } else {
        return  CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.width);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        PerfilHeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        
        if (firstTime) {
            height = headerView.backgroundImageView.bounds.size.height + (headerView.logoImageView.bounds.size.height * 0.5) + 4 + 22 + 6 + 28 + 6;
            
            CGSize maximumLabelSize = CGSizeMake(296, FLT_MAX);
            CGSize expectedLabelSize = [str sizeWithFont:headerView.descriptionLabel.font constrainedToSize:maximumLabelSize lineBreakMode:headerView.descriptionLabel.lineBreakMode];
            
            //adjust the label the the new height.
            CGRect newFrame = headerView.descriptionLabel.frame;
            newFrame.size.height = expectedLabelSize.height;
            headerView.descriptionLabel.frame = newFrame;
            
            if (expectedLabelSize.height > 0) {
                height += 6 + expectedLabelSize.height;
            }
            
            firstTime = NO;
            [self.myCollectionView reloadData];
        } else {
            
            headerView.nombreLabel.text = @"Boston's";
            
            headerView.descriptionLabel.text = str;
            headerView.descriptionLabel.numberOfLines = 0;
            headerView.logoImageView.image = [UIImage imageNamed:@"Bostons1.jpg"];
            headerView.logoImageView.contentMode = UIViewContentModeScaleAspectFill;
            headerView.logoImageView.layer.borderWidth = 3.0f;
            headerView.logoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
            //headerView.logoImageView.backgroundColor = [UIColor redColor];
            headerView.logoImageView.layer.cornerRadius = headerView.logoImageView.frame.size.width / 4.5;
            headerView.logoImageView.clipsToBounds = YES;
            headerView.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
            headerView.backgroundImageView.clipsToBounds = YES;
            
            height = headerView.backgroundImageView.bounds.size.height + (headerView.logoImageView.bounds.size.height * 0.5) + 4 + 22 + 6 + 28 + 6;
            headerView.segmentControl.selectedSegmentIndex = selectedIndex;
            
            //    CGFloat viewWidth = self.view.bounds.size.width;
            // height = (viewWidth * ( 3.0/8.0)) + (viewWidth * 0.14) + 4 + 22 + 6 + 28 + 6;
            
            
            [headerView.segmentControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
            
            
        }
        
        reusableview = headerView;
        
    }
    
    
    return reusableview;
}

#pragma mark - UISegmentedControl

-(void)segmentedControlValueChanged: (UISegmentedControl *) sender {
    selectedIndex = sender.selectedSegmentIndex;
    [self.myCollectionView reloadItemsAtIndexPaths:[self.myCollectionView indexPathsForVisibleItems]];
    //[self.myCollectionView reloadData];
    //[self.collectionView reloadItemsAtIndexPaths:[self.collectionView indexPathsForVisibleItems]];
//    NSMutableArray *ar = [NSMutableArray new];
//    
//    for(int i = 0; i<imagenes.count; i++) {
//        [ar addObject:[NSIndexPath indexPathForRow:i inSection:0]];
//    }
//    
//    [self.collectionView reloadItemsAtIndexPaths:ar];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
