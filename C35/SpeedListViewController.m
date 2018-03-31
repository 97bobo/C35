//
//  SpeedListViewController.m
//  C35
//
//  Created by TimeMachine on 2018/3/29.
//  Copyright © 2018年 TimeMachine. All rights reserved.
//

#import "SpeedListViewController.h"

@interface SpeedListViewController ()

@end

@implementation SpeedListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(100, 100, 0, 0)];
    [self.view addSubview:sw];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
