//
//  MessageSubscriberCollection.m
//  MessageCenter
//
//  Created by yimi on 2020/4/1.
//  Copyright © 2020 yimi. All rights reserved.
//

#import "MessageSubscriberCollection.h"
#include <pthread.h>

@interface MessageSubscriberLinkNode : NSObject

@property (nonatomic, weak) MessageSubscriberLinkNode *nextNode;
@property (nonatomic, weak) MessageSubscriberLinkNode *previousNode;
@property (nonatomic, strong) MessageSubscriber *subscriber;
@property (nonatomic, strong) NSString *subscriberKey;

@end

@implementation MessageSubscriberLinkNode


- (instancetype)initWithSubscriber:(MessageSubscriber *)subscriber withKey:(NSString *)key {
    if(self = [super init]) {
        _subscriber = subscriber;
        _subscriberKey = key;
    }
    return self;
}
@end

@interface MessageSubscriberLinkList : NSObject

@property (nonatomic, strong) MessageSubscriberLinkNode *headNode;

@property (nonatomic, strong) MessageSubscriberLinkNode *trailNode;

@property (nonatomic, strong) NSMutableDictionary *registeredNodeDic;

@end

@implementation MessageSubscriberLinkList

- (instancetype)initWithNode:(MessageSubscriberLinkNode *)node {
    if(self = [super init]) {
        _headNode = node;
        _trailNode = node;
        _registeredNodeDic = [NSMutableDictionary new];
        [_registeredNodeDic setObject:node forKey:node.subscriberKey];
    }
    return self;
}

- (BOOL)isEmpty {
    return _headNode == nil;
}

- (void)addNode:(MessageSubscriberLinkNode *)node {
    if (_headNode == nil) {
        _headNode = node;
        _trailNode = node;
        return;
    }
    MessageSubscriberLinkNode * oldNode = [_registeredNodeDic objectForKey:node.subscriberKey];
    if (oldNode) {
        [self replaceNode:oldNode withNode:node];
        return;
    }
    _trailNode.nextNode = node;
    node.previousNode = _trailNode;
    _trailNode = node;
    [_registeredNodeDic setObject:node forKey:node.subscriberKey];
}

- (void)replaceNode:(MessageSubscriberLinkNode *)olderNode withNode:(MessageSubscriberLinkNode *)newNode {
    newNode.nextNode = olderNode.nextNode;
    newNode.previousNode = olderNode.previousNode;
    olderNode.previousNode.nextNode = newNode;
    olderNode.nextNode.previousNode = newNode;
    if([olderNode.subscriberKey isEqualToString:_headNode.subscriberKey]) {
        _headNode = newNode;
    } else if([olderNode.subscriberKey isEqualToString:_trailNode.subscriberKey]) {
        _trailNode = newNode;
    }
    [_registeredNodeDic setObject:newNode forKey:newNode.subscriberKey];
}

- (void)removeNode:(NSString *)subscriberKey {
    if(![_registeredNodeDic objectForKey:subscriberKey]) {
        return;
    }
    MessageSubscriberLinkNode *node = [_registeredNodeDic objectForKey:subscriberKey];
    if(node == _headNode) {
        _headNode = _headNode.nextNode;
    }
    if(node == _trailNode) {
        _trailNode = _trailNode.previousNode;
    }
    MessageSubscriberLinkNode *previousNode = node.previousNode;
    MessageSubscriberLinkNode *nextNode = node.nextNode;
    node.previousNode = nil;
    node.nextNode = nil;
    previousNode.nextNode = nextNode;
    nextNode.previousNode = previousNode;
    [_registeredNodeDic removeObjectForKey:subscriberKey];
}

- (NSArray *)toArray {
    NSMutableArray * array = [[NSMutableArray alloc] init];
    MessageSubscriberLinkNode * pointer = _headNode;
    while (pointer != nil) {
        if (pointer.subscriber) {
            [array addObject:pointer.subscriber];
        }
        pointer = pointer.nextNode;
    }
    return [[NSArray alloc] initWithArray:array];
}


@end


@interface MessageSubscriberCollection() {
    pthread_mutex_t accessLock;
}

@property (nonatomic, strong)NSMutableDictionary<NSString *, MessageSubscriberLinkList *> *subscriberTable;


@end


@implementation MessageSubscriberCollection

- (instancetype) init {
    if(self = [super init]) {
        _subscriberTable = [[NSMutableDictionary alloc]init];
        pthread_mutex_init(&accessLock, NULL);
    }
    return self;
}

- (void)addSubscriber:(MessageSubscriber *)subscriber withMessageKey:(NSString *)key {
    pthread_mutex_lock(&accessLock);
    MessageSubscriberLinkList *linkList = [self.subscriberTable objectForKey:key];
    MessageSubscriberLinkNode *node = [[MessageSubscriberLinkNode alloc]initWithSubscriber:subscriber withKey:subscriber.uniqueId];
    if(!linkList) {
        linkList = [[MessageSubscriberLinkList alloc]initWithNode:node];
        [self.subscriberTable setObject:linkList forKey:key];
    } else {
        [linkList addNode:node];
    }
    pthread_mutex_unlock(&accessLock);
}

- (void)removeSubscriber:(NSString *)uniqueId withKey:(NSString *)key {
    pthread_mutex_lock(&accessLock);
    MessageSubscriberLinkList *linkList = [self.subscriberTable objectForKey:key];
    if([linkList isEmpty]) {
        [self.subscriberTable removeObjectForKey:key];
    } else {
        [linkList removeNode:uniqueId];
    }
    pthread_mutex_unlock(&accessLock);
}

- (NSArray<MessageSubscriber *> *)subscriberForKey:(NSString *)key {
    pthread_mutex_lock(&accessLock);
    NSMutableArray<MessageSubscriber *> *array = [NSMutableArray array];
    MessageSubscriberLinkList *linkList = [self.subscriberTable objectForKey:key];
    if(![linkList isEmpty]) {
        [array addObjectsFromArray:[linkList toArray]];
    }
    pthread_mutex_unlock(&accessLock);
    return array;
}

@end
