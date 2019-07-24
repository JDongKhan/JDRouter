//
//  JDModuleCenter.m
//  JDRouter
//
//  Created by JD on 2019/7/22.
//

#import "JDModuleCenter.h"

@interface JDModuleCenter ()

@property(nonatomic, strong) NSMutableArray<id<JDApplicationDelegate>> *modules;

@end

@implementation JDModuleCenter

- (instancetype)init {
    if (self = [super init]) {
        _modules = [NSMutableArray array];
    }
    return self;
}

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[JDModuleCenter alloc] init];
    });
    return sharedInstance;
}


+ (void)registerModuleClass:(Class)moduleClass {
    if ([moduleClass conformsToProtocol:@protocol(JDApplicationDelegate)]) {
        id<JDApplicationDelegate> module = [[moduleClass alloc] init];
        [JDModuleCenter registerModule:module];
    }
}

+ (void)registerModule:(id<JDApplicationDelegate>)module {
    [[JDModuleCenter sharedInstance].modules addObject:module];
}


+ (NSArray<id<JDApplicationDelegate>> *)allModules {
    NSArray *module =  [JDModuleCenter sharedInstance].modules;
    NSArray *newModules =  [module sortedArrayUsingComparator:^NSComparisonResult(id<JDApplicationDelegate>  _Nonnull module1, id<JDApplicationDelegate>  _Nonnull module2) {
        NSInteger module1Priority = module1.applicationPriority;
        NSInteger module2Priority = module2.applicationPriority;
        return module1Priority < module2Priority;
    }];
    return newModules;
}

@end
