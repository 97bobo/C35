//
//  PalyingGameViewController.m
//  C35
//
//  Created by TimeMachine on 2018/3/30.
//  Copyright © 2018年 TimeMachine. All rights reserved.
//

#import "PalyingGameViewController.h"
#import "SuccessedViewController.h"
#import "CustmerButton.h"
#import "QLHudView.h"
#import "UIView+frame.h"
#import <AVFoundation/AVFoundation.h>

typedef enum : NSUInteger {
    CalculationTypeNull,//表示没有选中运算方式
    CalculationTypePlus = 1,//加
    CalculationTypeMinus,//减
    CalculationTypeMultiple,//乘
    CalculationTypeDivide,//除
} CalculationType;

@interface PalyingGameViewController ()
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UIButton *plusB;
@property (weak, nonatomic) IBOutlet UIButton *minusB;
@property (weak, nonatomic) IBOutlet UIButton *multipleB;
@property (weak, nonatomic) IBOutlet UIButton *divideB;
@property (weak, nonatomic) IBOutlet UILabel *progressL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (nonatomic,strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIView *tipsView;
@property (nonatomic,strong) CustmerButton *answerB;

@end

@implementation PalyingGameViewController
{
    UIButton *currentrSelecterdNumrberB;
    UIButton *lastSerelectedNerumberB;
    NSInteger curresfntResultNsdumber;
    NSInteger nsdextNusdmber;
    UIButton *curresdnsdtSelectedCalsdculateB;
    CalculationType currentsdCalculatsdionType;
    NSMutableArray *dataArr;
    NSDictionary *dic;
    NSArray *currentsdNsdumbers;
    NSInteger count;
    UIView *_bgView;
    UIView *_metionView;
    SystemSoundID sousdndFileOsdbject;
    AVAudioPlayer *_player;
    NSInteger timerfdCount;
    NSInteger replaceCount;
    NSInteger metionCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    count = 0;
    
    self.questionArr = @[].mutableCopy;
    
    if (_isNeedTimer) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sour33ceDdata" ofType:@"plist"];
        NSMutableArray *dataArray = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
        for (int randomCount=0; randomCount<10; randomCount++) {
            
            NSDictionary *dic = dataArray[arc4random()%32];
            [self.questionArr addObject:dic];
        }
        self.questionDic = self.questionArr.firstObject;
        currentsdNsdumbers = self.questionDic[@"numberArr"];
    }else{
        
        currentsdNsdumbers = self.questionDic[@"numberArr"];
        self.tipsView.hidden = YES;
    }
    
    
    
    [self createGameButton:4 superView:self.centerView];
    
    [self.plusB setBackgroundImage:[UIImage imageNamed:@"plus_selected.png"] forState:UIControlStateSelected];
    [self.minusB setBackgroundImage:[UIImage imageNamed:@"minus_selected.png"] forState:UIControlStateSelected];
    [self.multipleB setBackgroundImage:[UIImage imageNamed:@"multiple_selected.png"] forState:UIControlStateSelected];
    [self.divideB setBackgroundImage:[UIImage imageNamed:@"divide_selected.png"] forState:UIControlStateSelected];
    
    [self customNavigationView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self playdSoulndEffrect:@"backMusic" type:@"mp3"];
    });
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_player stop];
    _player = nil;
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
    
    if (_isNeedTimer) {
        
        UILabel *timeL = [[UILabel alloc] initWithFrame:CGRectMake(backB.xql_right+5, backB.xql_top, 100, 20)];
        timeL.text = @"0 s";
        timeL.font = [UIFont boldSystemFontOfSize:25];
        timeL.textColor = [UIColor orangeColor];
        [navigationView addSubview:timeL];
        self.timeL = timeL;
        
        UILabel *progressL = [[UILabel alloc] initWithFrame:CGRectMake(backB.xql_right+5, timeL.xql_bottom, 100, 20)];
        progressL.text = @"1/10";
        progressL.font = [UIFont boldSystemFontOfSize:15];
//        progressL.font = [UIFont boldSystemFontOfSize:25];
        progressL.textColor = LGRGBColor(120, 162, 168);
        [navigationView addSubview:progressL];
        self.progressL = progressL;
        
        NSTimer *timer = [NSTimer timerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            timeL.text = [NSString stringWithFormat:@"%.1f s",timeL.text.floatValue+0.1];
        }];
        self.timer = timer;
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        
    }else{
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(backB.xql_right+5, backB.xql_top, 100, 30)];
        label.text = @"Guide";
        label.font = [UIFont boldSystemFontOfSize:25];
        label.textColor = LGRGBColor(120, 162, 168);
        [navigationView addSubview:label];
    }
    
    
    CustmerButton *answerB = [CustmerButton buttonWithType:UIButtonTypeCustom];
    self.answerB = answerB;
    answerB.frame = CGRectMake(navigationView.xql_width-50, 25, 50, 50);
    [answerB setBackgroundImage:[UIImage imageNamed:_isNeedTimer?@"delete.png":@"tips.png"] forState:UIControlStateNormal];
    [answerB addTarget:self action:@selector(metion:) forControlEvents:UIControlEventTouchUpInside];
    
    answerB.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    metionCount = [[[NSUserDefaults standardUserDefaults] valueForKey:tipsCount] integerValue];
    if (_isNeedTimer) {
        
        [answerB setTitle:@"3" forState:UIControlStateNormal];
    }else{
        
        [self.answerB setTitle:[NSString stringWithFormat:@"%ld",3-metionCount] forState:UIControlStateNormal];
        
        if (metionCount == 3) {
            
            [self.answerB setBackgroundImage:[UIImage imageNamed:@"tips_disabled.png"] forState:UIControlStateNormal];
            self.answerB.userInteractionEnabled = NO;
        }
    }
    
    
    [navigationView addSubview:answerB];
    
    
    UIButton *refreshB = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshB.frame = CGRectMake(answerB.xql_left-50, 25, 50, 50);
    [refreshB setImage:[UIImage imageNamed:@"reset.png"] forState:UIControlStateNormal];
    [refreshB addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
    
    [navigationView addSubview:refreshB];
    
    [self.view addSubview:navigationView];
}

