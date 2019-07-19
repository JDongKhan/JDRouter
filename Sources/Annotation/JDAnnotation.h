

/**
 
 Protocol只是个demo，代码源至 https://github.com/alibaba/BeeHive
 BeeHive对喜欢java的Annotation来是相当不错的，其功能也比较丰富
 
 除了不喜欢BeeHive的编码风格及命名外.....
 
 */


#import <Foundation/Foundation.h>

#ifndef JDServiceSectionName
#define JDServiceSectionName "JDServices"
#endif

#ifndef JDRouterSectionName
#define JDRouterSectionName "JDRouter"
#endif


#define JDDATA(sectname) __attribute((used, section("__DATA,"#sectname" ")))

#define JDService(servicename,impl) \
class JDServiceCenter;char * k##servicename##_service JDDATA(JDServices) = "{ \""#servicename"\" : \""#impl"\"}";

#define JDRouter(uri,className) \
class JDServiceCenter; char * k##className##_service JDDATA(JDRouter) = "{ "#uri" : \""#className"\"}";

@interface JDAnnotation : NSObject

@end
