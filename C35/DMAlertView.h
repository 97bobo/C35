//
//  DMAlertView.h
//  DamaiHD
//
//  Created by lixiang on 13-11-27.
//  Copyright (c) 2013年 damai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMAlertView : UIView

+ (instancetype)shareInstance;
- (id)initWithView:(UIView *)view;
- (id)initWithWindow:(UIWindow *)window;
- (void)showText:(NSString *)text;
- (void)showText:(NSString *)text duration:(NSTimeInterval)duration;

@end
