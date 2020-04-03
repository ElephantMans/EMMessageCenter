//
//  NSObject+MessageTarget.m
//  MessageCenter
//
//  Created by yimi on 2020/4/2.
//  Copyright © 2020 yimi. All rights reserved.
//

#import "NSObject+MessageTarget.h"
#import <objc/runtime.h>

static const char messagecenter_subscriber_release_helpers;

@implementation NSObject(MessageTarget)

- (MessageSubscriberReleaseHelperCollection *)messageSubscriberReleaseHelpers {
    MessageSubscriberReleaseHelperCollection *collection = objc_getAssociatedObject(self, &messagecenter_subscriber_release_helpers);
    if(!collection) {
        collection = [[MessageSubscriberReleaseHelperCollection alloc]init];
    }
    objc_setAssociatedObject(self, &messagecenter_subscriber_release_helpers, collection, OBJC_ASSOCIATION_RETAIN);
    return collection;
}

- (void)setMessageSubscriberReleaseHelpers:(MessageSubscriberReleaseHelperCollection *)messageSubscriberReleaseHelpers {
    objc_setAssociatedObject(self, &messagecenter_subscriber_release_helpers, messageSubscriberReleaseHelpers, OBJC_ASSOCIATION_RETAIN);
}

@end
