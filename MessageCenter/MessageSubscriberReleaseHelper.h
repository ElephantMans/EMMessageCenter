//
//  MessageSubscriberReleaseHelper.h
//  MessageCenter
//
//  Created by yimi on 2020/4/2.
//  Copyright © 2020 yimi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageSubscriberReleaseHelper : NSObject

@property(nonatomic, strong)NSString *uniqueId;

@property (nonatomic, copy) void(^releaseSubscriberBlock)(NSString *uniqueId);

- (void)releaseSubscriber;

@end
