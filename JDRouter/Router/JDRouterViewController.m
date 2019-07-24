//
//  JDRouterViewController.m
//  JDRouter
//
//  Created by 王金东 on 2017/7/31.
//  Copyright © 2017年 王金东. All rights reserved.
//

#import "JDRouterViewController.h"
#import "JDRouterCenter.h"

@interface JDRouterViewController ()

@end

@implementation JDRouterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)btnAction:(id)sender {
    
}
- (IBAction)btn2Action:(id)sender {
    
}
- (IBAction)btn3Action:(id)sender {
    
}
- (IBAction)loginAction:(id)sender {
    
}
- (IBAction)gotoNextAction:(id)sender {
}


- (IBAction)gotospringRouter:(id)sender {
    [JDRouterCenter openURL:@"bb://user/name" parameters:@{@"key":@"value"} routerFrom:self completion:^(void) {
        NSLog(@"completion");
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
