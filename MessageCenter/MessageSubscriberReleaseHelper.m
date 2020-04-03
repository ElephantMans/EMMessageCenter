//
//  MessageSubscriberReleaseHelper.m
//  MessageCenter
//
//  Created by yimi on 2020/4/2.
//  Copyright © 2020 yimi. All rights reserved.
//

#import "MessageSubscriberReleaseHelper.h"

@implementation MessageSubscriberReleaseHelper

- (void)releaseSubscriber {
    if(self.releaseSubscriberBlock) {
        self.releaseSubscriberBlock(self.uniqueId);
    }
}

@end