-(void)refresh:(UIButton *)sender
{
    for (UIView *view in self.centerView.subviews) {
        [view removeFromSuperview];
    }
    currentrSelecterdNumrberB = nil;
    currentsdCalculatsdionType = CalculationTypeNull;
    curresfntResultNsdumber = 0;
    count = 0;
    [self createGameButton:4 superView:self.centerView];
    [self playButtonSoundName:@"reset" type:@"mp3"];
    
}

-(void)metion:(CustmerButton *)sender
{
    if (_isNeedTimer) {
        
        replaceCount++;
        
        [self.answerB setTitle:[NSString stringWithFormat:@"%ld",3-replaceCount] forState:UIControlStateNormal];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"replacsdeQuestisdons" ofType:@"plist"];
        NSMutableArray *dataArr = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
        NSDictionary *dic = dataArr[arc4random()%dataArr.count];
        [self.questionArr replaceObjectAtIndex:[self.questionArr indexOfObject:self.questionDic] withObject:dic];
        self.questionDic = dic;
        currentsdNsdumbers = self.questionDic[@"numberArr"];
        [self refresh:nil];
        if (replaceCount == 3) {
            [self.answerB setBackgroundImage:[UIImage imageNamed:@"delete_disabled.png"] forState:UIControlStateNormal];
            self.answerB.userInteractionEnabled = NO;
            return;
        }
        return;
    }
    
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:tipsCount] integerValue]) {
        
        metionCount = [[[NSUserDefaults standardUserDefaults] valueForKey:tipsCount] integerValue];
    }else{
        
    }
    
    
    metionCount++;
    [[NSUserDefaults standardUserDefaults] setValue:@(metionCount) forKey:tipsCount];
    
    [self.answerB setTitle:[NSString stringWithFormat:@"%ld",3-metionCount] forState:UIControlStateNormal];
    
    UIView *bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeMetion:)];
    [bgView addGestureRecognizer:tap];
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
    answerView.backgroundColor = LGRGBColor(241, 241, 241);
    answerView.layer.cornerRadius = 5.f;
    answerView.center = CGPointMake(metionView.xql_width*0.5, metionView.xql_height*0.5+30);
    [metionView addSubview:answerView];
    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sour33ceDdata" ofType:@"plist"];
