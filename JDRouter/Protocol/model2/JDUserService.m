//
//  JDUserService.m
//  JDRouter
//
//  Created by 王金东 on 2017/7/31.
//  Copyright © 2017年 王金东. All rights reserved.
//

#import "JDUserService.h"
#import "JDAnnotation.h"
#import "JDNextViewController.h"


@JDService(JDUserProtocol,JDUserService)
@JDRouter("bb://user/name",JDUserService)

@implementation JDUserService


+ (id)handleWithLink:(NSString *)url parameters:(NSDictionary *)parameters routerFrom:(id)from {
    JDNextViewController *vc = [[JDNextViewController alloc] init];
    vc.name = url;
    return vc;
}

- (NSString *)userName { 
    return @"wjd";
}


@end
