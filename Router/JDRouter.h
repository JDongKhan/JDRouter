//
//  JDRouter.h
//  Pods
//
//  Created by 王金东 on 2016/8/27.
//
//

#import <Foundation/Foundation.h>


extern NSString *const JDRouterURL;
extern NSString *const JDRouterCompletion;


typedef void (^JDRouterAction)(NSDictionary *parameters);
typedef id (^JDRouterObjectAction)(NSDictionary *parameters);

@interface JDRouter : NSObject

//为行为注册url
+ (void)registerUrl:(NSString *)Url action:(JDRouterAction)action;
+ (void)registerUrl:(NSString *)Url objectAction:(JDRouterObjectAction)action;
//取消注册
+ (void)unRegisterUrl:(NSString *)Url;

+ (void)openUrl:(NSString *)Url;
//根据UI调用相应行为，并回调
+ (void)openUrl:(NSString *)Url
     completion:(void (^)(id result))completion;

+ (void)openUrl:(NSString *)Url
   userInfo:(NSDictionary *)userInfo
     completion:(void (^)(id result))completion;


//判断是否能打开
+ (BOOL)canOpenUrl:(NSString *)Url;

//直接取
+ (id)objectForUrl:(NSString *)Url;
+ (id)objectForUrl:(NSString *)Url userInfo:(NSDictionary *)userInfo;

@end
