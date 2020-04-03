//
//  MessageSubscriber.h
//  MessageCenter
//
//  Created by yimi on 2020/4/1.
//  Copyright © 2020 yimi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageSubscriber : NSObject

@property (nonatomic, strong) NSObject *obj;
@property (nonatomic, assign) void (^handle)(NSObject *);
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) NSString *uniqueId;


@end

NS_ASSUME_NONNULL_END
