//
//  ProfileDetailViewController.h
//  AsyncImageDownlaoder
//
//  Created by Akhil  Mathew on 05/05/17.
//  Copyright © 2017 Akhil  Mathew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileDetailViewController : UIViewController <NSURLSessionDataDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *profileDetailImage;

@property NSDictionary *profileDeatil;

@property BOOL cancelsTask;
@property NSURLSessionDataTask * task;
@property NSURL * activeImageURL;
@property (atomic, assign) BOOL canceled;



@end
