//
//  CategoriesViewController.m
//  Wrban
//
//  Created by Dacodes on 14/12/15.
//  Copyright © 2015 Dacodes. All rights reserved.
//

#import "CategoriesViewController.h"
#import "AFNetworking.h"
#import "NSString+FontAwesome.h"
#import "UIImage+FontAwesome.h"

@interface CategoriesViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray*response;
    NSArray*images;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation CategoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
//    UIImage *icon = [UIImage imageWithIcon:@"fa-bars" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] andSize:CGSizeMake(26, 26)];
//    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:icon style:UIBarButtonItemStylePlain target:nil action:nil];
//    [self.navigationItem setLeftBarButtonItem:leftBarButton];
//    
//    icon = [UIImage imageWithIcon:@"fa-cog" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] andSize:CGSizeMake(26, 26)];
//    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:icon style:UIBarButtonItemStylePlain target:nil action:nil];
//    [self.navigationItem setRightBarButtonItem:rightBarButton];
    
    images=@[@"fa-cutlery",@"fa-glass",@"fa-plane",@"fa-film",@"fa-coffee",@"fa-futbol-o",@"fa-bed",@"fa-shopping-bag"];
    [self getCategories];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FetchData

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

#pragma mark - TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [response count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifier = @"Cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",response[indexPath.row][@"category"]];
    cell.imageView.image = [UIImage imageWithIcon:images[indexPath.row] backgroundColor:[UIColor colorWithHue:(float)indexPath.row/(float)[response count] saturation:1.0 brightness:1.0 alpha:1.0] iconColor:[UIColor whiteColor] andSize:CGSizeMake(36, 36)];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.imageView.layer.cornerRadius = 10;
    cell.imageView.layer.borderColor = [UIColor clearColor].CGColor;
    cell.imageView.layer.borderWidth = 2.0;
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.clipsToBounds = YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"showBusiness" sender:self];
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
