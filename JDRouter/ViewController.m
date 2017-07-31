//
//  ViewController.m
//  JDCore
//
//  Created by 王金东 on 2016/1/25.
//  Copyright © 2016年 王金东. All rights reserved.
//

#import "ViewController.h"
#import "JDRouter+viewController.h"

#import "JDIntent.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [JDRouter registerUrl:@"user://user/:name" action:^(NSDictionary *parameters) {
        NSLog(@"处理数据11%@",parameters);
        void(^block)(id) = parameters[JDRouterCompletion];
        if(block)block(@"哈哈");
    }];
    [JDRouter registerUrl:@"user://user/login.htm" action:^(NSDictionary *parameters) {
        NSLog(@"处理数据21%@",parameters);
        void(^block)(id) = parameters[JDRouterCompletion];
        if(block)block(@"哈哈");
    }];
    
    
      
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)btnAction:(id)sender {
    [JDRouter openUrl:@"user://user/:name" userInfo:@{@"name":@"wjd"} completion:^(id result) {
        NSLog(@"返回数据1%@",result);
    }];
}
- (IBAction)btn2Action:(id)sender {
    [JDRouter openUrl:@"user://user/wjd" completion:^(id result) {
        NSLog(@"返回数据2%@",result);
    }];
}
- (IBAction)btn3Action:(id)sender {
    [JDRouter openUrl:@"user://user/wjd?id=100&uuid=88787" completion:^(id result) {
        NSLog(@"返回数据3%@",result);
    }];
}
- (IBAction)loginAction:(id)sender {
    [JDRouter openUrl:@"user://user/login.htm?id=100&uuid=88787" completion:^(id result) {
        NSLog(@"返回数据4%@",result);
    }];
}
- (IBAction)gotoNextAction:(id)sender {
    
    [JDRouter openUrl:@"order://order?name=wjd" fromVc:self completion:^(id result) {
        NSLog(@"返回数据5%@",result);
    }];
}

- (void)dealloc {
    NSLog(@"dealloc");
}
- (IBAction)intentAction:(id)sender {
    [JDIntent openUrl:@"Bababus://user/gotoNext" from:self completion:^(id info) {
        NSLog(@"%@",info);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
