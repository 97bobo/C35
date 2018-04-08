//
//  ViewController.m
//  C35
//
//  Created by TimeMachine on 2018/3/29.
//  Copyright © 2018年 TimeMachine. All rights reserved.
//

#import "ViewController.h"
#import <AVOSCloud.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
}
- (IBAction)clickStageMode:(UIButton *)sender {
    
//    [self performSegueWithIdentifier:@"pushdemo" sender:sender];
    
//    AVObject *testObject = [AVObject objectWithClassName:@"TestObject"];
//    [testObject setObject:@"bar" forKey:@"foo"];
//    [testObject save];
    
}

- (IBAction)clickSpeedMode:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"speedHomeVC" sender:nil];
    
}


@end
