//
//  RateHomeViewController.m
//  C35
//
//  Created by XQL on 2018/4/1.
//  Copyright © 2018年 TimeMachine. All rights reserved.
//

#import "RateHomeViewController.h"
#import "PalyingGameViewController.h"

@interface RateHomeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *bestScoreL;

@end

@implementation RateHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customNavigationView];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:bestTime]) {
        self.bestScoreL.text = [[NSUserDefaults standardUserDefaults] objectForKey:bestTime];
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // segue.identifier：获取连线的ID
    if ([segue.identifier isEqualToString:@"gamingVC"]) {
        // segue.destinationViewController：获取连线时所指的界面（VC）
        PalyingGameViewController *receive = segue.destinationViewController;
        receive.isNeedTimer = YES;
        // 这里不需要指定跳转了，因为在按扭的事件里已经有跳转的代码
        //        [self.navigationController pushViewController:receive animated:YES];
    }
}

-(void)back:(CustmerButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)customNavigationView
{
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 74)];
    navigationView.backgroundColor = [UIColor clearColor];
    
    CustmerButton *backB = [CustmerButton buttonWithType:UIButtonTypeCustom];
    backB.frame = CGRectMake(15, 30, 50, 40);
    [backB setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backB addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    [navigationView addSubview:backB];

    
    [self.view addSubview:navigationView];
}


@end
