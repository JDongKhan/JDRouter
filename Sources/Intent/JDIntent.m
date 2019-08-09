//
//  JDIntent.m
//  JDIntent
//
//  Created by wjd on 16/8/13.
//  Copyright © 2016年 wjd. All rights reserved.
//

#import "JDIntent.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

static NSArray<NSString *> *_kIntentSchemes = nil;

@interface JDIntent ()

@end

@implementation JDIntent

#pragma mark - public methods
+ (instancetype)sharedInstance {
    static JDIntent *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JDIntent alloc] init];
    });
    return instance;
}
/*
 scheme://[target]/[action]?[params]
 baba://user/gotoNext
 */

+ (void)supportScheme:(NSArray<NSString *> *)schemes {
    _kIntentSchemes = schemes;
}

+ (id)openUrl:(NSString *)url {
    return [self openUrl:url completion:nil];
}

+ (id)openUrl:(NSString *)url from:(id)from {
    return [self openUrl:url from:from completion:nil];
}

+ (id)openUrl:(NSString *)url
         from:(id)from
   completion:(JDIntentComplete)completion {
    return [self openUrl:url userInfo:nil from:from completion:completion];
}

+ (id)openUrl:(NSString *)url userInfo:(NSDictionary *)userInfo {
    return [self openUrl:url userInfo:userInfo  completion:nil];
}

+ (id)openUrl:(NSString *)url
     userInfo:(NSDictionary *)userInfo
   completion:(JDIntentComplete)completion {
   return [self openUrl:url userInfo:userInfo from:nil completion:completion];
}

+ (id)openUrl:(NSString *)url
   completion:(JDIntentComplete)completion {
    return [self openUrl:url from:nil completion:completion];
}

+ (id)openUrl:(NSString *)urlString
     userInfo:(NSDictionary *)userInfo
         from:(id)from
   completion:(JDIntentComplete)completion {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSString *scheme = url.scheme;
    
    if (_kIntentSchemes != nil && ![_kIntentSchemes containsObject:scheme]) {
        return nil;
    }
    
    NSArray<NSURLQueryItem *> *queryItems = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:false].queryItems;
    for (NSURLQueryItem *item in queryItems) {
        params[item.name] = item.value;
    }
    NSString *actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if ([actionName hasPrefix:@"native"]) {
        return @(NO);
    }
   return [[JDIntent sharedInstance] performTarget:url.host
                                            action:actionName
                                            params:params
                                              from:from
                                        completion:completion];
}

- (id)performTarget:(NSString *)targetName
             action:(NSString *)actionName
             params:(NSDictionary *)params
               from:(id)from
         completion:(JDIntentComplete)completion {
    
    NSString *tn = [NSString stringWithFormat:@"%@%@",[targetName substringToIndex:1].uppercaseString,[targetName substringFromIndex:1]];
    NSString *targetClassString = [NSString stringWithFormat:@"%@Intent", tn];
    
    NSObject *target = CFDictionaryGetValue(self.cachedTarget, (__bridge const void *)(targetClassString));
    if (target == nil) {
        target = [[NSClassFromString(targetClassString) alloc] init];
        if (target == nil) {
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *projectName = [infoDictionary objectForKey:@"CFBundleExecutable"];
            NSString *className = [NSString stringWithFormat:@"%@.%@",projectName,targetClassString];
            target = [[NSClassFromString(className) alloc] init ];
            if (target == nil) {
                NSLog(@"没有配置Intent");
                return nil;
            }
        }
        CFDictionarySetValue(self.cachedTarget, (__bridge const void *)(targetClassString), (__bridge const void *)(target));
    }
    
    JDIntentData *intentData = [[JDIntentData alloc] init];
    intentData.from = from;
    intentData.params = params;
    intentData.complete = completion;
    
    actionName = [actionName stringByAppendingString:@":"];
    
    id result = [self target:target action:actionName  intentData:intentData];
    if (result) {
        return result;
    }
    SEL action = NSSelectorFromString(@"notFound:");
    if ([target respondsToSelector:action]) {
        return [self safePerformAction:action target:target intentData:intentData];
    }
    NSLog(@"我尽力了，找不到你的Intent配置");
    CFDictionaryRemoveValue(self.cachedTarget, (__bridge const void *)(targetClassString));
    return nil;
}

- (id)target:(id)target
      action:(NSString *)actionName
      intentData:(JDIntentData *)intentData {
 
    SEL action = NSSelectorFromString(actionName);
    
    if ([target respondsToSelector:action]) {
        return [self safePerformAction:action target:target intentData:intentData];
    }
    return nil;
}

+ (void)clearTarget:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSString *targetName = url.host;
    NSString *tn = [NSString stringWithFormat:@"%@%@",[targetName substringToIndex:1].uppercaseString,[targetName substringFromIndex:1]];
    NSString *targetClassString = [NSString stringWithFormat:@"%@Intent", tn];
    CFDictionaryRemoveValue([JDIntent sharedInstance].cachedTarget, (__bridge const void *)(targetClassString));
}

- (id)safePerformAction:(SEL)action
                 target:(NSObject *)target
             intentData:(JDIntentData *)intentData {
    NSMethodSignature *methodSig = [target methodSignatureForSelector:action];
    if(methodSig == nil) {
        return nil;
    }
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
    [invocation setArgument:&intentData atIndex:2];
    [invocation setSelector:action];
    [invocation setTarget:target];
    [invocation invoke];
    
    const char* retType = [methodSig methodReturnType];
    if (strcmp(retType, @encode(void)) == 0) {
        return nil;
    }
    if (strcmp(retType, @encode(NSInteger)) == 0){
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    if (strcmp(retType, @encode(BOOL)) == 0) {
        BOOL result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    if (strcmp(retType, @encode(CGFloat)) == 0) {
        CGFloat result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    if (strcmp(retType, @encode(NSUInteger)) == 0) {
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    __unsafe_unretained id result;
    [invocation getReturnValue:&result];
    return result;
}

#pragma mark - getters and setters
- (CFMutableDictionaryRef)cachedTarget {
    static CFMutableDictionaryRef cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    });

    return cache;
}

@end


@implementation JDIntentData


@end
