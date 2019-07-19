//
//  JDIntent.h
//  JDIntent
//
//  Created by wjd on 16/8/13.
//  Copyright © 2016年 wjd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^JDIntentCompletion)(NSDictionary *info);

@interface JDIntent : NSObject

+ (instancetype)sharedInstance;

+ (id)openUrl:(NSString *)url;

+ (id)openUrl:(NSString *)url from:(id)from;

+ (id)openUrl:(NSString *)url
         from:(id)from
   completion:(JDIntentCompletion)completion;

+ (id)openUrl:(NSString *)url  userInfo:(NSDictionary *)userInfo;

+ (id)openUrl:(NSString *)url
     userInfo:(NSDictionary *)userInfo
   completion:(JDIntentCompletion)completion;

+ (id)openUrl:(NSString *)url
   completion:(JDIntentCompletion)completion;

+ (id)openUrl:(NSString *)urlString
     userInfo:(NSDictionary *)userInfo
         from:(id)from
   completion:(JDIntentCompletion)completion;


- (void)clearTarget:(NSString *)url;

@end
