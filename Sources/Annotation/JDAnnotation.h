

/**
 
 Protocol只是个demo，代码源至 https://github.com/alibaba/BeeHive
 BeeHive对喜欢java的Annotation来是相当不错的，其功能也比较丰富
 
 除了不喜欢BeeHive的编码风格及命名外.....
 
 */


#import <Foundation/Foundation.h>

#ifndef JDModuleSectionName
#define JDModuleSectionName "JDModule"
#endif

#ifndef JDServiceSectionName
#define JDServiceSectionName "JDServices"
#endif

#ifndef JDRouterSectionName
#define JDRouterSectionName "JDRouter"
#endif


//使用 used字段，即使没有任何引用，在Release下也不会被优化
#define JDDATA(sectname) __attribute((used, section("__DATA,"#sectname" ")))

//Service
#define JDService(servicename,impl) \
class JDAnnotation;char * k##servicename##_service JDDATA(JDServices) = "{ \""#servicename"\" : \""#impl"\"}";

//Router
#define JDRouter(uri,className) \
class JDAnnotation; char * k##className##_router JDDATA(JDRouter) = "{ "#uri" : \""#className"\"}";

//Module
#define JDModule(className) \
class JDAnnotation; char * k##className##_module JDDATA(JDModule) = ""#className"";


@interface JDAnnotation : NSObject

@end


@interface NSObject (JDRouter)

+ (id)handleWithLink:(NSString *)url parameters:(NSDictionary *)parameters routerFrom:(id)from;

@end