//    NSMutableArray *dataArr = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
//    
//    NSDictionary *dict = dataArr[self.stageStr.integerValue];
    
    UILabel *answerL = [[UILabel alloc] initWithFrame:answerView.bounds];
    answerL.text = self.questionDic[@"result"];
    answerL.font = [UIFont boldSystemFontOfSize:20];
    answerL.textAlignment = NSTextAlignmentCenter;
    answerL.textColor = LGRGBColor(100, 240, 100);
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
    
    
    if (metionCount == 3) {
        [self.answerB setBackgroundImage:[UIImage imageNamed:@"tips_disabled.png"] forState:UIControlStateNormal];
        self.answerB.userInteractionEnabled = NO;
    }
    
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
        CustmerButton *btn = [CustmerButton buttonWithType:UIButtonTypeCustom];
        CGFloat width = (screenSize.width-60*2-lineSpace*1)*0.5;
        CGFloat height = width;
        btn.frame = CGRectMake(60+(lineSpace+width)*(i%2), 20+(lineSpace+height)*(i/2), width, height);
//        btn.backgroundColor = [UIColor redColor];
        btn.tag = 100+i;
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:45];
        [btn setBackgroundImage:[UIImage imageNamed:@"normal.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"pressed.png"] forState:UIControlStateSelected];
//        btn.layer.cornerRadius = 5;
        [btn setTitle:currentsdNsdumbers[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(selectOneNumbner:) forControlEvents:UIControlEventTouchUpInside withSomundrType:SoundTypeCard];
        [superView addSubview:btn];
    }
}

-(void)selectOneNumbner:(CustmerButton *)sender
{
//    if (currentrSelecterdNumrberB == sender) {
//        currentrSelecterdNumrberB.selected = !currentrSelecterdNumrberB.selected;
//        currentrSelecterdNumrberB = nil;
//        curresfntResultNsdumber = 0;
//        return;
//    }
//    currentrSelecterdNumrberB.selected = !currentrSelecterdNumrberB.selected;
//    if (currentrSelecterdNumrberB) {
//        lastSerelectedNerumberB = currentrSelecterdNumrberB;
//    }
//    curresfntResultNsdumber = curresdnsdtSelectedCalsdculateB.currentTitle.integerValue;
//    currentrSelecterdNumrberB = sender;
//    currentrSelecterdNumrberB.selected = !currentrSelecterdNumrberB.selected;
    
    if (curresfntResultNsdumber==0) {//还没选择数字,只是选择数字,不能进行运算
        currentrSelecterdNumrberB = sender;//设置当前选择数字按钮
        currentrSelecterdNumrberB.selected = !currentrSelecterdNumrberB.selected;
        curresfntResultNsdumber = sender.currentTitle.integerValue;//设置选择数字
        return;
        
    }else{//已经选择过一个数字了
        
        if (sender == currentrSelecterdNumrberB) {
            
            curresfntResultNsdumber = 0;
            currentrSelecterdNumrberB.selected = !currentrSelecterdNumrberB.selected;
            
        }else{
            if (currentsdCalculatsdionType == CalculationTypeNull) {//没有运算方式,只是切换当前选择数字
                currentrSelecterdNumrberB.selected = !currentrSelecterdNumrberB.selected;
                currentrSelecterdNumrberB = sender;
                currentrSelecterdNumrberB.selected = !currentrSelecterdNumrberB.selected;
                curresfntResultNsdumber = currentrSelecterdNumrberB.currentTitle.integerValue;
                return;
            }else{//已经有了运算方式,需要进行运算
                
                nsdextNusdmber = sender.currentTitle.integerValue;
                lastSerelectedNerumberB = currentrSelecterdNumrberB;
                currentrSelecterdNumrberB = sender;
                lastSerelectedNerumberB.selected = false;
                currentrSelecterdNumrberB.selected = true;
                
                count++;
            }
        }
        
        
    }
    
    if (curresfntResultNsdumber) {
        
        switch (currentsdCalculatsdionType) {
            case CalculationTypePlus:{//加法
                
                curresfntResultNsdumber = curresfntResultNsdumber+nsdextNusdmber;
                NSLog(@"进行了加法...");
                
                break;
                
            }
            case CalculationTypeMinus:{//减法
                
                curresfntResultNsdumber = curresfntResultNsdumber-nsdextNusdmber;
                NSLog(@"进行了减法...");
                break;
            }
            case CalculationTypeMultiple:{//乘法
                
                curresfntResultNsdumber = curresfntResultNsdumber*nsdextNusdmber;
                NSLog(@"进行了乘法...");
                break;
            }
            case CalculationTypeDivide:{//除法
                
                curresfntResultNsdumber = curresfntResultNsdumber/nsdextNusdmber;
                NSLog(@"进行了除法...");
                break;
            }
            case CalculationTypeNull:{//没选择运算方式
                
                [QLHudView showAlertViewWithText:@"please choose Calculation Type" duration:1.5f];
                return;
            }
        }
        currentsdCalculatsdionType = CalculationTypeNull;
        curresdnsdtSelectedCalsdculateB.selected = !curresdnsdtSelectedCalsdculateB.selected;
        currentrSelecterdNumrberB.selected = YES;
        
        
        [UIView animateWithDuration:0.5 animations:^{
            
            lastSerelectedNerumberB.frame = currentrSelecterdNumrberB.frame;
            lastSerelectedNerumberB.alpha = 0;
            [currentrSelecterdNumrberB setTitle:[NSString stringWithFormat:@"%ld",curresfntResultNsdumber] forState:UIControlStateNormal];
            [currentrSelecterdNumrberB setTitle:[NSString stringWithFormat:@"%ld",curresfntResultNsdumber] forState:UIControlStateSelected];
            
            
        }];
        
        if (count == 3) {
            if (curresfntResultNsdumber == 35) {//计算成功!!!
//                [QLHudView showAlertViewWithText:@"Success,Congratulations!!!" duration:2.f];
                [self playButtonSoundName:@"succcess" type:@"mp3"];
                [UIView animateWithDuration:0.5 animations:^{
                    currentrSelecterdNumrberB.frame = CGRectMake(self.centerView.frame.size.width*0.5-currentrSelecterdNumrberB.frame.size.width*0.5, self.centerView.frame.size.height*0.5-currentrSelecterdNumrberB.frame.size.height*0.5, currentrSelecterdNumrberB.frame.size.width, currentrSelecterdNumrberB.frame.size.height);
                } completion:^(BOOL finished) {
                    if (finished) {
                        
                        if (!_isNeedTimer) {
                            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",self.stageStr.integerValue+1] forKey:stageValue];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            [[NSNotificationCenter defaultCenter] postNotificationName:CompletedGameNotification object:nil];
                            [self performSegueWithIdentifier:@"successed" sender:nil];
                            [self.navigationController popViewControllerAnimated:NO];
                        }else{//计时模式,在取好的十道题中依次展示
                            timerfdCount++;
                            if (timerfdCount==10) {
                                [self.timer invalidate];
                                self.progressL.text = [NSString stringWithFormat:@"%ld/10",timerfdCount];
                                [[NSUserDefaults standardUserDefaults] setObject:self.timeL.text forKey:bestTime];
                                [[NSUserDefaults standardUserDefaults]synchronize];
                                return ;
                            }
                            self.questionDic = self.questionArr[timerfdCount];
                            currentsdNsdumbers = self.questionDic[@"numberArr"];
                            [self refresh:nil];
                            
                            self.progressL.text = [NSString stringWithFormat:@"%ld/10",timerfdCount+1];
                            
                        }
                    }
                }];
                //继续显示下一道题
                
            }else{
//                [QLHudView showAlertViewWithText:@"Wrong!!!" duration:2.f];
                
                [self playButtonSoundName:@"wrang" type:@"mp3"];
                [currentrSelecterdNumrberB setBackgroundImage:[UIImage imageNamed:@"wrong.png"] forState:UIControlStateNormal];
                [currentrSelecterdNumrberB setBackgroundImage:[UIImage imageNamed:@"wrong.png"] forState:UIControlStateSelected];
            }
        }
        
    }else{
        curresfntResultNsdumber = sender.currentTitle.integerValue;
    }
    
    
}

- (IBAction)clickCalculationSymbol:(UIButton *)sender {
    
    if (sender == curresdnsdtSelectedCalsdculateB&&curresdnsdtSelectedCalsdculateB.selected == YES) {
        sender.selected = !sender.selected;
        currentsdCalculatsdionType = CalculationTypeNull;
        return;
    }
    //    tag:+-x/:1000~1003
    curresdnsdtSelectedCalsdculateB.selected = !curresdnsdtSelectedCalsdculateB;
    curresdnsdtSelectedCalsdculateB = sender;
    switch (sender.tag) {
        case 1000:{//加法
            
            currentsdCalculatsdionType = CalculationTypePlus;
            break;
            
        }
        case 1001:{//减法
            
            currentsdCalculatsdionType = CalculationTypeMinus;
            break;
        }
        case 1002:{//乘法
            
            currentsdCalculatsdionType = CalculationTypeMultiple;
            break;
        }
        case 1003:{//除法
            
            currentsdCalculatsdionType = CalculationTypeDivide;
            break;
        }
            
    }
    sender.selected = !sender.selected;
    
}


- (void)playdSoulndEffrect:(NSString*)name type:(NSString*)type

{
    
    //得到音效文件的地址
    
//    NSString*soundFilePath =[[NSBundle mainBundle] URLForResource:@"backMusic.mp3" withExtension:nil];
    
    
    //将地址字符串转换成url
    
    NSURL*soundURL =[[NSBundle mainBundle] URLForResource:@"backMusic.mp3" withExtension:nil];
    
    
    // 取出资源的URL
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"1201111234.mp3" withExtension:nil];
    
    // 创建播放器
    NSError *error = nil;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
    
    // 准备播放
    [_player prepareToPlay];
    [_player play];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_player play];
    });
    
//    //生成系统音效id
//
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &sousdndFileOsdbject);
//
//    //播放系统音效
//
//    AudioServicesPlaySystemSound(sousdndFileOsdbject);
    
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // segue.identifier：获取连线的ID
    if ([segue.identifier isEqualToString:@"gamingVC"]) {
        // segue.destinationViewController：获取连线时所指的界面（VC）
        SuccessedViewController *receive = segue.destinationViewController;
//        receive.isNeedTimer = YES;
        // 这里不需要指定跳转了，因为在按扭的事件里已经有跳转的代码
        //        [self.navigationController pushViewController:receive animated:YES];
    }
}
- (void)playButtonSoundName:(NSString*)name type:(NSString*)type

{
    
    //得到音效文件的地址
    
    NSString*soundFilePath =[[NSBundle mainBundle]pathForResource:name ofType:type];
    
    //将地址字符串转换成url
    
    NSURL*soundURL = [NSURL fileURLWithPath:soundFilePath];
    
    //生成系统音效id
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &sousdndFileOsdbject);
    
    //播放系统音效
    
    AudioServicesPlaySystemSound(sousdndFileOsdbject);
    
}

@end
