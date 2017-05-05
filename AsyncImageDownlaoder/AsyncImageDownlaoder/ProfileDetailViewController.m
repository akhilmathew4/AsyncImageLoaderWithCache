//
//  ProfileDetailViewController.m
//  AsyncImageDownlaoder
//
//  Created by Akhil  Mathew on 05/05/17.
//  Copyright © 2017 Akhil  Mathew. All rights reserved.
//

#import "ProfileDetailViewController.h"
#import "UIImageLoader.h"
#import "MBProgressHUD.h"


@interface ProfileDetailViewController ()

@end

@implementation ProfileDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Category Image";
    [self cancelationExample];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
//    [self loadImageFromURL];
}
- (void)loadImageFromURL
{
    NSDictionary * images = self.profileDeatil[@"urls"];
    NSURL * url = [NSURL URLWithString:images[@"small"]];
    self.activeImageURL = url;
    
    self.task = [[UIImageLoader defaultLoader] loadImageWithURL:url hasCache:^(UIImageLoaderImage *image, UIImageLoadSource loadedFromSource) {
        
        //hide indicator as we have a cached image available.
        [MBProgressHUD hideHUDForView:self.view animated:TRUE];
        
        //use cached image
        self.profileDetailImage.image = image;
        self.profileDetailImage.contentMode = UIViewContentModeScaleAspectFit;
        
    } sendingRequest:^(BOOL didHaveCachedImage) {
        
        if(!didHaveCachedImage) {
            //a cached image wasn't available, a network request is being sent, show spinner.
            
        }
        
    } requestCompleted:^(NSError *error, UIImageLoaderImage *image, UIImageLoadSource loadedFromSource) {
        
        //request complete.
        
        //check if url above matches self.activeURL.
        //If they don't match this cells image is going to be different.
        if(!self.cancelsTask && ![self.activeImageURL.absoluteString isEqualToString:url.absoluteString]) {
            //NSLog(@"request finished, but images don't match.");
            return;
        }
        
        //hide spinner
        [MBProgressHUD hideHUDForView:self.view animated:TRUE];
        
        //if image was downloaded, use it.
        if(loadedFromSource == UIImageLoadSourceNetworkToDisk) {
            self.profileDetailImage.image = image;
            self.profileDetailImage.contentMode = UIViewContentModeScaleAspectFit;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Action Button Loader

- (void)cancelationExample {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Set the determinate mode to show task progress.
    hud.mode = MBProgressHUDModeDeterminate;
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    
    // Configure the button.
    [hud.button setTitle:NSLocalizedString(@"Cancel", @"HUD cancel button title") forState:UIControlStateNormal];
    [hud.button addTarget:self action:@selector(cancelWork:) forControlEvents:UIControlEventTouchUpInside];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        // Do something useful in the background and update the HUD periodically.
        [self doSomeWorkWithProgress];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
    [self loadImageFromURL];
}

#pragma mark - network loader



- (void)doSomeWorkWithProgress {
    self.canceled = NO;
    // This just increases the progress indicator in a loop.
    float progress = 0.0f;
    while (progress < 1.0f) {
        if (self.canceled) break;
        progress += 0.01f;
        dispatch_async(dispatch_get_main_queue(), ^{
            // Instead we could have also passed a reference to the HUD
            // to the HUD to myProgressTask as a method parameter.
            [MBProgressHUD HUDForView:self.view].progress = progress;
        });
        usleep(50000);
    }
}

- (void)cancelWork:(id)sender {
    self.canceled = YES;
    [self.task cancel];
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
