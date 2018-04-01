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
#import <AVFoundation/AVFoundation.h>
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
    UIView *_bgView;
    UIView *_metionView;
    SystemSoundID soundFileObject;
    AVAudioPlayer *_player;
    
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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self playSoundEffect:@"background-music" type:@"mp3"];
    });
    
}

-(void)customNavigationView
{
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 74)];
    navigationView.backgroundColor = [UIColor clearColor];
    
    MyButton *backB = [MyButton buttonWithType:UIButtonTypeCustom];
    backB.frame = CGRectMake(15, 30, 50, 40);
    [backB setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backB addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    [navigationView addSubview:backB];
    
    if (_isNeedTimer) {
        
        UILabel *timeL = [[UILabel alloc] initWithFrame:CGRectMake(backB.xql_right+5, backB.xql_top, 100, 20)];
        timeL.text = @"0 s";
        timeL.font = [UIFont boldSystemFontOfSize:25];
        timeL.textColor = [UIColor orangeColor];
        [navigationView addSubview:timeL];
        
        UILabel *progressL = [[UILabel alloc] initWithFrame:CGRectMake(backB.xql_right+5, timeL.xql_bottom, 100, 20)];
        progressL.text = @"1/10";
        progressL.font = [UIFont boldSystemFontOfSize:15];
//        progressL.font = [UIFont boldSystemFontOfSize:25];
        progressL.textColor = LGRGBColor(120, 162, 168);
        [navigationView addSubview:progressL];
        
        NSTimer *timer = [NSTimer timerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            timeL.text = [NSString stringWithFormat:@"%.1f s",timeL.text.floatValue+0.1];
        }];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        
    }else{
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(backB.xql_right+5, backB.xql_top, 100, 30)];
        label.text = @"Guide";
        label.font = [UIFont boldSystemFontOfSize:25];
        label.textColor = LGRGBColor(120, 162, 168);
        [navigationView addSubview:label];
    }
    
    
    MyButton *answerB = [MyButton buttonWithType:UIButtonTypeCustom];
    answerB.frame = CGRectMake(navigationView.xql_width-50, 25, 50, 50);
    [answerB setImage:[UIImage imageNamed:@"tips.png"] forState:UIControlStateNormal];
    [answerB addTarget:self action:@selector(metion:) forControlEvents:UIControlEventTouchUpInside];
    
    [navigationView addSubview:answerB];
    
    
    MyButton *refreshB = [MyButton buttonWithType:UIButtonTypeCustom];
    refreshB.frame = CGRectMake(answerB.xql_left-50, 25, 50, 50);
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
    UIView *bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor = [UIColor clearColor];
    _bgView = bgView;
    
    UIView *metionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    metionView.layer.shadowColor = [UIColor blackColor].CGColor;
    metionView.layer.shadowOffset = CGSizeMake(3, 3);
    metionView.layer.shadowOpacity = 0.5;
    metionView.center = bgView.center;
    metionView.backgroundColor = [UIColor whiteColor];
    metionView.layer.cornerRadius = 5;
    _metionView = metionView;
    
    [self createImagesView:_metionView];
    
    UIView *answerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 80)];
    answerView.backgroundColor = [UIColor lightGrayColor];
    answerView.center = CGPointMake(metionView.xql_width*0.5, metionView.xql_height*0.5+30);
    [metionView addSubview:answerView];
    
    UILabel *answerL = [[UILabel alloc] initWithFrame:answerView.bounds];
    answerL.text = @"(4+3)x(8-3)";
    answerL.font = [UIFont boldSystemFontOfSize:30];
    answerL.textAlignment = NSTextAlignmentCenter;
    answerL.textColor = [UIColor greenColor];
    [answerView addSubview:answerL];
    
    
    UIButton *closeB = [UIButton buttonWithType:UIButtonTypeCustom];
    closeB.frame = CGRectMake(metionView.xql_width-40, 10, 30, 30);
    [closeB setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [closeB addTarget:self action:@selector(closeMetion:) forControlEvents:UIControlEventTouchUpInside];
    [metionView addSubview:closeB];
    
    [bgView addSubview:metionView];
    
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    
    
//    [UIView animateWithDuration:0.3 animations:^{
//        metionView.frame = CGRectMake(0, 0, 300, 300);
//        metionView.center = bgView.center;
//        closeB.frame = CGRectMake(metionView.xql_width-40, 10, 30, 30);
//    }];
    
}

-(void)createImagesView:(UIView *)superView
{
    for (int index=0; index<3; index++) {
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tips.png"]];
//        [imgView sizeToFit];
        
        imgView.frame = CGRectMake(30+index*50, 20, 30, 30);
        [superView addSubview:imgView];
        
    }
}

-(void)closeMetion:(UIButton *)sender
{
    [_bgView removeFromSuperview];
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


- (void)playSoundEffect:(NSString*)name type:(NSString*)type

{
    
    //得到音效文件的地址
    
//    NSString*soundFilePath =[[NSBundle mainBundle] URLForResource:@"background-music.mp3" withExtension:nil];
    
    
    //将地址字符串转换成url
    
    NSURL*soundURL =[[NSBundle mainBundle] URLForResource:@"background-music.mp3" withExtension:nil];
    
    
    // 取出资源的URL
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"1201111234.mp3" withExtension:nil];
    
    // 创建播放器
    NSError *error = nil;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
    
    // 准备播放
    [_player prepareToPlay];
    [_player play];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(62 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_player play];
    });
    
//    //生成系统音效id
//
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &soundFileObject);
//
//    //播放系统音效
//
//    AudioServicesPlaySystemSound(soundFileObject);
    
}


@end
