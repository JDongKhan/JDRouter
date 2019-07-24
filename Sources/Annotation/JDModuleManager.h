//
//  JDModuleManager.h
//  JDRouter
//
//  Created by JD on 2019/7/22.
//

/*
    目前只支持启动、内存警告、app终止、前后台等相关的操作，其他的建议放到主程序中。
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDModuleManager : NSObject

+ (instancetype)sharedInstance;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

@end

NS_ASSUME_NONNULL_END
