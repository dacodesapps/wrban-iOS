//
//  FavoritesViewController.m
//  Wrban
//
//  Created by Dacodes on 14/12/15.
//  Copyright © 2015 Dacodes. All rights reserved.
//

#import "FavoritesViewController.h"
#import "CategoryCollectionViewCell.h"
#import "PromoViewController.h"

@interface FavoritesViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    NSArray*companies;
    NSArray*promos;
    NSArray*logosCompanies;
}

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@end

@implementation FavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:128.0/255.0 green:22.0/255.0 blue:30.0/255.0 alpha:1.0]];
    
    self.title = @"Favoritos";
    
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    
    promos=@[@"promo1.png",@"promo2.jpg",@"promo3.jpg",@"promo4.jpg",@"promo5.png"];
    companies=@[@"Friday's",@"Burger King",@"Domino's Pizza",@"Carl's Jr.",@"Lapa Lapa"];
    logosCompanies = @[@"logo1.png",@"logo2.png",@"logo3.jpg",@"logo4.jpeg",@"logo5.jpg"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection View -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [promos count];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    double photoWidth = (self.view.frame.size.width -5) / 3;
    
    if(self.view.frame.size.width >= 375)
        photoWidth = (self.view.frame.size.width - 6) / 3;
    
    double photoHeight = photoWidth;
    
    return CGSizeMake(photoWidth, photoHeight);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    if(self.view.frame.size.width >= 375)
        return 3;
    else
        return 2.5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"Cell";
    CategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.servicePic.image = [UIImage imageNamed:promos[indexPath.row]];
    cell.servicePic.contentMode = UIViewContentModeScaleAspectFill;
    
    cell.serviceName.text = companies[indexPath.row];
    
    [cell layoutIfNeeded];
    [cell setNeedsLayout];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"showPromo" sender:self];
    });
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    //    if (indexPath.item == [instagramResponse count] - 1) {
    //        [self reloadDataInstagram];
    //    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath* indexPath = [self.myCollectionView indexPathsForSelectedItems][0];
    PromoViewController* destinationController = segue.destinationViewController;
    destinationController.promoImage = [promos objectAtIndex:indexPath.row];
    destinationController.company = [companies objectAtIndex:indexPath.row];
    destinationController.logo = [logosCompanies objectAtIndex:indexPath.row];
}


@end
