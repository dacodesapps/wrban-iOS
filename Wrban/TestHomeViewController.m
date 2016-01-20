//
//  TestHomeViewController.m
//  Wrban
//
//  Created by Dacodes on 03/01/16.
//  Copyright © 2016 Dacodes. All rights reserved.
//

#import "TestHomeViewController.h"
#import "HomeCategoryTableViewCell.h"
#import "HomeCategoryCollectionViewCell.h"

@interface TestHomeViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollViewContentView;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation TestHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTableView.delegate=self;
    self.myTableView.dataSource=self;
    self.myTableView.scrollEnabled = NO;
    self.myScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 2000);
    [self.view addSubview:self.scrollViewContentView];
    [self layoutScrollSubviews];
}

-(void)layoutScrollSubviews{
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.scrollViewContentView attribute:NSLayoutAttributeLeading relatedBy:0 toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    [self.view addConstraint:leftConstraint];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.scrollViewContentView attribute:NSLayoutAttributeTrailing relatedBy:0 toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    [self.view addConstraint:rightConstraint];
}

-(void)viewDidLayoutSubviews{
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifier = @"Cell1";
    
    HomeCategoryTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.myCollection.delegate=self;
    cell.myCollection.dataSource=self;
    cell.myCollection.alwaysBounceHorizontal = YES;
    cell.myCollection.tag = 1;
    cell.myCollection.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma mark - CollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag != 1) {
        return CGSizeMake(self.view.frame.size.width, 149);
    }else{
        double w = (collectionView.frame.size.width -5) / 3;
        if(self.view.frame.size.width >= 375) {
            w = (collectionView.frame.size.width - 6) / 3;
        }
        NSLog(@"%f %f",w,w);
        NSLog(@"%f",collectionView.frame.size.height);
        return CGSizeMake(w, collectionView.frame.size.height);
    }
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if(self.view.frame.size.width >= 375) {
        return 3;
    }
    else {
        return 2.5;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell1";
    
    HomeCategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.imagePic.image = [UIImage imageNamed:@"mit.jpg"];
    
    [cell layoutIfNeeded];
    [cell setNeedsLayout];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    //    NSLog(@"%@",[[[collectionView superview] superview] class]);
    ////    if ([[[collectionView superview] superview] isKindOfClass:HomeTableViewCell]) {
    ////    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"showVenta" sender:self];
    });
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
