//
//  ViewController.m
//  JDCore
//
//  Created by 王金东 on 2016/7/25.
//  Copyright © 2016年 王金东. All rights reserved.
//

#import "ViewController.h"
#import "JDRouter+viewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [JDRouter registerURI:@"user://user/:name" action:^(NSDictionary *parameters) {
        NSLog(@"处理数据11%@",parameters);
        void(^block)(id) = parameters[JDRouterCompletion];
        if(block)block(@"哈哈");
    }];
    [JDRouter registerURI:@"user://user/login.htm" action:^(NSDictionary *parameters) {
        NSLog(@"处理数据21%@",parameters);
        void(^block)(id) = parameters[JDRouterCompletion];
        if(block)block(@"哈哈");
    }];
    
    
      
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)btnAction:(id)sender {
    [JDRouter openURI:@"user://user/:name" userInfo:@{@"name":@"wjd"} completion:^(id result) {
        NSLog(@"返回数据1%@",result);
    }];
}
- (IBAction)btn2Action:(id)sender {
    [JDRouter openURI:@"user://user/wjd" completion:^(id result) {
        NSLog(@"返回数据2%@",result);
    }];
}
- (IBAction)btn3Action:(id)sender {
    [JDRouter openURI:@"user://user/wjd?id=100&uuid=88787" completion:^(id result) {
        NSLog(@"返回数据3%@",result);
    }];
}
- (IBAction)loginAction:(id)sender {
    [JDRouter openURI:@"user://user/login.htm?id=100&uuid=88787" completion:^(id result) {
        NSLog(@"返回数据4%@",result);
    }];
}
- (IBAction)gotoNextAction:(id)sender {
    
    [JDRouter openURI:@"order://order?name=wjd" fromVc:self completion:^(id result) {
        NSLog(@"返回数据5%@",result);
    }];
}

- (void)dealloc {
    NSLog(@"dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
