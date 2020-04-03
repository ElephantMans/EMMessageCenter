//
//  NSObject+MessageTarget.h
//  MessageCenter
//
//  Created by yimi on 2020/4/2.
//  Copyright © 2020 yimi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageSubscriberReleaseHelperCollection.h"

@interface NSObject(MessageTarget)

@property (nonatomic, strong) MessageSubscriberReleaseHelperCollection *messageSubscriberReleaseHelpers;


@end

