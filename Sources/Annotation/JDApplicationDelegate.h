//
//  JDApplicationDelegate.h
//  JDRouter
//
//  Created by JD on 2019/7/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JDApplicationDelegate <NSObject>

@optional

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (void)applicationDidBecomeActive:(UIApplication *)application;

- (void)applicationWillResignActive:(UIApplication *)application;

- (void)applicationDidEnterBackground:(UIApplication *)application;

- (void)applicationWillEnterForeground:(UIApplication *)application;

// try to clean up as much memory as possible. next step is to terminate app
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application;

- (void)applicationWillTerminate:(UIApplication *)application;

/**
 优先级
 */
- (NSInteger)applicationPriority;

@end

NS_ASSUME_NONNULL_END
