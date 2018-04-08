//
//  PalyingGameViewController.h
//  C35
//
//  Created by TimeMachine on 2018/3/30.
//  Copyright © 2018年 TimeMachine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLHudView.h"

@interface PalyingGameViewController : UIViewController


@property (nonatomic,assign) BOOL  isNeedTimer;
@property (nonatomic,strong) NSDictionary *questionDic;
@property (nonatomic,strong) NSString *stageStr;
@property (nonatomic,strong) NSMutableArray *questionArr;

@end
