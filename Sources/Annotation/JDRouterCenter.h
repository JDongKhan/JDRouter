//
//  JDRouterCenter.h
//  JDRouter
//
//  Created by JD on 2019/7/19.
//  Copyright © 2019 王金东. All rights reserved.
//

/**
 1、注册类：使用@JDRouter("xx://xx/xx",className) 来注册并实现handleWithLink:parameters:routerFrom:方法
 2、使用类: [JDRouterCenter openURL:xxx];
 **/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDRouterCenter : NSObject

/**
 注册路由

 @param URL 路由地址
 @param className 类名
 */
+ (void)registerURL:(NSString *)URL className:(NSString *)className;

/**
 打开路由

 @param URL 路由地址
 @return vc
 */
+ (id)openURL:(NSString *)URL;

/**
 打开路由

 @param URL 路由地址
 @param parameters 参数
 @param from 来源
 @param completion 完成回调
 @return vc
 */
+ (id)openURL:(NSString *)URL
   parameters:(NSDictionary<NSString *, id> * _Nullable)parameters
   routerFrom:(id _Nullable)from
   completion:(void(^_Nullable)(id result))completion;

@end

NS_ASSUME_NONNULL_END
