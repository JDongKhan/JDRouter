//
//  JDIntentViewController.m
//  JDRouter
//
//  Created by 王金东 on 2017/7/31.
//  Copyright © 2017年 王金东. All rights reserved.
//

#import "JDIntentViewController.h"
#import "JDIntent.h"

@interface JDIntentViewController ()

@end

@implementation JDIntentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)intentAction:(id)sender {
    [JDIntent openUrl:@"Bababus://user/gotoNext" from:self completion:^(id info) {
        NSLog(@"%@",info);
    }];
}

- (IBAction)intent1Action:(id)sender {
    [JDIntent openUrl:@"Bababus://dept/gotoNext" from:self completion:^(id info) {
        NSLog(@"%@",info);
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
