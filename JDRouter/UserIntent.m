//
//  UserIntent.m
//  JDRouter
//
//  Created by 王金东 on 2017/7/28.
//  Copyright © 2017年 王金东. All rights reserved.
//

#import "UserIntent.h"
#import "JDNextViewController.h"

@implementation UserIntent


- (id)from:(id)sender message:(NSString *)message {

    NSLog(@"%@",message);
    return nil;
}

- (id)from:(id)sender gotoNext:(NSString *)message {
    JDNextViewController *v = [[JDNextViewController alloc] init];
    UIViewController *vc = sender;
    [vc.navigationController pushViewController:v animated:YES];
    return v;
}

- (id)from:(id)sender gotoNext:(NSString *)message  completion:(JDIntentCompletion)completion {
    JDNextViewController *v = [[JDNextViewController alloc] init];
    UIViewController *vc = sender;
    [vc.navigationController pushViewController:v animated:YES];
    if(completion)completion(nil);
    return v;
}

- (id)from:(id)sender notFound:(id)obj {
    return nil;
}


@end
