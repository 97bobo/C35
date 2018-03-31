//
//  GameListViewController.m
//  C35
//
//  Created by TimeMachine on 2018/3/29.
//  Copyright © 2018年 TimeMachine. All rights reserved.
//

#import "GameListViewController.h"
#import "GamingViewController.h"
#import "MyButton.h"

#define screenSize [UIScreen mainScreen].bounds.size

@interface GameListViewController ()
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;

@end

@implementation GameListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createGameButton:16 superView:self.leftView];
    [self createGameButton:16 superView:self.rightView];
    NSLog(@"%@",self.leftView);
}

-(void)createGameButton:(NSInteger)index superView:(UIView *)superView
{
    for (int i=0; i<index; i++) {
        MyButton *btn = [MyButton buttonWithType:UIButtonTypeCustom];
        CGFloat width = (screenSize.width-30*2-15*3)*0.25;
        CGFloat height = width;
        btn.frame = CGRectMake(30+(15+width)*(i%4), 60+(15+height)*(i/4), width, height);
        btn.backgroundColor = [UIColor redColor];
        btn.layer.cornerRadius = 5;
        [btn setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(playGame:) forControlEvents:UIControlEventTouchUpInside withSoundType:SoundTypeNormal];
        [superView addSubview:btn];
    }
}

-(void)playGame:(MyButton *)sender
{
    NSLog(@"我被点击了...");
    
    [self performSegueWithIdentifier:@"playGame" sender:nil];
}

@end
