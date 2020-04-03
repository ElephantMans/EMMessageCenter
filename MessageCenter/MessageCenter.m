//
//  MessageCenter.m
//  MessageCenter
//
//  Created by yimi on 2020/4/1.
//  Copyright © 2020 yimi. All rights reserved.
//

#import "MessageCenter.h"
#import "MessageSubscriberCollection.h"
#import "NSObject+MessageTarget.h"

@interface MessageCenter()

@property (nonatomic, strong) MessageSubscriberCollection *subscriberCollection;

@end

@implementation MessageCenter

+ (instancetype)shared {
    static MessageCenter *messageCenter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        messageCenter = [[MessageCenter alloc]init];
    });
    return messageCenter;
}

- (instancetype)init {
    if(self = [super init]) {
        _subscriberCollection = [[MessageSubscriberCollection alloc]init];
    }
    return self;
}

- (void)publishMessage:(NSString *)messageName object:(NSObject *)messageContent {
    NSArray<MessageSubscriber *> *subscribers = [self.subscriberCollection subscriberForKey:messageName];
    if(!subscribers || subscribers.count == 0) {
        return;
    }
    for(MessageSubscriber *subscriber in subscribers) {
        subscriber.handle(messageContent);
    }
}

- (void)asyncPublishMessage:(NSString *)messageName object:(NSObject *)messageContent {
    NSArray<MessageSubscriber *> *subscribers = [self.subscriberCollection subscriberForKey:messageName];
       if(!subscribers || subscribers.count == 0) {
           return;
       }
       for(MessageSubscriber *subscriber in subscribers) {
           dispatch_async(dispatch_get_main_queue(), ^{
               subscriber.handle(messageContent);
           });
       }
}

- (void)addMessageSubscriber:(NSString *)messgeName object:(NSObject *)target handle:(void (^)(NSObject *))handle {
    NSString * uniqueId = [messgeName stringByAppendingString:@([NSDate date].timeIntervalSince1970).stringValue];
    MessageSubscriberReleaseHelper *helper = [[MessageSubscriberReleaseHelper alloc]init];
    helper.uniqueId = uniqueId;
    __weak typeof(self) weakSelf = self;
    helper.releaseSubscriberBlock = ^(NSString *uniqueId) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.subscriberCollection removeSubscriber:uniqueId withKey:messgeName];
    };
    [target.messageSubscriberReleaseHelpers addReleaseHelper:helper];
    MessageSubscriber *subscriber = [[MessageSubscriber alloc]init];
    subscriber.obj = target;
    subscriber.handle = handle;
    subscriber.uniqueId = uniqueId;
    [self.subscriberCollection addSubscriber:subscriber withMessageKey:messgeName];
}

@end
