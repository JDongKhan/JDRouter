//
//  JDRouterCenter.m
//  JDRouter
//
//  Created by JD on 2019/7/19.
//  Copyright © 2019 王金东. All rights reserved.
//

#import "JDRouterCenter.h"
#import <UIKit/UIKit.h>

@implementation JDRouterCenter {
    NSMutableDictionary<NSString *,NSString *> *_routersMap;
}

- (instancetype)init {
    if (self = [super init]) {
        _routersMap = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)registerURL:(NSString *)URL className:(NSString *)className {
    [_routersMap setValue:className forKey:URL];
}

- (id)openUrl:(NSString *)Url
     parameters:(NSDictionary<NSString *, id> * _Nullable)parameters
     routerFrom:(id _Nullable)from
     completion:(void(^_Nullable)(void))completion {
    NSString *className = [_routersMap valueForKey:Url];
    Class clazz = NSClassFromString(className);
    UIViewController *viewController = nil;
    if (clazz) {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        SEL sel = @selector(handleWithLink:parameters:routerFrom:);
#pragma clang diagnostic pop
        
        if ([clazz respondsToSelector:sel]) {
            IMP imp = [clazz methodForSelector:sel];
            //定义函数指针，消除告警
            id (*func)(id, SEL, NSString *, NSDictionary *, id) = (void *)imp;
            viewController = func(clazz, sel, Url,parameters,from);
        }
    }
    if (viewController == nil) {
        return nil;
    }
    
    //显示页面
    [self showViewController:viewController completion:completion];
    
    return viewController;
}

+ (instancetype)sharedInstance {
    static JDRouterCenter *routerCenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        routerCenter = [[JDRouterCenter alloc] init];
    });
    return routerCenter;
}


+ (void)registerURL:(NSString *)URL className:(NSString *)className {
    [[JDRouterCenter sharedInstance] registerURL:URL className:className];
}

+ (id)openURL:(NSString *)URL {
    return [[JDRouterCenter sharedInstance] openUrl:URL parameters:nil routerFrom:nil completion:nil];
}

+ (id)openURL:(NSString *)URL
     parameters:(NSDictionary<NSString *, id> * _Nullable)parameters
     routerFrom:(id _Nullable)from
     completion:(void(^_Nullable)(void))completion {
    return [[JDRouterCenter sharedInstance] openUrl:URL parameters:parameters routerFrom:from completion:completion];
}



- (void)showViewController:(UIViewController *)viewController completion:(void (^)(void))completion {
    
//    __strong void (^completionBlock)(void) = [completion copy];
    
    UIViewController *rootViewController = UIApplication.sharedApplication.delegate.window.rootViewController;
    if (rootViewController == nil) {
        return;
    }
    
    UINavigationController *navigationController = nil;
    if ([rootViewController isKindOfClass:UINavigationController.class]) {
        //主页面加载之前，直接用NavigationController push
        navigationController = (UINavigationController *)rootViewController;
    } else if ([rootViewController isKindOfClass:UITabBarController.class]) {
        //主页面加载之后，找到当前选中的NavigationController push
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        if (tabBarController.selectedViewController && [tabBarController.selectedViewController isKindOfClass:UINavigationController.class]) {
            navigationController = (UINavigationController *)tabBarController.selectedViewController;
        }
    }
    //判断是否有模态弹出框
    UIViewController *topViewController = navigationController.topViewController;
    UIViewController *presentedViewController = navigationController.presentedViewController;
    if (presentedViewController == nil) {
        presentedViewController = topViewController.presentedViewController;
    }
    if (presentedViewController != nil) {
        while (presentedViewController.presentedViewController && !presentedViewController.presentedViewController.isBeingDismissed) {
            presentedViewController = presentedViewController.presentedViewController;
        }
        if (!presentedViewController.isBeingDismissed && [presentedViewController isKindOfClass:UINavigationController.class]) {
            navigationController = (UINavigationController *)presentedViewController;
        }
    }
    if (navigationController.viewControllers.count == 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [navigationController pushViewController:viewController animated:YES];
    
    //TODO
    //此处需要跳转完成在调用completion
}

@end
