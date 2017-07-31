//
//  JDRouter+viewController.h
//  Pods
//
//  Created by 王金东 on 2016/8/27.
//
//

#import "JDRouter.h"
#import <UIKit/UIKit.h>


/**
 专门为viewController设置的
 **/


@interface JDRouter (viewController)


+ (void)registerUrl:(NSString *)Url
            action:(JDRouterAction)action
              toVc:(UIViewController *(^)())toVcClazz;




+ (void)openUrl:(NSString *)Url
         fromVc:(UIViewController *)fromVc;


+ (void)openUrl:(NSString *)Url
         fromVc:(UIViewController *)fromVc
     completion:(void (^)(id result))completion;

+ (void)openUrl:(NSString *)Url
         fromVc:(UIViewController *)fromVc
       userInfo:(NSDictionary *)userInfo
     completion:(void (^)(id result))completion;


@end
