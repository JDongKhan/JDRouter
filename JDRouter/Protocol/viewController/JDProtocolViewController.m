//
//  JDProtocolViewController.m
//  JDRouter
//
//  Created by 王金东 on 2017/7/31.
//  Copyright © 2017年 王金东. All rights reserved.
//

#import "JDProtocolViewController.h"
#import "JDUserProtocol.h"
#import "JDServiceCenter.h"

@interface JDProtocolViewController ()

@end

@implementation JDProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    id<JDUserProtocol> user = [JDServiceCenter serviceForProtocol:@protocol(JDUserProtocol)];
    NSString *userName = user.userName;
    NSLog(@"%@",userName);
    // Do any additional setup after loading the view from its nib.
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
