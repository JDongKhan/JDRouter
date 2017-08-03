//
//  JDServiceCenter.m
//  JDRouter
//
//  Created by 王金东 on 2017/7/31.
//  Copyright © 2017年 王金东. All rights reserved.
//

#import "JDServiceCenter.h"

@interface JDServiceCenter ()
@property (nonatomic, strong) NSMutableDictionary *services;
@property (nonatomic, strong) NSRecursiveLock *lock;
@end

@implementation JDServiceCenter

+ (JDServiceCenter *)sharedInstance {
    static JDServiceCenter * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        _services = [[NSMutableDictionary alloc] init];
    }
    return self;
}

//简单的demo，没有任何逻辑判断
+ (void)registerService:(id)service protocol:(Protocol*)protocol {
    if (service == nil || protocol == nil)
        return;
    [[self sharedInstance].services setObject:service forKey:NSStringFromProtocol(protocol)];
}

+ (id)serviceForProtocol:(Protocol *)protocol {
    Class clazz = [[self sharedInstance].services objectForKey:NSStringFromProtocol(protocol)];
    return [[clazz alloc] init];
}


- (NSRecursiveLock *)lock {
    if (!_lock) {
        _lock = [[NSRecursiveLock alloc] init];
    }
    return _lock;
}

@end
