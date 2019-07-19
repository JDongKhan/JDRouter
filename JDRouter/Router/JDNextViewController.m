//
//  JDNextViewController.m
//  JDCore
//
//  Created by 王金东 on 2016/1/27.
//  Copyright © 2017年 王金东. All rights reserved.
//

#import "JDNextViewController.h"

@interface JDNextViewController ()

@end

@implementation JDNextViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    NSLog(@"收到你的参数了%@",self.name);
    // Do any additional setup after loading the view.
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
