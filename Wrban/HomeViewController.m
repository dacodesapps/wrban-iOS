//
//  HomeViewController.m
//  Wrban
//
//  Created by Dacodes on 14/12/15.
//  Copyright © 2015 Dacodes. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewCell.h"
#import "HomeCollectionViewCell.h"
#import "HomeCategoryTableViewCell.h"
#import "HomeCategoryCollectionViewCell.h"
#import "AFNetworking.h"
#import "PromoViewController.h"
#import "NSString+FontAwesome.h"
#import "UIImage+FontAwesome.h"

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>{
    NSArray*dataArray;
    NSInteger rowTable;
    NSInteger rowCollection;
    BOOL isTimerEnabled;
    NSArray* response;
    NSArray* images;
    NSArray*promos;
    NSArray*companies;
    NSArray*logosCompanies;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) UICollectionView *collectionView;
@property (nonatomic, assign) CGPoint scrollingPoint, endPoint;
@property (nonatomic, strong) NSTimer *scrollingTimer;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:128.0/255.0 green:22.0/255.0 blue:30.0/255.0 alpha:1.0]];
    
    UIButton*logo=[UIButton buttonWithType:UIButtonTypeCustom];
    logo.frame = CGRectMake(0, 0, 0, 48);
    logo.imageView.contentMode=UIViewContentModeScaleAspectFit;
    logo.translatesAutoresizingMaskIntoConstraints=YES;
    [logo setImage:[UIImage imageNamed:@"Logo"] forState:UIControlStateNormal];
    logo.userInteractionEnabled=NO;
    logo.tag=1;
    self.navigationItem.titleView = logo;
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    isTimerEnabled = NO;
    
    images=@[@"fa-cutlery",@"fa-glass",@"fa-plane",@"fa-film",@"fa-coffee",@"fa-futbol-o",@"fa-bed",@"fa-shopping-bag"];
    promos=@[@"promo1.png",@"promo2.jpg",@"promo3.jpg",@"promo4.jpg",@"promo5.png"];
    companies=@[@"Friday's",@"Burger King",@"Domino's Pizza",@"Carl's Jr.",@"Lapa Lapa"];
    logosCompanies = @[@"logo1.png",@"logo2.png",@"logo3.jpg",@"logo4.jpeg",@"logo5.jpg"];

    [self getCategories];
    [self setupDataForCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data

-(void)getRoutes{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",@"IKJBJHBJHBJH"] forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"Accept"forHTTPHeaderField:@"application/json"];
    [manager GET:@"http://69.46.5.166:3002/api/Customers/5/favouritesServices?access_token=123123213123" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        NSDictionary*temp=(NSDictionary*)responseObject;
        NSLog(@"Routes: %@", temp);
        [self.myTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",(NSDictionary*)operation.responseObject);
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    }];
}

-(void)getCategories{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:@"http://www.dacodes.com/wrban/api/get-categories.php" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        NSDictionary*temp=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        response = temp[@"categories"];
        NSLog(@"Categories: %@", response);
        [self.myTableView reloadData];
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

-(void)setupDataForCollectionView {
    
    // Create the original set of data
    NSArray *originalArray = @[@"1.png", @"2.jpg", @"3.jpg"];
    
    // Grab references to the first and last items
    // They're typed as id so you don't need to worry about what kind
    // of objects the originalArray is holding
    id firstItem = originalArray[0];
    id lastItem = [originalArray lastObject];
    
    NSMutableArray *workingArray = [originalArray mutableCopy];
    
    // Add the copy of the last item to the beginning
    [workingArray insertObject:lastItem atIndex:0];
    
    // Add the copy of the first item to the end
    [workingArray addObject:firstItem];
    
    // Update the collection view's data source property
    dataArray = [NSArray arrayWithArray:workingArray];
}

#pragma mark - ScrollView

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([[[[[scrollView subviews][0] superview] superview] superview] isKindOfClass:[HomeTableViewCell class]]) {
        HomeTableViewCell* cell = (HomeTableViewCell *)[[[[scrollView subviews][0] superview] superview] superview];
        // Calculate where the collection view should be at the right-hand end item
        float contentOffsetWhenFullyScrolledRight = cell.myCollection.frame.size.width * ([dataArray count] - 1);
        
        if (scrollView.contentOffset.x == contentOffsetWhenFullyScrolledRight) {
            
            // user is scrolling to the right from the last item to the 'fake' item 1.
            // reposition offset to show the 'real' item 1 at the left-hand end of the collection view
            
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];
            
            [cell.myCollection scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
            
        } else if (scrollView.contentOffset.x == 0)  {
            
            // user is scrolling to the left from the first item to the fake 'item N'.
            // reposition offset to show the 'real' item N at the right end end of the collection view
            
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:([dataArray count] -2) inSection:0];
            
            [cell.myCollection scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        }
        self.scrollingPoint = CGPointMake(scrollView.contentOffset.x, self.scrollingPoint.y);
        self.scrollingTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(scrollSlowlyToPoint) userInfo:nil repeats:YES];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([[[[[scrollView subviews][0] superview] superview] superview] isKindOfClass:[HomeTableViewCell class]]) {
        [self.scrollingTimer invalidate];
    }
}

- (void)scrollSlowly {
    // Set the point where the scrolling stops.
    self.endPoint = CGPointMake([dataArray count]*300+1, 0);
    // Assuming that you are starting at {0, 0} and scrolling along the x-axis.
    self.scrollingPoint = CGPointMake(self.view.frame.size.width, 0);
    // Change the timer interval for speed regulation.
    self.scrollingTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(scrollSlowlyToPoint) userInfo:nil repeats:YES];
}

