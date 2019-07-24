//
//  JDModuleManager.m
//  JDRouter
//
//  Created by JD on 2019/7/22.
//

#import "JDModuleManager.h"
#import "JDModuleCenter.h"

@implementation JDModuleManager

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[JDModuleManager alloc] init];
    });
    return sharedInstance;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self triggerApplicationFinishLaunchingEvent:application launchOptions:launchOptions];
    [self addNotification];
    return YES;
}

// 添加通知
- (void)addNotification {
    //进入后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    //进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    //回到活动状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    //失活状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    //内存警告
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    //app退出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
}

- (void)applicationWillResignActive:(NSNotification *)notification {
    [self triggerApplicationEvent:notification.object selector:_cmd];
}

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    [self triggerApplicationEvent:notification.object selector:_cmd];
}

- (void)applicationWillEnterForeground:(NSNotification *)notification {
    [self triggerApplicationEvent:notification.object selector:_cmd];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    [self triggerApplicationEvent:notification.object selector:_cmd];
}

- (void)applicationWillTerminate:(NSNotification *)notification{
    [self triggerApplicationEvent:notification.object selector:_cmd];
}

- (void)applicationDidReceiveMemoryWarning:(NSNotification *)notification {
    [self triggerApplicationEvent:notification.object selector:_cmd];
}

- (void)triggerApplicationEvent:(UIApplication *)application selector:(SEL)selector {
    NSArray *modules = [JDModuleCenter allModules];
    [modules enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [obj performSelector:selector withObject:application];
#pragma clang diagnostic pop
        }
    }];
}

- (void)triggerApplicationFinishLaunchingEvent:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions {
    NSArray<id<JDApplicationDelegate>> *modules = [JDModuleCenter allModules];
    SEL selector = @selector(application:didFinishLaunchingWithOptions:);
    [modules enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [obj application:application didFinishLaunchingWithOptions:launchOptions];
#pragma clang diagnostic pop
        }
    }];
}

@end
