//
//  JDIntent.h
//  JDIntent
//
//  Created by wjd on 16/8/13.
//  Copyright © 2016年 wjd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^JDIntentComplete)(id info);

@interface JDIntentData : NSObject

@property (nonatomic, strong) NSDictionary *params;

@property (nonatomic, weak) id from;

@property (nonatomic, copy) JDIntentComplete complete;


@end

@interface JDIntent : NSObject

/**
 支持的schemes

 @param schemes schemes
 */
+ (void)supportScheme:(NSArray<NSString *> *)schemes;

/*
 URL:
 scheme://[target]/[action]?[params]
 such as baba://user/gotoNext
 */

/**
 打开URL

 @param url URL
 @return 返回将要调用方法的返回值
 */
+ (id)openUrl:(NSString *)url;

/**
 打开URL
 
 @param url URL
 @param from 来源
 @return 返回将要调用方法的返回值
 */
+ (id)openUrl:(NSString *)url from:(id)from;

+ (id)openUrl:(NSString *)url
         from:(id)from
   completion:(JDIntentComplete)completion;

+ (id)openUrl:(NSString *)url  userInfo:(NSDictionary *)userInfo;

+ (id)openUrl:(NSString *)url
     userInfo:(NSDictionary *)userInfo
   completion:(JDIntentComplete)completion;

+ (id)openUrl:(NSString *)url
   completion:(JDIntentComplete)completion;

+ (id)openUrl:(NSString *)urlString
     userInfo:(NSDictionary *)userInfo
         from:(id)from
   completion:(JDIntentComplete)completion;


+ (void)clearTarget:(NSString *)url;

@end
