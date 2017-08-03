

/**
 
 Protocol只是个demo，代码源至 https://github.com/alibaba/BeeHive
 BeeHive对喜欢java的Annotation来是相当不错的，其功能也比较丰富
 
 除了不喜欢BeeHive的编码风格及命名外.....
 
 */


#import <Foundation/Foundation.h>

#ifndef JDServiceSectionName
#define JDServiceSectionName "JDServices"
#endif


#define JD_DATA(sectname) __attribute((used, section("__DATA,"#sectname" ")))

#define JD_Service(servicename,impl) \
class JDServiceCenter;char * k##servicename##_service JD_DATA(JDServices) = "{ \""#servicename"\" : \""#impl"\"}";

@interface JDAnnotation : NSObject

@end
