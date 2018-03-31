//
//  GamingViewController.m
//  C35
//
//  Created by TimeMachine on 2018/3/30.
//  Copyright © 2018年 TimeMachine. All rights reserved.
//

#import "GamingViewController.h"
#import "MyButton.h"
#import "QLHudView.h"
#import "UIView+frame.h"
#define screenSize [UIScreen mainScreen].bounds.size
#define lineSpace 25
#define LGRGBColor(r, g, b) LGRGBColorAlpha(r, g, b, 1.0)
#define LGRGBColorAlpha(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

typedef enum : NSUInteger {
    CalculationTypeNull,//表示没有选中运算方式
    CalculationTypePlus = 1,//加
    CalculationTypeMinus,//减
    CalculationTypeMultiple,//乘
    CalculationTypeDivide,//除
} CalculationType;

@interface GamingViewController ()
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UIButton *plusB;
@property (weak, nonatomic) IBOutlet UIButton *minusB;
@property (weak, nonatomic) IBOutlet UIButton *multipleB;
@property (weak, nonatomic) IBOutlet UIButton *divideB;

@end

@implementation GamingViewController
{
    UIButton *currentSelectedNumberB;
    UIButton *lastSelectedNumberB;
    NSInteger currentResultNumber;
    NSInteger nextNumber;
    UIButton *currentSelectedCalculateB;
    CalculationType currentCalculationType;
    NSMutableArray *dataArr;
    NSDictionary *dic;
    NSArray *currentNumbers;
    NSInteger count;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    count = 0;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sourceData" ofType:@"plist"];
    dataArr = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    dic = dataArr.firstObject;
    currentNumbers = dic[@"numberArr"];
    
    [self createGameButton:4 superView:self.centerView];
    
    [self.plusB setBackgroundImage:[UIImage imageNamed:@"plus_selected.png"] forState:UIControlStateSelected];
    [self.minusB setBackgroundImage:[UIImage imageNamed:@"minus_selected.png"] forState:UIControlStateSelected];
    [self.multipleB setBackgroundImage:[UIImage imageNamed:@"multiple_selected.png"] forState:UIControlStateSelected];
    [self.divideB setBackgroundImage:[UIImage imageNamed:@"divide_selected.png"] forState:UIControlStateSelected];
    
    [self customNavigationView];
    
}

