
注：本项目只是一个介绍有关组件解耦以及router思路的项目，很多细节没有完善。


# 一、Protocol实现，模仿spring的机制。

本方案特色是模拟java的注解方案。

我们可以通过@JDService注册服务，用@JDRouter用注册路由。

比如：

一、service

  1、定义协议比如JDUserProtocol
  
  2、定义类实现JDUserProtocol比如JDUserService，在.m里面加入@JDService(JDUserProtocol,JDUserService)
      进行注册
      
  3、通过JDServiceCenter中取得实例进行调用。
  
      id<JDUserProtocol> user = [JDServiceCenter serviceForProtocol:@protocol(JDUserProtocol)];
    NSString *userName = user.userName;
    
    
二、router：

1、@JDRouter("bb://user/name",JDUserService) 放到类中，

2、让类实现handleWithLink:parameters:routerFrom:即可。

3、使用者就可以通过openURL来跳转了。

本方案存在部分约定。

注：不需要在做任何配置！不需要在做任何配置！不需要在做任何配置！可以达到解耦效果，谁开发谁配置。


# 二、JDIntent  从URL来分析用NSInvocation来跳转，就不用动态注册了


```c

[JDIntent openUrl:@"Bababus://user/gotoNext" completion:^(id info) {
NSLog(@"%@",info);
}];
```

通过约定将执行到UserIntent类里面的 action:gotoNext:completion:方法里


本方案约定大于设计。
