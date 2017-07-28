//
//  UserIntent.h
//  JDRouter
//
//  Created by 王金东 on 2017/7/28.
//  Copyright © 2017年 王金东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JDIntent.h"

@interface UserIntent : NSObject

- (id)from:(id)sender message:(NSString *)message;

- (id)from:(id)sender gotoNext:(NSString *)message;

- (id)from:(id)sender gotoNext:(NSString *)message completion:(JDIntentCompletion)completion;

@end