-(void)customNavigationView
{
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 64)];
    navigationView.backgroundColor = [UIColor clearColor];
    
    MyButton *backB = [MyButton buttonWithType:UIButtonTypeCustom];
    backB.frame = CGRectMake(15, 30, 50, 30);
    [backB setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [backB addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    [navigationView addSubview:backB];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(backB.xql_right+5, backB.xql_top, 100, 30)];
    label.text = @"Guide";
    label.font = [UIFont boldSystemFontOfSize:25];
    label.textColor = LGRGBColor(120, 162, 168);
    [navigationView addSubview:label];
    
    
    MyButton *answerB = [MyButton buttonWithType:UIButtonTypeCustom];
    answerB.frame = CGRectMake(navigationView.xql_width-50, 25, 40, 40);
    [answerB setImage:[UIImage imageNamed:@"tips.png"] forState:UIControlStateNormal];
    [answerB addTarget:self action:@selector(metion:) forControlEvents:UIControlEventTouchUpInside];
    
    [navigationView addSubview:answerB];
    
    
    MyButton *refreshB = [MyButton buttonWithType:UIButtonTypeCustom];
    refreshB.frame = CGRectMake(answerB.xql_left-50, 25, 40, 40);
    [refreshB setImage:[UIImage imageNamed:@"reset.png"] forState:UIControlStateNormal];
    [refreshB addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
    
    [navigationView addSubview:refreshB];
    
    [self.view addSubview:navigationView];
}

-(void)refresh:(MyButton *)sender
{
    for (UIView *view in self.centerView.subviews) {
        [view removeFromSuperview];
    }
    dic = dataArr.lastObject;
    currentNumbers = dic[@"numberArr"];
    [self createGameButton:4 superView:self.centerView];
    
}

-(void)metion:(MyButton *)sender
{
    
}

-(void)back:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)createGameButton:(NSInteger)index superView:(UIView *)superView
{
    for (int i=0; i<index; i++) {
        MyButton *btn = [MyButton buttonWithType:UIButtonTypeCustom];
        CGFloat width = (screenSize.width-60*2-lineSpace*1)*0.5;
        CGFloat height = width;
        btn.frame = CGRectMake(60+(lineSpace+width)*(i%2), 20+(lineSpace+height)*(i/2), width, height);
//        btn.backgroundColor = [UIColor redColor];
        btn.tag = 100+i;
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:45];
        [btn setBackgroundImage:[UIImage imageNamed:@"normal.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"pressed.png"] forState:UIControlStateSelected];
//        btn.layer.cornerRadius = 5;
        [btn setTitle:currentNumbers[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(selectOneNumbner:) forControlEvents:UIControlEventTouchUpInside withSoundType:SoundTypeNormal];
        [superView addSubview:btn];
    }
}

-(void)selectOneNumbner:(MyButton *)sender
{
//    if (currentSelectedNumberB == sender) {
//        currentSelectedNumberB.selected = !currentSelectedNumberB.selected;
//        currentSelectedNumberB = nil;
//        currentResultNumber = 0;
//        return;
//    }
//    currentSelectedNumberB.selected = !currentSelectedNumberB.selected;
//    if (currentSelectedNumberB) {
//        lastSelectedNumberB = currentSelectedNumberB;
//    }
//    currentResultNumber = currentSelectedCalculateB.currentTitle.integerValue;
//    currentSelectedNumberB = sender;
//    currentSelectedNumberB.selected = !currentSelectedNumberB.selected;
    
    if (currentResultNumber==0) {//还没选择数字,只是选择数字,不能进行运算
        currentSelectedNumberB = sender;//设置当前选择数字按钮
        currentSelectedNumberB.selected = !currentSelectedNumberB.selected;
        currentResultNumber = sender.currentTitle.integerValue;//设置选择数字
        return;
        
    }else{//已经选择过一个数字了
        
        if (sender == currentSelectedNumberB) {
            
            currentResultNumber = 0;
            currentSelectedNumberB.selected = !currentSelectedNumberB.selected;
            
        }else{
            if (currentCalculationType == CalculationTypeNull) {//没有运算方式,只是切换当前选择数字
                currentSelectedNumberB.selected = !currentSelectedNumberB.selected;
                currentSelectedNumberB = sender;
                currentSelectedNumberB.selected = !currentSelectedNumberB.selected;
                currentResultNumber = currentSelectedNumberB.currentTitle.integerValue;
                return;
            }else{//已经有了运算方式,需要进行运算
                
                nextNumber = sender.currentTitle.integerValue;
                lastSelectedNumberB = currentSelectedNumberB;
                currentSelectedNumberB = sender;
                lastSelectedNumberB.selected = false;
                currentSelectedNumberB.selected = true;
                
                count++;
            }
        }
        
        
    }
    
    if (currentResultNumber) {
        
        switch (currentCalculationType) {
            case CalculationTypePlus:{//加法
                
                currentResultNumber = currentResultNumber+nextNumber;
                NSLog(@"进行了加法...");
                
                break;
                
            }
            case CalculationTypeMinus:{//减法
                
                currentResultNumber = currentResultNumber-nextNumber;
                NSLog(@"进行了减法...");
                break;
            }
            case CalculationTypeMultiple:{//乘法
                
                currentResultNumber = currentResultNumber*nextNumber;
                NSLog(@"进行了乘法...");
                break;
            }
            case CalculationTypeDivide:{//除法
                
                currentResultNumber = currentResultNumber/nextNumber;
                NSLog(@"进行了除法...");
                break;
            }
            case CalculationTypeNull:{//没选择运算方式
                
                [QLHudView showAlertViewWithText:@"please choose Calculation Type" duration:1.5f];
                return;
            }
        }
        currentCalculationType = CalculationTypeNull;
        currentSelectedCalculateB.selected = !currentSelectedCalculateB.selected;
        currentSelectedNumberB.selected = YES;
        
        
        [UIView animateWithDuration:0.5 animations:^{
            
            lastSelectedNumberB.frame = currentSelectedNumberB.frame;
            lastSelectedNumberB.alpha = 0;
            [currentSelectedNumberB setTitle:[NSString stringWithFormat:@"%ld",currentResultNumber] forState:UIControlStateNormal];
            [currentSelectedNumberB setTitle:[NSString stringWithFormat:@"%ld",currentResultNumber] forState:UIControlStateSelected];
            
            
        }];
        
        if (count == 3) {
            if (currentResultNumber == 35) {
                [QLHudView showAlertViewWithText:@"Success,Congratulations!!!" duration:2.f];
                [UIView animateWithDuration:0.5 animations:^{
                    currentSelectedNumberB.frame = CGRectMake(self.centerView.frame.size.width*0.5-currentSelectedNumberB.frame.size.width*0.5, self.centerView.frame.size.height*0.5-currentSelectedNumberB.frame.size.height*0.5, currentSelectedNumberB.frame.size.width, currentSelectedNumberB.frame.size.height);
                }];
                //继续显示下一道题
                
            }else{
                [QLHudView showAlertViewWithText:@"Wrong!!!" duration:2.f];
                [currentSelectedNumberB setBackgroundImage:[UIImage imageNamed:@"wrong.png"] forState:UIControlStateNormal];
                [currentSelectedNumberB setBackgroundImage:[UIImage imageNamed:@"wrong.png"] forState:UIControlStateSelected];
            }
        }
        
    }else{
        currentResultNumber = sender.currentTitle.integerValue;
    }
    
    
}

- (IBAction)clickCalculationSymbol:(UIButton *)sender {
    
    if (sender == currentSelectedCalculateB&&currentSelectedCalculateB.selected == YES) {
        sender.selected = !sender.selected;
        currentCalculationType = CalculationTypeNull;
        return;
    }
    //    tag:+-x/:1000~1003
    currentSelectedCalculateB.selected = !currentSelectedCalculateB;
    currentSelectedCalculateB = sender;
    switch (sender.tag) {
        case 1000:{//加法
            
            currentCalculationType = CalculationTypePlus;
            break;
            
        }
        case 1001:{//减法
            
            currentCalculationType = CalculationTypeMinus;
            break;
        }
        case 1002:{//乘法
            
            currentCalculationType = CalculationTypeMultiple;
            break;
        }
        case 1003:{//除法
            
            currentCalculationType = CalculationTypeDivide;
            break;
        }
            
    }
    sender.selected = !sender.selected;
    
}


@end
