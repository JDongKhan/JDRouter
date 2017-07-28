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

//为行为注册uri
+ (void)registerURI:(NSString *)URI action:(JDRouterAction)action;
+ (void)registerURI:(NSString *)URI objectAction:(JDRouterObjectAction)action;
//取消注册
+ (void)unRegisterURI:(NSString *)URI;

+ (void)openURI:(NSString *)URI;
//根据UI调用相应行为，并回调
+ (void)openURI:(NSString *)URI
     completion:(void (^)(id result))completion;

+ (void)openURI:(NSString *)URI
   userInfo:(NSDictionary *)userInfo
     completion:(void (^)(id result))completion;


//判断是否能打开
+ (BOOL)canOpenURI:(NSString *)URI;

//直接取
+ (id)objectForURI:(NSString *)URI;
+ (id)objectForURI:(NSString *)URI userInfo:(NSDictionary *)userInfo;

@end
