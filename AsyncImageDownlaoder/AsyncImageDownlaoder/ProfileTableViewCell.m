//
//  ProfileTableViewCell.m
//  AsyncImageDownlaoder
//
//  Created by Akhil  Mathew on 05/05/17.
//  Copyright © 2017 Akhil  Mathew. All rights reserved.
//

#import "ProfileTableViewCell.h"

@implementation ProfileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //set to FALSE to let images download even if this cells image has changed while scrolling.
    self.cancelsTask = FALSE;
    
    //set to TRUE to cause downloads to cancel if a cell is being reused.
    //self.cancelsTask = TRUE;
}

- (void) prepareForReuse {
        
    if(self.cancelsTask) {
        [self.task cancel];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setProfile:(NSDictionary *) profile
{
    NSDictionary * images = profile[@"user"];
    NSURL * url = [NSURL URLWithString:images[@"profile_image"][@"small"]];
    self.profileName.text = images[@"name"];
    self.activeImageURL = url;
    
    self.task = [[UIImageLoader defaultLoader] loadImageWithURL:url hasCache:^(UIImageLoaderImage *image, UIImageLoadSource loadedFromSource) {
        
        //hide indicator as we have a cached image available.
        self.activityIndicator.hidden = TRUE;
        
        //use cached image
        self.profileImage.image = image;
        self.profileImage.contentMode = UIViewContentModeScaleAspectFit;
        
    } sendingRequest:^(BOOL didHaveCachedImage) {
        
        if(!didHaveCachedImage) {
            //a cached image wasn't available, a network request is being sent, show spinner.
            [self.activityIndicator startAnimating];
            self.activityIndicator.hidden = FALSE;
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
        self.activityIndicator.hidden = TRUE;
        [self.activityIndicator stopAnimating];
        
        //if image was downloaded, use it.
        if(loadedFromSource == UIImageLoadSourceNetworkToDisk) {
            self.profileImage.image = image;
            self.profileImage.contentMode = UIViewContentModeScaleAspectFit;
        }
    }];
}

@end
