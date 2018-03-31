//
//  QLHudView.h
//  JianGuo
//
//  Created by apple on 17/2/22.
//  Copyright © 2017年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QLHudView : NSObject

+(instancetype)shareInstance;
-(void)showNotificationNews:(NSString *)message;
+ (void)showErrorViewWithText:(NSString *)text;
+ (void)showAlertViewWithText:(NSString *)text duration:(NSTimeInterval)duration;

@end
