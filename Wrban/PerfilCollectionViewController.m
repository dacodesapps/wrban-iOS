//
//  PerfilCollectionViewController.m
//  Wrban
//
//  Created by Pablo on 1/20/16.
//  Copyright © 2016 Dacodes. All rights reserved.
//

#import "PerfilCollectionViewController.h"
#import "PerfilHeaderCollectionReusableView.h"
#import "SmallCollectionViewCell.h"
#import "BigCollectionViewCell.h"
#import "PromoViewController.h"

@interface PerfilCollectionViewController () {
    CGFloat height;
    NSString *str;
    NSInteger selectedIndex;
    NSArray *imagenes;
    PerfilHeaderCollectionReusableView *headerViewVar;
    BOOL firstTime;
}

@end

@implementation PerfilCollectionViewController

//static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    self.title = @"Empresa";
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    height = 280;
    firstTime = YES;
    selectedIndex = 0;
    
    imagenes = @[@"mit.jpg", @"staticmap.png", @"MexicoCityStreet.jpg", @"Fridays.jpg"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews {
    
    if(headerViewVar && firstTime) {
        NSLog(@"entro");
        height = headerViewVar.backgroundImageView.bounds.size.height + (headerViewVar.logoImageView.bounds.size.height * 0.5) + 4 + 22 + 6 + 28 + 6;
        
        CGSize maximumLabelSize = CGSizeMake(296, FLT_MAX);
        CGSize expectedLabelSize = [headerViewVar.descriptionLabel.text sizeWithFont:headerViewVar.descriptionLabel.font constrainedToSize:maximumLabelSize lineBreakMode:headerViewVar.descriptionLabel.lineBreakMode];
        
        //adjust the label the the new height.
        CGRect newFrame = headerViewVar.descriptionLabel.frame;
        newFrame.size.height = expectedLabelSize.height;
        headerViewVar.descriptionLabel.frame = newFrame;
        
        if (expectedLabelSize.height > 0) {
            height += 6 + expectedLabelSize.height;
        }
        
        [self.collectionView reloadData];
        firstTime = NO;
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [imagenes count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (selectedIndex == 0) {
        NSString *reuseIdentifier = @"Cell";
        SmallCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        
        cell.fullCellImageView.image = [UIImage imageNamed:imagenes[indexPath.row]];
        cell.fullCellImageView.contentMode = UIViewContentModeScaleAspectFill;
        //cell.fullCellImageView.clipsToBounds = YES;
        //cell.fullCellImageView.layer.masksToBounds = YES;
        // Configure the cell
        
        [cell layoutIfNeeded];
        [cell setNeedsLayout];
        
        return cell;
    } else {
        
        NSString *reuseIdentifier = @"Cell2";
        BigCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        
        cell.logoImageView.layer.cornerRadius = 22;
        cell.logoImageView.clipsToBounds = YES;
        [cell.logoImageView setImage:[UIImage imageNamed:self.logo]];
        cell.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        //        cell.logoImageView.layer.borderWidth = 3.0f;
        //        cell.logoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        cell.bigImageView.image = [UIImage imageNamed:imagenes[indexPath.row]];
        cell.bigImageView.clipsToBounds = YES;
        cell.bigImageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.nameLabel.text = self.company;
        cell.timeLabel.text = @"20min";
        cell.descriptionLabel.text = @"DescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescription";
        cell.descriptionLabel.numberOfLines = 0;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(interstedSaleDoubleTap:)];
        tapGestureRecognizer.numberOfTapsRequired=2;
        cell.bigImageView.tag=indexPath.row;
        cell.bigImageView.userInteractionEnabled=YES;
        [cell.bigImageView addGestureRecognizer:tapGestureRecognizer];
        
        [cell.likeButton setImage:[UIImage imageNamed:@"RedHeart"] forState:UIControlStateSelected];
        [cell.likeButton setImage:[UIImage imageNamed:@"UnfilledHeart"] forState:UIControlStateNormal];
        
        [cell.likeButton addTarget:self action:@selector(likeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell layoutIfNeeded];
        [cell setNeedsLayout];
        
        // Configure the cell
        
        return cell;
        //        static NSString *identifier = @"Cell3";
        //        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        //        UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
        //
        //        recipeImageView.image = [UIImage imageNamed:@"500px-Tgi_fridays_logo13.svg.png"];
        //        recipeImageView.contentMode = UIViewContentModeScaleAspectFit;
        //        cell.backgroundColor = [UIColor blackColor];
        //
        //        [cell layoutIfNeeded];
        //        [cell setNeedsLayout];
        //
        //        return cell;
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
        return  CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.width * 1.5);
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
        headerViewVar = headerView;
        NSLog(@"%@", headerView);
        
        //    if (firstTime) {
        //            height = headerView.backgroundImageView.bounds.size.height + (headerView.logoImageView.bounds.size.height * 0.5) + 4 + 22 + 6 + 28 + 6;
        //
        //            CGSize maximumLabelSize = CGSizeMake(296, FLT_MAX);
        //            CGSize expectedLabelSize = [headerView.descriptionLabel.text sizeWithFont:headerView.descriptionLabel.font constrainedToSize:maximumLabelSize lineBreakMode:headerView.descriptionLabel.lineBreakMode];
        //
        //            //adjust the label the the new height.
        //            CGRect newFrame = headerView.descriptionLabel.frame;
        //            newFrame.size.height = expectedLabelSize.height;
        //            headerView.descriptionLabel.frame = newFrame;
        //
        //            if (expectedLabelSize.height > 0) {
        //                height += 6 + expectedLabelSize.height;
        //            }
        
        //            firstTime = NO;
        
        
        headerView.nombreLabel.text = self.company;
        
        headerView.descriptionLabel.numberOfLines = 0;
        headerView.logoImageView.image = [UIImage imageNamed:self.logo];
        headerView.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        headerView.logoImageView.backgroundColor = [UIColor whiteColor];
        headerView.logoImageView.layer.borderWidth = 3.0f;
        headerView.logoImageView.layer.borderColor = [UIColor clearColor].CGColor;
        //headerView.logoImageView.backgroundColor = [UIColor redColor];
        //headerView.logoImageView.layer.cornerRadius = headerView.logoImageView.frame.size.width / 4.5;
        headerView.logoImageView.layer.cornerRadius = headerView.logoImageView.frame.size.width/2;
        headerView.logoImageView.clipsToBounds = YES;
        headerView.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        headerView.backgroundImageView.clipsToBounds = YES;
        
        //            height = 280;
        headerView.segmentControl.selectedSegmentIndex = selectedIndex;
        [headerView.segmentControl setTintColor:[UIColor colorWithRed:128.0/255.0 green:22.0/255.0 blue:30.0/255.0 alpha:1.0]];
        //CGFloat viewWidth = self.view.bounds.size.width;
        //height = (viewWidth * ( 3.0/8.0)) + (viewWidth * 0.14) + 4 + 22 + 6 + 28 + 6;
        
        
        [headerView.segmentControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        //[self.collectionView reloadData];
        
        
        
        return headerView;
        //        } else {
        //
        //            headerView.nombreLabel.text = self.company;
        //
        //            headerView.descriptionLabel.numberOfLines = 0;
        //            headerView.logoImageView.image = [UIImage imageNamed:self.logo];
        //            headerView.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        //            headerView.logoImageView.layer.borderWidth = 3.0f;
        //            headerView.logoImageView.layer.borderColor = [UIColor clearColor].CGColor;
        //            //headerView.logoImageView.backgroundColor = [UIColor redColor];
        //            //headerView.logoImageView.layer.cornerRadius = headerView.logoImageView.frame.size.width / 4.5;
        //            headerView.logoImageView.layer.cornerRadius = headerView.logoImageView.frame.size.width/2;
        //            headerView.logoImageView.clipsToBounds = YES;
        //            headerView.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        //            headerView.backgroundImageView.clipsToBounds = YES;
        //
        //            height = headerView.backgroundImageView.bounds.size.height + (headerView.logoImageView.bounds.size.height * 0.5) + 4 + 22 + 6 + 28 + 6;
        //            headerView.segmentControl.selectedSegmentIndex = selectedIndex;
        //            [headerView.segmentControl setTintColor:[UIColor colorWithRed:128.0/255.0 green:22.0/255.0 blue:30.0/255.0 alpha:1.0]];
        //
        //            //    CGFloat viewWidth = self.view.bounds.size.width;
        //            // height = (viewWidth * ( 3.0/8.0)) + (viewWidth * 0.14) + 4 + 22 + 6 + 28 + 6;
        //
        //
        //            [headerView.segmentControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        //
        //            return headerView;
        //        }
        
        reusableview = headerView;
    }
    
    
    return reusableview;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (selectedIndex == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"showPromo" sender:self];
        });
    }
}

