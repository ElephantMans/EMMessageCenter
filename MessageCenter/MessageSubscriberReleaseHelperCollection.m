//
//  MessageSubscriberReleaseHelperCollection.m
//  MessageCenter
//
//  Created by yimi on 2020/4/2.
//  Copyright © 2020 yimi. All rights reserved.
//

#import "MessageSubscriberReleaseHelperCollection.h"

@implementation MessageSubscriberReleaseHelperCollection

- (instancetype)init {
    if(self == [super init]) {
        _helperArray = [[NSMutableArray<MessageSubscriberReleaseHelper *> alloc]init];;
    }
    return self;
}


- (void)addReleaseHelper:(MessageSubscriberReleaseHelper *)helper {
    @synchronized (self) {
        if(helper) {
            [self.helperArray addObject:helper];
        }
    }
}

- (void)dealloc {
    @synchronized (self) {
        for(MessageSubscriberReleaseHelper *helper in self.helperArray) {
            if([helper respondsToSelector:@selector(releaseSubscriber)]) {
                [helper releaseSubscriber];
            }
        }
    }
}

@end
