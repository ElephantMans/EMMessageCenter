//
//  MessageSubscriberReleaseHelperCollection.h
//  MessageCenter
//
//  Created by yimi on 2020/4/2.
//  Copyright © 2020 yimi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageSubscriberReleaseHelper.h"


@interface MessageSubscriberReleaseHelperCollection : NSObject

@property (nonatomic, strong) NSMutableArray<MessageSubscriberReleaseHelper *> *helperArray;

- (void)addReleaseHelper:(MessageSubscriberReleaseHelper *)helper;

@end
