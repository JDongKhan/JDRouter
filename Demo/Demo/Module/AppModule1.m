//
//  AppModule1.m
//  JDRouter
//
//  Created by JD on 2019/7/22.
//  Copyright © 2019 王金东. All rights reserved.
//

#import "AppModule1.h"
#import "JDAnnotation.h"

@JDModule(AppModule1)

@implementation AppModule1

/**
 优先级
 */
- (NSInteger)applicationPriority {
    return 1;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@" module 1 : willFinishLaunchingWithOptions");
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@" module 1 : applicationDidEnterBackground");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@" module 1 : applicationWillEnterForeground");
}

@end
