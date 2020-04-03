//
//  MessageCenter.h
//  MessageCenter
//
//  Created by yimi on 2020/4/1.
//  Copyright © 2020 yimi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageSubscriber.h"

@interface MessageCenter : NSObject

+ (instancetype)shared;

- (void)publishMessage:(NSString *)messageName object:(NSObject *)messageContent;

- (void)asyncPublishMessage:(NSString *)messageName object:(NSObject *)messageContent;


- (void)addMessageSubscriber:(NSString *)messgeName object:(NSObject *)target handle:(void(^)(NSObject *obj))handle;

@end
