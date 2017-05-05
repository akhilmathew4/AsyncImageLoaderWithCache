//
//  ProfileViewController.m
//  AsyncImageDownlaoder
//
//  Created by Akhil  Mathew on 05/05/17.
//  Copyright © 2017 Akhil  Mathew. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileTableViewCell.h"
#import "ProfileDetailViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Profiles";
    
    __weak ProfileViewController *weakSelf = self;
    
    self.page = 0;
    self.maxPage = 1;
    self.profiles = [[NSMutableArray alloc] init];
    self.profileServiceCall = [[ProfileServiceCall alloc]init];
    
    UINib * nib = [UINib nibWithNibName:@"ProfileTableViewCell" bundle:nil];
    [self.ProfileTableView registerNib:nib forCellReuseIdentifier:@"profileTableCell"];
    self.ProfileTableView.delegate = self;
    self.ProfileTableView.dataSource = self;
    
    
    
    [self loadProfile];
    
    // setup pull-to-refresh
    [self.ProfileTableView addPullToRefreshWithActionHandler:^{
        weakSelf.maxPage++;
        [weakSelf loadProfile];
    }];
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    hud.label.text = @"Loading Profiles";
    

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


 - (void)loadProfile
{
    self.page++;
    
    //this loads 10 profiles up to max pages.
    [self.profileServiceCall getAllProfileDataFromURL:[NSURL URLWithString:@"http://pastebin.com/raw/wgkJgazE"] withCompletionBlock:^(ProfileDataModel *response) {
        [self insertRowAtTop:response.dataResponse];
        [self.profiles addObjectsFromArray:response.dataResponse];
        if(self.page < self.maxPage) {
            [self performSelectorOnMainThread:@selector(loadProfile) withObject:nil waitUntilDone:FALSE];
        } else {
            [self finishedLoad];
        }
    }];
    
}

- (void) finishedLoad {
    
}

- (void)insertRowAtTop:(NSArray *)profilesArray {
    __weak ProfileViewController *weakSelf = self;
    NSMutableArray *intermediateArray = [[NSMutableArray alloc]initWithArray:profilesArray];
    [intermediateArray addObjectsFromArray:self.profiles];
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.profiles removeAllObjects];
        [weakSelf.profiles addObjectsFromArray:intermediateArray];
        [weakSelf.ProfileTableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:TRUE];
        [weakSelf.ProfileTableView.pullToRefreshView stopAnimating];
    });
}


#pragma mark - TableView Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.profiles.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"profileTableCell" forIndexPath:indexPath];
    [cell setProfile:[self.profiles objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProfileDetailViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"profileDetailView"];
    detailViewController.profileDeatil = [self.profiles objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailViewController animated:true];
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
