//
//  SpeedHomeViewController.m
//  C35
//
//  Created by XQL on 2018/4/1.
//  Copyright © 2018年 TimeMachine. All rights reserved.
//

#import "SpeedHomeViewController.h"
#import "GamingViewController.h"

@interface SpeedHomeViewController ()

@end

@implementation SpeedHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // segue.identifier：获取连线的ID
    if ([segue.identifier isEqualToString:@"gamingVC"]) {
        // segue.destinationViewController：获取连线时所指的界面（VC）
        GamingViewController *receive = segue.destinationViewController;
        receive.isNeedTimer = YES;
        // 这里不需要指定跳转了，因为在按扭的事件里已经有跳转的代码
        //        [self.navigationController pushViewController:receive animated:YES];
    }
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
