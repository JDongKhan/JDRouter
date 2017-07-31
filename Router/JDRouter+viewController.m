//
//  JDRouter+viewController.m
//  Pods
//
//  Created by 王金东 on 2016/8/27.
//
//

#import "JDRouter+viewController.h"


#define JDRoter_NoWarningPerformSelector(target, action, object) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wundeclared-selector\"") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
if ([target respondsToSelector:action]) {\
[target performSelector:action withObject:object]; }\
_Pragma("clang diagnostic pop") \


NSString *const JDRouterFromViewController = @"JDRouterFromView";


@implementation JDRouter (viewController)

+ (void)registerUrl:(NSString *)Url
            action:(JDRouterAction)action
              toVc:(UIViewController *(^)())toVcClazz {
    [JDRouter registerUrl:Url action:^(NSDictionary *parameters) {
        NSMutableDictionary *p = parameters.mutableCopy;
        UIViewController *fromVC = p[JDRouterFromViewController];
        UIViewController *toVC = toVcClazz();
        [p removeObjectForKey:JDRouterFromViewController];
        NSDictionary *newP = [p copy];
        for (NSString *key in newP) {
            NSString *selectorName = [NSString stringWithFormat:@"set%@%@:",[[key substringToIndex:1] uppercaseString],[key substringFromIndex:1]];
            SEL selector = NSSelectorFromString(selectorName);
            JDRoter_NoWarningPerformSelector(toVC, selector, newP[key]);
        }
        [fromVC.navigationController pushViewController:toVC animated:YES];
        if (action) {
            action(newP);
        }
    }];
}



+ (void)openUrl:(NSString *)Url
         fromVc:(UIViewController *)fromVc{
    [self openUrl:Url fromVc:fromVc completion:nil];
}

+ (void)openUrl:(NSString *)Url
         fromVc:(UIViewController *)fromVc
     completion:(void (^)(id result))completion {
    [self openUrl:Url fromVc:fromVc userInfo:nil completion:completion];
}

+ (void)openUrl:(NSString *)Url
         fromVc:(UIViewController *)fromVc
       userInfo:(NSDictionary *)userInfo
     completion:(void (^)(id result))completion {
    NSMutableDictionary *p = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    if(fromVc){
        p[JDRouterFromViewController] = fromVc;
    }
    [JDRouter openUrl:Url userInfo:p completion:completion];
}
@end