-(void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    if (elementKind == UICollectionElementKindSectionHeader) {
        [view layoutIfNeeded];
        [view setNeedsLayout];
        PerfilHeaderCollectionReusableView *headerView = (PerfilHeaderCollectionReusableView *)view;
        headerView.logoImageView.layer.cornerRadius = headerView.logoImageView.frame.size.width/2;
    }
}

-(void)interstedSaleDoubleTap:(UITapGestureRecognizer *)sender {

//    NSIndexPath *path = [NSIndexPath indexPathForItem:sender.tag inSection:0];
    UIImageView *imageview = (UIImageView *) sender.view;
    BigCollectionViewCell *cell = (BigCollectionViewCell *) [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:imageview.tag inSection:0]];
    cell.likeButton.selected = YES;
    [UIView animateWithDuration:0.2 animations:^{
        cell.heartImageView.alpha = 1;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:0.5 options:nil animations:^{
            cell.heartImageView.alpha = 0;
        } completion:^(BOOL finished) {
        }];
    }];
    
    
}

-(void)likeButtonPressed:(UIButton *)sender {
    sender.selected = !sender.selected;
}


#pragma mark - UISegmentedControll

-(void)segmentedControlValueChanged: (UISegmentedControl *) sender {
    selectedIndex = sender.selectedSegmentIndex;
    // NSLog(@"%@",[self.collectionView indexPathsForVisibleItems]);
    //[self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    //[self.collectionView reloadItemsAtIndexPaths:[self.collectionView indexPathsForVisibleItems]];
    [self.collectionView reloadData];
    //[self.collectionView reloadItemsAtIndexPaths:[self.collectionView indexPathsForVisibleItems]];
    //    NSMutableArray *ar = [NSMutableArray new];
    //
    //    for(int i = 0; i<imagenes.count; i++) {
    //        [ar addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    //    }
    //
    //    [self.collectionView reloadItemsAtIndexPaths:ar];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath*indexPath = [self.collectionView indexPathsForSelectedItems][0];
    PromoViewController* destinationController = segue.destinationViewController;
    destinationController.promoImage = [imagenes objectAtIndex:indexPath.row];
    destinationController.company = self.company;
    destinationController.logo = self.logo;
}

#pragma mark <UICollectionViewDelegate>

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */

@end
