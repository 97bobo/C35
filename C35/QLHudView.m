//
//  QLHudView.m
//  JianGuo
//
//  Created by apple on 17/2/22.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import "QLHudView.h"
#import "DMAlertView.h"

#define LGScreenWidth [UIScreen mainScreen].bounds.size.width
#define LGScreenHeight [UIScreen mainScreen].bounds.size.height
static CGFloat const AlerViewHeight = 64;

@interface QLHudView()

@end

@implementation QLHudView

+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static QLHudView *view = nil;
    dispatch_once(&onceToken, ^{
        view = [[self alloc] init];
    });
    return view;
}

+ (void)showErrorViewWithText:(NSString *)text {
    DMAlertView *hud = nil;
    hud = [[DMAlertView alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    [hud showText:text];
}
+ (void)showAlertViewWithText:(NSString *)text duration:(NSTimeInterval)duration {
    DMAlertView *hud = nil;
    hud = [[DMAlertView alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    [hud showText:text duration:duration];
}

-(void)showNotificationNews:(NSString *)message
{
    [self show:message];
}

-(void)show:(NSString *)message
{
    
    CGRect rect = [message boundingRectWithSize:CGSizeMake(LGScreenWidth-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]} context:nil];

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, -(rect.size.height+50)-20, LGScreenWidth, (rect.size.height+50)+20)];
//    bgView.backgroundColor = RedColor;
    
    
    
    UILabel *contentL = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, LGScreenWidth-40, rect.size.height)];
    contentL.text = message;
    contentL.font = [UIFont boldSystemFontOfSize:14];
    contentL.textColor = [UIColor whiteColor];
    contentL.numberOfLines = 0;
    contentL.backgroundColor = [UIColor clearColor];
    [bgView addSubview:contentL];
    
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    
    CGRect frame = bgView.frame;
    frame.origin.y = -20.f;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:5 options:UIViewAnimationOptionCurveLinear animations:^{
        bgView.frame = frame;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(dismiss:) withObject:@{@"height":[NSNumber numberWithFloat:(rect.size.height+50)],@"view":bgView} afterDelay:2];
    }];
}

-(void)dismiss:(NSDictionary *)params
{
    CGFloat h = [params[@"height"] floatValue];
    UIView *bgView = params[@"view"];
    CGRect frame = bgView.frame;
    frame.origin.y = -h-20;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        bgView.frame = frame;
    } completion:^(BOOL finished) {
//        [APPLICATION setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        [bgView removeFromSuperview];
    }];
}

@end