- (void)scrollSlowlyToPoint{
    self.collectionView.contentOffset = self.scrollingPoint;
    // Here you have to respond to user interactions or else the scrolling will not stop until it reaches the endPoint.
    if (CGPointEqualToPoint(self.scrollingPoint, self.endPoint)) {
        [self.scrollingTimer invalidate];
    }
    // Going one pixel to the right.
    self.scrollingPoint = CGPointMake(self.scrollingPoint.x+self.view.frame.size.width, self.scrollingPoint.y);
    float contentOffsetWhenFullyScrolledRight = self.collectionView.frame.size.width * ([dataArray count] - 1);
    
    if (self.collectionView.contentOffset.x == contentOffsetWhenFullyScrolledRight) {
        
        // user is scrolling to the right from the last item to the 'fake' item 1.
        // reposition offset to show the 'real' item 1 at the left-hand end of the collection view
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];
        
        [self.collectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];

        self.scrollingPoint = CGPointMake(self.view.frame.size.width*2, self.scrollingPoint.y);
        [self.collectionView setContentOffset:self.scrollingPoint animated:YES];
    }else{
        [UIView animateWithDuration:1.0 animations:^{
            [self.collectionView setContentOffset:self.scrollingPoint animated:YES];
        }];
    }
}

#pragma mark - TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1+[response count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 150.0;
    }else{
        return 180.0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > 0) {
        static NSString* cellIdentifier = @"Cell1";
        
        HomeCategoryTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        cell.myCollection.delegate=self;
        cell.myCollection.dataSource=self;
        cell.myCollection.alwaysBounceHorizontal = YES;
        cell.myCollection.tag = indexPath.row;
        cell.myCollection.backgroundColor = [UIColor clearColor];
        cell.myCollection.showsHorizontalScrollIndicator = NO;
        cell.serviceName.text = [NSString stringWithFormat:@"%@",response[indexPath.row-1][@"category"]];
        cell.servicePic.image = [UIImage imageWithIcon:images[indexPath.row-1] backgroundColor:[UIColor colorWithHue:(float)(indexPath.row-1)/(float)[response count] saturation:1.0 brightness:1.0 alpha:1.0] iconColor:[UIColor whiteColor] andSize:CGSizeMake(36, 36)];
        
        return cell;
    }else{
        static NSString* cellIdentifier = @"Cell";
        
        HomeTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        cell.myCollection.delegate=self;
        cell.myCollection.dataSource=self;
        cell.myCollection.alwaysBounceHorizontal = YES;
        cell.myCollection.backgroundColor = [UIColor clearColor];
        cell.myCollection.pagingEnabled = YES;
        cell.myCollection.showsHorizontalScrollIndicator = NO;
        self.collectionView = cell.myCollection;
        if (!isTimerEnabled) {
            isTimerEnabled = YES;
            [self.view layoutIfNeeded];
            [cell.myCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
            [self scrollSlowly];
        }
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell isKindOfClass:[HomeCategoryTableViewCell class]]) {
        HomeCategoryTableViewCell*cellCategory = (HomeCategoryTableViewCell *)cell;
        cellCategory.servicePic.layer.cornerRadius = 10.0;
        cellCategory.servicePic.layer.borderColor = [UIColor clearColor].CGColor;
        cellCategory.servicePic.layer.borderWidth = 2.0;
        cellCategory.servicePic.layer.masksToBounds = YES;
        cellCategory.servicePic.clipsToBounds = YES;
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
//    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
//        [cell setPreservesSuperviewLayoutMargins:NO];
//    }
    
    // Explictly set your cell's layout margins
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
}

#pragma mark - CollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [dataArray count];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 0) {
        return CGSizeMake(self.view.frame.size.width, 149);
    }else{
        double w = (collectionView.frame.size.width -5) / 3;
        if(self.view.frame.size.width >= 375) {
            w = (collectionView.frame.size.width - 6) / 3;
        }
        
        return CGSizeMake(w, collectionView.frame.size.height);
    }
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (collectionView.tag == 0) {
        return 0;
    }else{
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView.tag > 0) {
        static NSString *identifier = @"Cell1";
        
        HomeCategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        cell.imagePic.image = [UIImage imageNamed:promos[indexPath.row]];
        cell.name.text = companies[indexPath.row];
        
        [cell layoutIfNeeded];
        [cell setNeedsLayout];
        
        return cell;
    }else{
        static NSString *identifier = @"Cell";
        
        HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        cell.imagePic.image = [UIImage imageNamed:dataArray[indexPath.row]];
        
        [cell layoutIfNeeded];
        [cell setNeedsLayout];
        
        return cell;
    }
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(HomeCategoryCollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell isKindOfClass:[HomeCategoryCollectionViewCell class]]) {
        cell.imagePic.layer.cornerRadius = 15.0;
        cell.imagePic.layer.borderColor = [UIColor clearColor].CGColor;
        cell.imagePic.layer.borderWidth = 2.0;
        cell.imagePic.layer.masksToBounds = YES;
        cell.imagePic.clipsToBounds = YES;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    rowTable = collectionView.tag;
    rowCollection = indexPath.row;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"showPromo" sender:self];
    });
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    PromoViewController* destinationController = segue.destinationViewController;
    if (rowTable == 0) {
        destinationController.promoImage = [dataArray objectAtIndex:rowCollection];
        destinationController.company = [companies objectAtIndex:rowCollection];
        destinationController.logo = [logosCompanies objectAtIndex:rowCollection];
    }else{
        destinationController.promoImage = [promos objectAtIndex:rowCollection];
        destinationController.company = [companies objectAtIndex:rowCollection];
        destinationController.logo = [logosCompanies objectAtIndex:rowCollection];
    }
}

@end
