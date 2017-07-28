//
//  JDRouter.m
//  Pods
//
//  Created by 王金东 on 2016/1/27.
//
//

#import "JDRouter.h"
#import <pthread.h>

#define JDROUTER_ADDURL(URI,action) {\
NSMutableDictionary *routes = [self addURI:URI];\
if (action && routes) {\
    routes[@"_"] = [action copy];\
}\
}
//改成* 因为浏览器可以支持* 并不支持~
static NSString *const JD_ROUTER_WILDCARD_CHARACTER = @"*";

static NSString *specialCharacters = @"/?&.";

NSString *const JDRouterURI = @"JDRouterURI";
NSString *const JDRouterBlock = @"JDRouterBlock";
NSString *const JDRouterCompletion = @"JDRouterCompletion";


@interface JDRouter ()
@property (nonatomic) NSMutableDictionary *routes;
@end

@implementation JDRouter{
    pthread_mutex_t mutex;
    dispatch_queue_t _queue;
}

+ (instancetype)sharedInstance {
    static JDRouter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
- (instancetype)init {
    self = [super init];
    if (self) {
         pthread_mutex_init(&mutex, NULL);
        _queue = dispatch_queue_create("com.jd.cache.memory", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}
- (void)dealloc{
    pthread_mutex_destroy(&mutex);  //释放该锁的数据结构 可惜永远不会释放
}

#pragma mark ------------------------register-----------------------
+ (void)registerURI:(NSString *)URI action:(JDRouterAction)action {
     [[self sharedInstance] registerURI:URI action:action];
}
+ (void)registerURI:(NSString *)URI objectAction:(JDRouterObjectAction)action {
    [[self sharedInstance] registerURI:URI objectAction:action];
}
- (void)registerURI:(NSString *)URI action:(JDRouterAction)action {
    dispatch_async(_queue, ^{
        JDROUTER_ADDURL(URI,action);
    });
}
- (void)registerURI:(NSString *)URI objectAction:(JDRouterObjectAction)action {
    dispatch_async(_queue, ^{
        JDROUTER_ADDURL(URI,action);
    });
}

- (NSMutableDictionary *)addURI:(NSString *)URI {
    NSArray *pathComponents = [self pathComponentsFromURI:URI];
    NSMutableDictionary *subRoutes = self.routes;
    pthread_mutex_lock(&mutex);
    for (NSString *pathComponent in pathComponents) {
        if (![subRoutes objectForKey:pathComponent]) {
            subRoutes[pathComponent] = [[NSMutableDictionary alloc] init];
        }
        subRoutes = subRoutes[pathComponent];
    }
    pthread_mutex_unlock(&mutex);
    return subRoutes;
}
- (NSArray *)pathComponentsFromURI:(NSString*)URI {
    NSMutableArray *pathComponents = [NSMutableArray array];
    if ([URI rangeOfString:@"://"].location != NSNotFound) {
        NSArray *pathSegments = [URI componentsSeparatedByString:@"://"];
        [pathComponents addObject:pathSegments[0]];
        URI = pathSegments.lastObject;
        if (!URI.length) {
            [pathComponents addObject:JD_ROUTER_WILDCARD_CHARACTER];
        }
    }
    for (NSString *pathComponent in [[NSURL URLWithString:URI] pathComponents]) {
        if ([pathComponent isEqualToString:@"/"]) continue;
        if ([[pathComponent substringToIndex:1] isEqualToString:@"?"]) break;
        [pathComponents addObject:pathComponent];
    }
    return [pathComponents copy];
}

#pragma mark ------------------------unRegister-----------------------
+ (void)unRegisterURI:(NSString *)URI {
     [[self sharedInstance] unRegisterURI:URI];
}
- (void)unRegisterURI:(NSString *)URI {
    NSMutableArray *pathComponents = [NSMutableArray arrayWithArray:[self pathComponentsFromURI:URI]];
    // 只删除该 pattern 的最后一级
    if (pathComponents.count >= 1) {
        // 假如 URLPattern 为 a/b/c, components 就是 @"a.b.c" 正好可以作为 KVC 的 key
        NSString *components = [pathComponents componentsJoinedByString:@"."];
        pthread_mutex_lock(&mutex);
        NSMutableDictionary *route = [self.routes valueForKeyPath:components];
        if (route.count >= 1) {
            NSString *lastComponent = [pathComponents lastObject];
            [pathComponents removeLastObject];
            // 有可能是根 key，这样就是 self.routes 了
            route = self.routes;
            if (pathComponents.count) {
                NSString *componentsWithoutLast = [pathComponents componentsJoinedByString:@"."];
                route = [self.routes valueForKeyPath:componentsWithoutLast];
            }
            [route removeObjectForKey:lastComponent];
        }
        pthread_mutex_unlock(&mutex);
    }
}


#pragma mark ----------------------open-------------------
+ (void)openURI:(NSString *)URI {
    [self openURI:URI completion:nil];
}
+ (void)openURI:(NSString *)URI completion:(void (^)(id result))completion {
    [self openURI:URI userInfo:nil completion:completion];
}
+ (void)openURI:(NSString *)URI
   userInfo:(NSDictionary *)userInfo
     completion:(void (^)(id result))completion {
    URI = [URI stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *parameters = [[self sharedInstance] extractParametersFromURL:URI];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, NSString *obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            parameters[key] = [obj stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }];
    if (parameters) {
        JDRouterAction action = parameters[JDRouterBlock];
        if (completion) {
            parameters[JDRouterCompletion] = completion;
        }
        if(userInfo) {
            [parameters addEntriesFromDictionary:userInfo];
        }
        if(action) {
            [parameters removeObjectForKey:JDRouterBlock];
            action(parameters);
        }
    }
}

#pragma mark - Utils

- (NSMutableDictionary *)extractParametersFromURL:(NSString *)URI {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[JDRouterURI] = URI;
    NSMutableDictionary *subRoutes = self.routes;
    NSArray *pathComponents = [self pathComponentsFromURI:URI];
    BOOL found = NO;
    for (NSString *pathComponent in pathComponents) {
        // 对 key 进行排序，这样可以把 ~ 放到最后
        NSArray *subRoutesKeys =[subRoutes.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            return [obj1 compare:obj2];
        }];
        //寻找数据要有个先后顺序的标注
        //先已pathComponent为准
        //再去找~通配的
        //最后再去分析是不是:参数
        if([subRoutesKeys containsObject:pathComponent]){
            found = YES;
            subRoutes = subRoutes[pathComponent];
        }else if([subRoutesKeys containsObject:JD_ROUTER_WILDCARD_CHARACTER]){
            found = YES;
            subRoutes = subRoutes[JD_ROUTER_WILDCARD_CHARACTER];
        }else {
            NSPredicate *p = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH ':'"];//以:打头的p
            NSArray *sbs = [subRoutesKeys filteredArrayUsingPredicate:p];
            if(sbs != nil){
                found = YES;
                NSString *key = sbs.firstObject;
                subRoutes = subRoutes[key];
                NSString *newKey = [key substringFromIndex:1];
                NSString *newPathComponent = pathComponent;
                // 再做一下特殊处理，比如 :id.html -> :id
                if ([self.class checkIfContainsSpecialCharacter:key]) {
                    NSCharacterSet *specialCharacterSet = [NSCharacterSet characterSetWithCharactersInString:specialCharacters];
                    NSRange range = [key rangeOfCharacterFromSet:specialCharacterSet];
                    if (range.location != NSNotFound) {
                        // 把 pathComponent 后面的部分也去掉
                        newKey = [newKey substringToIndex:range.location - 1];
                        NSString *suffixToStrip = [key substringFromIndex:range.location];
                        newPathComponent = [newPathComponent stringByReplacingOccurrencesOfString:suffixToStrip withString:@""];
                    }
                }
                parameters[newKey] = newPathComponent;
            }
        }
        // 如果没有找到该 pathComponent 对应的 Action，则以上一层的 Action 作为 fallback
        if (!found && !subRoutes[@"_"]) {
            return nil;
        }
    }
    
    // Extract Params From Query.
    NSArray<NSURLQueryItem *> *queryItems = [[NSURLComponents alloc] initWithURL:[[NSURL alloc] initWithString:URI] resolvingAgainstBaseURL:false].queryItems;
    
    for (NSURLQueryItem *item in queryItems) {
        parameters[item.name] = item.value;
    }
    
    if (subRoutes[@"_"]) {
        parameters[JDRouterBlock] = [subRoutes[@"_"] copy];
    }
    return parameters;
}


+ (BOOL)canOpenURI:(NSString *)URI {
    NSDictionary *p = [[self sharedInstance] extractParametersFromURL:URI];
    return p[JDRouterBlock] ? YES : NO;
}

#pragma mark - Utils

+ (BOOL)checkIfContainsSpecialCharacter:(NSString *)checkedString {
    NSCharacterSet *specialCharactersSet = [NSCharacterSet characterSetWithCharactersInString:specialCharacters];
    return [checkedString rangeOfCharacterFromSet:specialCharactersSet].location != NSNotFound;
}


#pragma mark-----------------------------------------

+ (id)objectForURI:(NSString *)URI {
    return [self objectForURI:URI userInfo:nil];
}
+ (id)objectForURI:(NSString *)URI userInfo:(NSDictionary *)userInfo {
    JDRouter *router = [JDRouter sharedInstance];
    URI = [URI stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *parameters = [router extractParametersFromURL:URI];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, NSString *obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            parameters[key] = [obj stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }];
    JDRouterObjectAction action = parameters[JDRouterBlock];
    if (action) {
        if (userInfo) {
            [parameters addEntriesFromDictionary:userInfo];
        }
        [parameters removeObjectForKey:JDRouterBlock];
        return action(parameters.copy);
    }
    return nil;
}


- (NSMutableDictionary *)routes {
    if (!_routes) {
        _routes = [[NSMutableDictionary alloc] init];
    }
    return _routes;
}



@end
