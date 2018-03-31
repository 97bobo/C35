//
//  UIView+frame.h
//  Demo
//
//  Created by TimeMachine on 2017/12/5.
//  Copyright © 2017年 XQL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (frame)

@property (nonatomic,assign) CGFloat xql_origionX;
@property (nonatomic,assign) CGFloat xql_origionY;
@property (nonatomic,assign) CGFloat xql_width;
@property (nonatomic,assign) CGFloat xql_height;
@property (nonatomic,assign) CGFloat xql_centerX;
@property (nonatomic,assign) CGFloat xql_centerY;
@property (nonatomic,assign) CGFloat xql_left;
@property (nonatomic,assign) CGFloat xql_top;

@property (nonatomic,assign) CGFloat xql_bottom;
@property (nonatomic,assign,readonly) CGFloat xql_right;

@end
