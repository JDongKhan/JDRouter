//
//  JDModuleCenter.h
//  JDRouter
//
//  Created by JD on 2019/7/22.
//

#import <Foundation/Foundation.h>
#import "JDApplicationDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface JDModuleCenter : NSObject

+ (void)registerModuleClass:(Class)moduleClass;

+ (NSArray<id<JDApplicationDelegate>> *)allModules;


@end

NS_ASSUME_NONNULL_END
