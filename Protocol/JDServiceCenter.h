//
//  JDServiceCenter.h
//  JDRouter
//
//  Created by 王金东 on 2017/7/31.
//  Copyright © 2017年 王金东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDServiceCenter : NSObject

+ (void)registerService:(id)service protocol:(Protocol*)protocol;

+ (id)serviceForProtocol:(Protocol *)protocol;


@end
