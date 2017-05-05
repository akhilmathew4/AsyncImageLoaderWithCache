//
//  ProfileTableViewCell.h
//  AsyncImageDownlaoder
//
//  Created by Akhil  Mathew on 05/05/17.
//  Copyright © 2017 Akhil  Mathew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageLoader.h"

@interface ProfileTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *profileName;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property BOOL cancelsTask;
@property NSURLSessionDataTask * task;
@property NSURL * activeImageURL;

- (void) setProfile:(NSDictionary *) profile;


@end
