//
//  AppModule2.m
//  JDRouter
//
//  Created by JD on 2019/7/22.
//  Copyright © 2019 王金东. All rights reserved.
//

#import "AppModule2.h"
#import "JDAnnotation.h"

@JDModule(AppModule2)

@implementation AppModule2

/**
 优先级
 */
- (NSInteger)applicationPriority {
    return 2;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@" module 2 : willFinishLaunchingWithOptions");
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@" module 2 : applicationDidEnterBackground");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@" module 2 : applicationWillEnterForeground");
}

@end
