//
//  ProfileServiceCall.m
//  AsyncImageDownlaoder
//
//  Created by Akhil  Mathew on 05/05/17.
//  Copyright © 2017 Akhil  Mathew. All rights reserved.
//

#import "ProfileServiceCall.h"

@implementation ProfileServiceCall

- (id) init {
    self = [super init];
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.defaultSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    return self;
}

- (void)getAllProfileDataFromURL:(NSURL *)url withCompletionBlock:(ProfileCompletionBlock)completion
{
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    __weak ProfileServiceCall * weakSelf = self;
    NSURLSessionDataTask * task = [self.defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [weakSelf __handleExpectingJSONResponse:response data:data error:error completion:completion];
    }];
    [task resume];
}

- (void) __handleExpectingJSONResponse:(NSURLResponse *) response data:(NSData *) data error:(NSError *) error completion:(ProfileCompletionBlock) completion {
    NSObject * json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    ProfileDataModel * profileDataresponse = [[ProfileDataModel alloc] init];
    if(error) {
        profileDataresponse.error = error;
    } else if([json isKindOfClass:[NSArray class]]) {
        profileDataresponse.dataResponse = json;
    } else if([json isKindOfClass:[NSDictionary class]]) {
        __weak NSDictionary * jsondict = (NSDictionary *)json;
        NSString * message = [jsondict objectForKey:@"message"];
        if(message) {
            
        } else {
            profileDataresponse.dataResponse = json;
        }
    }
    completion(profileDataresponse);
}

@end
