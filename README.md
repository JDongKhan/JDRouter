
注：本项目只是一个介绍有关组件解耦以及router思路的项目，很多细节没有完善。


## 一、Annotation实现，模仿spring的机制。

本方案特色是模拟java的注解方案。

我们可以通过@JDModule注册模块，通过@JDService注册服务，用@JDRouter注册路由。

使用方式：

##### 一、module

1、模块内定义一个实现了JDApplicationDelegate协议的类并实现该协议方法

2、在实现类的.m里面增加

```objc
# import <JDRouter/JDAnnotation.h>

@JDModule(className)
```

3、在AppDelegate里面的-application:didFinishLaunchingWithOptions:方法增加

```objc
return [[JDModuleManager sharedInstance] application:application  didFinishLaunchingWithOptions:launchOptions];
```

可查看  https://github.com/JDongKhan/JDComponentBased.git  使用细则



##### 二、service

1、定义协议：JDUserProtocol，并定义实现类 如JDUserService。

2、在.m里面加入下面代码进行注册

```objc
# import <JDRouter/JDAnnotation.h>

@JDService(JDUserProtocol,JDUserService) 
```

3、通过JDServiceCenter中取得实例进行调用。

  ```objc
id<JDUserProtocol> user = [JDServiceCenter serviceForProtocol:@protocol(JDUserProtocol)];
      
NSString *userName = user.userName;
  ```



##### 三、router：

1、定义路由类，如JDNextViewController。

2、在JDNextViewController中增加以下代码

```objective-c
# import <JDRouter/JDAnnotation.h>

@JDRouter("bb://user/name",JDNextViewController)
```

3、让类实现handleWithLink:parameters:routerFrom:即可。

2、让类实现handleWithLink:parameters:routerFrom:即可。

4、使用者就可以通过openURL来跳转了。

如下

```objc
[JDRouterCenter openURL:@"bb://user/name" parameters:@{@"key":@"value"} routerFrom:self completion:^(void) {
        NSLog(@"completion");
    }];
```



本方案存在部分约定。

注：不需要在做任何配置！不需要在做任何配置！不需要在做任何配置！可以达到解耦效果，谁开发谁配置。



## 二、JDIntent 

从URL来分析，用NSInvocation来跳转，就不用动态注册了


```c

[JDIntent openUrl:@"bb://user/gotoNext" completion:^(id info) {
NSLog(@"%@",info);
}];
```

通过约定将执行到UserIntent类里面的 action:gotoNext:completion:方法里


本方案约定大于设计。
