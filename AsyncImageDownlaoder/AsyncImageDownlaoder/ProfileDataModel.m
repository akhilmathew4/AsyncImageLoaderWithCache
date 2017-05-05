//
//  ProfileDataModel.m
//  AsyncImageDownlaoder
//
//  Created by Akhil  Mathew on 05/05/17.
//  Copyright © 2017 Akhil  Mathew. All rights reserved.
//

#import "ProfileDataModel.h"

@implementation ProfileDataModel

- (NSString *) description {
    if(self.dataResponse) {
        return [self.dataResponse description];
    }
    if(self.error) {
        return [self.error description];
    }
    return [super description];
}


@end
