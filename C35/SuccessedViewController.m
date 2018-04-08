//
//  SuccessedViewController.m
//  C35
//
//  Created by TimeMachine on 2018/4/2.
//  Copyright © 2018年 TimeMachine. All rights reserved.
//

#import "SuccessedViewController.h"

@interface SuccessedViewController ()
@property (weak, nonatomic) IBOutlet UILabel *answerL;

@end

@implementation SuccessedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSInteger stage = [[[NSUserDefaults standardUserDefaults] objectForKey:stageValue] integerValue];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sour33ceDdata" ofType:@"plist"];
    NSMutableArray *dataArr = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    
    NSDictionary *dict = dataArr[stage-1];
    self.answerL.text = dict[@"result"];
    
}

- (IBAction)next:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NextGameNotification object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)gameList:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
