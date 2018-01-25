# 一、JDRouter & Intent

谈及组件之间交互
个人比较推崇用URI和配置文件来解决，因为更灵活，
比如可以根据URI跳转到浏览器！
比如配置文件可以放在服务器端，自由定制app的跳转逻辑、界面等！

很久以前根据MGJRouter修改、完善的方案，最近时间清闲下来就上传上来  

## cocoapods

  pod 'JDRouter'

修改如下：

 1）、修改extractParametersFromURL方法

  因为下面的代码在处理类似user://user/:name和user://user/login.htm的时候，
  当open的是user://user/login.htm，就永远找不到
  
  下面方法应该算核心的了吧，其他代码也没啥东西了
  
  ```c
          for (NSString* key in subRoutesKeys) {
            if ([key isEqualToString:pathComponent] || [key isEqualToString:MGJ_ROUTER_WILDCARD_CHARACTER]) {
                found = YES;
                subRoutes = subRoutes[key];
                break;
            } else if ([key hasPrefix:@":"]) {
                found = YES;
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
                break;
            }
        }

  ```
  修改为
  
  ```c
  
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
        
  ```
  
  2）、增加线程队列、锁

 pthread_mutex_t mutex;
 dispatch_queue_t _queue;
 
 3）、增加为viewController服务的类别, 毕竟我们还是打开vc的比较多

JDRouter+viewController

4）、去掉userInfo，使其参数统一一层，便于各种情况统一调用

5）、修改canOpenURI的实现
因为作者的怎么都能打开，其实这个方法意义不大,根据提供方提供的action是否存在来判断感觉好点

最后、去掉一些自己不用的代码&修改其编码风格、命名等！个人喜好

# 二、JDIntent从URL来分析用NSInvocation来跳转，就不用动态注册了，也是从某位那借鉴来的


```c

 [JDIntent openUrl:@"Bababus://user/gotoNext" completion:^(id info) {
        NSLog(@"%@",info);
    }];
```

或执行到UserIntent类里面的 action:gotoNext:completion:方法里



# 三、Protocol实现，模仿spring的机制。
  1、定义协议比如JDUserProtocol
  2、定义类实现JDUserProtocol比如JDUserService，在.m里面加入@JD_Service(JDUserProtocol,JDUserService)
      进行注册
  3、通过JDServiceCenter中取得实例进行调用。
      id<JDUserProtocol> user = [JDServiceCenter serviceForProtocol:@protocol(JDUserProtocol)];
    NSString *userName = user.userName;


