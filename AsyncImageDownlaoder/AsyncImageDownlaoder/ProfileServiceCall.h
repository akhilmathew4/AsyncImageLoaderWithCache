//
//  ProfileServiceCall.h
//  AsyncImageDownlaoder
//
//  Created by Akhil  Mathew on 05/05/17.
//  Copyright © 2017 Akhil  Mathew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProfileDataModel.h"

typedef void (^ProfileCompletionBlock)(ProfileDataModel * response);

@interface ProfileServiceCall : NSObject<NSURLSessionDelegate>

//default configured session.
@property NSURLSession * defaultSession;

-(void)getAllProfileDataFromURL:(NSURL *)url withCompletionBlock:(ProfileCompletionBlock)completion;

@end
