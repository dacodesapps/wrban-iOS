//
//  CategoryViewController.m
//  Wrban
//
//  Created by Dacodes on 26/01/16.
//  Copyright © 2016 Dacodes. All rights reserved.
//

#import "CategoryViewController.h"
#import "CategoryCollectionViewCell.h"
#import "PerfilCollectionViewController.h"
#import "AFNetworking.h"

@interface CategoryViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UISearchBarDelegate>{
    NSMutableArray*response;
    NSArray*companies;
    NSMutableArray*companiesCopy;
    NSArray*logosCompanies;
    NSMutableArray*logosCompaniesCopy;
}

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
//@property (strong, nonatomic) UISearchController *searchController;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"Search";
    
    self.title = self.category;
    
    companies = @[@"Friday's",@"Burger King",@"Domino's Pizza",@"Carl's Jr.",@"Lapa Lapa"];
    companiesCopy = [[NSMutableArray alloc] initWithArray:companies];
    logosCompanies = @[@"logo1.png",@"logo2.png",@"logo3.jpg",@"logo4.jpeg",@"logo5.jpg"];
    logosCompaniesCopy = [[NSMutableArray alloc] initWithArray:logosCompanies];
    
    [self getCompanies];
//    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
//    self.searchController.searchResultsUpdater = self;
//    self.searchController.dimsBackgroundDuringPresentation = NO;
//    self.searchController.searchBar.scopeButtonTitles = @[NSLocalizedString(@"ScopeButtonCountry",@"Country"),
//                                                          NSLocalizedString(@"ScopeButtonCapital",@"Capital")];
//    self.searchController.searchBar.delegate = self;
//    self.definesPresentationContext = YES;
}

#pragma mark - FetchData

-(void)getCompanies{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:@"http://www.dacodes.com/wrban/api/get-categories.php" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        response=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        //response = temp[@"categories"];
        NSLog(@"Categories: %@", response);
        //[self.myCollectionView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSDictionary*errorResponse = (NSDictionary*)operation.responseObject;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Wrban" message:@"Error en la conexión" preferredStyle:UIAlertControllerStyleAlert]; // 1
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"Aceptar");
        }];
        [alert addAction:firstAction];
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self presentViewController:alert animated:YES completion:nil];
        });
        NSLog(@"%@",error);
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    }];
}

//- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
//{
//    NSString *searchString = searchController.searchBar.text;
//    if([searchString length] == 0){
//        [companiesCopy removeAllObjects];
//        [companiesCopy addObjectsFromArray:companies];
//    }else{
//        [companiesCopy removeAllObjects];
//        
////        for(NSDictionary *dictionary in companies)
////        {
////            NSObject *ob = [dictionary objectForKey:@"serviceName"];
////            if([ob isKindOfClass: [NSString class]])
////            {
////                NSString*string=[ob description];
////                NSRange range = [string rangeOfString:searchString options:NSCaseInsensitiveSearch];
////                
////                if (range.location != NSNotFound) {
////                    [companiesCopy addObject:dictionary];
////                    NSLog(@"%@",companiesCopy);
////                }
////            }
////        }
//        for(NSString *string in companies)
//        {
//            if([string isKindOfClass: [NSString class]])
//            {
//                NSRange range = [string rangeOfString:searchString options:NSCaseInsensitiveSearch];
//                
//                if (range.location != NSNotFound) {
//                    [companiesCopy addObject:string];
//                    NSLog(@"%@",companiesCopy);
//                }
//            }
//        }
//
//    }
//    [self.myCollectionView reloadData];
//}

//- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
//{
//    [self updateSearchResultsForSearchController:self.searchController];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection View -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [companiesCopy count];
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
    
    cell.servicePic.image = [UIImage imageNamed:logosCompaniesCopy[indexPath.row]];
    cell.servicePic.contentMode = UIViewContentModeScaleAspectFit;
    
    cell.serviceName.text = companiesCopy[indexPath.row];
    
    [cell layoutIfNeeded];
    [cell setNeedsLayout];
    
    return cell;
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView *reusableview = nil;
//    
//    if (kind == UICollectionElementKindSectionHeader) {
//        UICollectionReusableView *headerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
//        UISearchBar*searchBar = (UISearchBar *)[headerview viewWithTag:100];
//        searchBar.placeholder = @"Buscar";
//        searchBar.delegate = self;
//        [headerview addSubview:searchBar];
//        reusableview = headerview;
//    }
//    
//    return reusableview;
//}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"showCompany" sender:self];
    });
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.item == [instagramResponse count] - 1) {
//        [self reloadDataInstagram];
//    }
}

#pragma mark - Search Bar

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if([searchText length] == 0){
        [companiesCopy removeAllObjects];
        [companiesCopy addObjectsFromArray:companies];
    }else{
        [companiesCopy removeAllObjects];
        
        for(NSString *string in companies)
        {
            if([string isKindOfClass: [NSString class]])
            {
                NSRange range = [string rangeOfString:searchText options:NSCaseInsensitiveSearch];
                
                if (range.location != NSNotFound) {
                    [companiesCopy addObject:string];
                    //NSLog(@"%@",companiesCopy);
                }
            }
        }
    }
    [self.myCollectionView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

//-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
//    [self performSelector:@selector(enableCancelButton:) withObject:searchBar afterDelay:0.0];
//}
//
//- (void)enableCancelButton:(UISearchBar *)searchBar {
//    for (id subview in [searchBar subviews]) {
//        if ([subview isKindOfClass:[UIButton class]]) {
//            [subview setEnabled:TRUE];
//        }
//    }
//}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath* indexPath = [self.myCollectionView indexPathsForSelectedItems][0];
    PerfilCollectionViewController*destinationController = segue.destinationViewController;
    destinationController.company = companies[indexPath.row];
    destinationController.logo = logosCompanies[indexPath.row];
}


@end
