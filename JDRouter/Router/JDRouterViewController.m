//
//  JDRouterViewController.m
//  JDRouter
//
//  Created by 王金东 on 2017/7/31.
//  Copyright © 2017年 王金东. All rights reserved.
//

#import "JDRouterViewController.h"
#import "JDRouter+viewController.h"

@interface JDRouterViewController ()

@end

@implementation JDRouterViewController

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
    
    
    // Do any additional setup after loading the view from its nib.
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
