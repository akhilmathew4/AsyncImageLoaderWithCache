//
//  ProfileViewController.h
//  AsyncImageDownlaoder
//
//  Created by Akhil  Mathew on 05/05/17.
//  Copyright © 2017 Akhil  Mathew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileServiceCall.h"
#import "MBProgressHUD.h"
#import "SVPullToRefresh.h"

@interface ProfileViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property NSMutableArray * profiles;
@property NSInteger page;
@property NSInteger maxPage;
@property ProfileServiceCall * profileServiceCall;
@property UIView *bodyView;

@property (strong, nonatomic) IBOutlet UITableView *ProfileTableView;
@end
