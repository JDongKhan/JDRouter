//
//  JDRouterCenter.h
//  JDRouter
//
//  Created by JD on 2019/7/19.
//  Copyright © 2019 王金东. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDRouterCenter : NSObject

+ (void)registerURL:(NSString *)URL className:(NSString *)className;

+ (id)openURL:(NSString *)URL;

+ (id)openURL:(NSString *)URL
   parameters:(NSDictionary<NSString *, id> * _Nullable)parameters
   routerFrom:(id _Nullable)from
   completion:(void(^_Nullable)(id result))completion;

@end

NS_ASSUME_NONNULL_END
