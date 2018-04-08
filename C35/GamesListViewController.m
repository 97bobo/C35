//
//  GamesListViewController.m
//  C35
//
//  Created by TimeMachine on 2018/3/29.
//  Copyright © 2018年 TimeMachine. All rights reserved.
//

#import "GamesListViewController.h"
#import "PalyingGameViewController.h"
#import "CustmerButton.h"

#define screenSize [UIScreen mainScreen].bounds.size

@interface GamesListViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation GamesListViewController
{
    NSInteger stage;
    UIPageControl *pageControl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.delegate = self;
    [self createeGameaButton:16 superView:self.leftView page:1];
    [self createeGameaButton:16 superView:self.rightView page:2];
//    NSLog(@"%@",self.leftView);
    [self customNavigationView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI:) name:CompletedGameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextQuestion:) name:NextGameNotification object:nil];
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.scrollView.xql_bottom+20, screenSize.width, 30)];
    pageControl.numberOfPages = 2;
    pageControl.currentPage = 0;
    pageControl.currentPageIndicatorTintColor = LGRGBColorAlpha(209, 198, 100, 1);
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    
    [self.view addSubview:pageControl];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    pageControl.currentPage = scrollView.contentOffset.x/screenSize.width;
}

-(void)nextQuestion:(NSNotification *)noti
{
    stage = [[[NSUserDefaults standardUserDefaults] objectForKey:stageValue]integerValue];
    [self performSegueWithIdentifier:@"playyGuame" sender:nil];
}

-(void)refreshUI:(NSNotification *)noti
{
    for (UIView *subView in self.leftView.subviews) {
        [subView removeFromSuperview];
    }
    for (UIView *subView in self.rightView.subviews) {
        [subView removeFromSuperview];
    }
    [self createeGameaButton:16 superView:self.leftView page:1];
    [self createeGameaButton:16 superView:self.rightView page:2];
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

-(void)back:(CustmerButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)createeGameaButton:(NSInteger)index superView:(UIView *)superView page:(NSInteger)page
{
    
    NSInteger stage = [[[NSUserDefaults standardUserDefaults] objectForKey:stageValue] integerValue];
    for (int i=0; i<index; i++) {
        CustmerButton *btn = [CustmerButton buttonWithType:UIButtonTypeCustom];
        CGFloat width = (screenSize.width-30*2-15*3)*0.25;
        CGFloat height = width;
        btn.frame = CGRectMake(30+(15+width)*(i%4), 60+(15+height)*(i/4), width, height);
        btn.userInteractionEnabled = NO;
        
        if (page==1) {
            if (i==stage) {//代表当前要解的题目
                btn.userInteractionEnabled = YES;
                [btn setBackgroundImage:[UIImage imageNamed:@"unlockIcon.png"] forState:UIControlStateNormal];
            }else if (i<stage){//代表已经解过的题目
                
                btn.userInteractionEnabled = YES;
                [btn setBackgroundImage:[UIImage imageNamed:@"successed.png"] forState:UIControlStateNormal];
                
            }else{//代表还未解锁的题目
                [btn setBackgroundImage:[UIImage imageNamed:@"lockIcon.png"] forState:UIControlStateNormal];
            }
            
            if (i==0) {
                
                [btn setTitle:[NSString stringWithFormat:@"Guide"] forState:UIControlStateNormal];
                
            }else if(i<=stage){
                [btn setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
            }
        }else if (page == 2){
            if (i+16==stage) {//代表当前要解的题目
                btn.userInteractionEnabled = YES;
                [btn setBackgroundImage:[UIImage imageNamed:@"unlockIcon.png"] forState:UIControlStateNormal];
                [btn setTitle:[NSString stringWithFormat:@"%d",i+16] forState:UIControlStateNormal];
            }else if (i+16<stage){//代表已经解过的题目
                
                btn.userInteractionEnabled = YES;
                [btn setBackgroundImage:[UIImage imageNamed:@"successed.png"] forState:UIControlStateNormal];
                [btn setTitle:[NSString stringWithFormat:@"%d",i+16] forState:UIControlStateNormal];
                
            }else{//代表还未解锁的题目
                [btn setBackgroundImage:[UIImage imageNamed:@"lockIcon.png"] forState:UIControlStateNormal];
            }
            
            
        }
        
        btn.layer.cornerRadius = 5;
        btn.tag = 1000+i+(page==2?16:0);
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:i==0?20.f:30.f];
        [btn addTarget:self action:@selector(playyGuame:) forControlEvents:UIControlEventTouchUpInside withSomundrType:SoundTypeNormal];
        [superView addSubview:btn];
    }
}


-(void)playyGuame:(CustmerButton *)sender
{
    NSLog(@"我被点击了...");
    stage = sender.tag-1000;
    [self performSegueWithIdentifier:@"playyGuame" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sour33ceDdata" ofType:@"plist"];
    NSMutableArray *dataArr = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    
    PalyingGameViewController *gamingVC = segue.destinationViewController;
    gamingVC.questionDic = dataArr[stage];
    gamingVC.stageStr = [NSString stringWithFormat:@"%ld",stage];
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
