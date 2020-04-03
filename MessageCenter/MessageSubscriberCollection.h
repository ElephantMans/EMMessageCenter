//
//  MessageSubscriberCollection.h
//  MessageCenter
//
//  Created by yimi on 2020/4/1.
//  Copyright © 2020 yimi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageSubscriber.h"

@interface MessageSubscriberCollection : NSObject

- (void)addSubscriber:(MessageSubscriber *)subscriber withMessageKey:(NSString *)key;

- (void)removeSubscriber:(NSString *)uniqueId withKey:(NSString *)key;

- (NSArray<MessageSubscriber *> *)subscriberForKey:(NSString *)key;
 
@end
