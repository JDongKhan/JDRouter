//
//  ViewController.m
//  JDCore
//
//  Created by 王金东 on 2016/1/25.
//  Copyright © 2016年 王金东. All rights reserved.
//

#import "ViewController.h"
#import "JDRouterViewController.h"
#import "JDIntentViewController.h"
#import "JDProtocolViewController.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *itemArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    __weak typeof (self) _weakSelf = self;
    self.itemArray = @[
                       @{
                           @"title" : @"Router",
                           @"select" : ^(){
                               [_weakSelf.navigationController pushViewController:[[JDRouterViewController alloc] init] animated:YES];
                           }
                           },
                       @{
                           @"title" : @"Intent",
                           @"select" : ^(){
                               [_weakSelf.navigationController pushViewController:[[JDIntentViewController alloc] init] animated:YES];
                           }
                           },
                       @{
                           @"title" : @"Protocol",
                           @"select" : ^(){
                               [_weakSelf.navigationController pushViewController:[[JDProtocolViewController alloc] init] animated:YES];
                           }
                           }
                       ];
      
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)dealloc {
    NSLog(@"dealloc");
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.textLabel.text = self.itemArray[indexPath.row][@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    void(^block)(void) = self.itemArray[indexPath.row][@"select"];
    if (block) {
        block();
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
