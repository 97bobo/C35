//
//  UIView+frame.m
//  Demo
//
//  Created by TimeMachine on 2017/12/5.
//  Copyright © 2017年 XQL. All rights reserved.
//

#import "UIView+frame.h"

@implementation UIView (frame)

@dynamic xql_bottom,xql_right;

-(CGFloat)xql_left
{
    return CGRectGetMinX(self.frame);
}

-(void)setXql_left:(CGFloat)xql_left
{
    CGRect frame = self.frame;
    frame.origin.x = xql_left;
    self.frame = frame;
}

-(CGFloat)xql_right
{
    return CGRectGetMaxX(self.frame);
}


-(void)setXql_origionX:(CGFloat)xql_origionX
{
    CGRect frame = self.frame;
    frame.origin.x = xql_origionX;
    self.frame = frame;
}

-(CGFloat)xql_origionX
{
    return self.frame.origin.x;
}

-(void)setXql_origionY:(CGFloat)xql_origionY
{
    CGRect frame = self.frame;
    frame.origin.y = xql_origionY;
    self.frame = frame;
}

-(CGFloat)xql_origionY
{
    return self.frame.origin.y;
}

-(void)setXql_width:(CGFloat)xql_width
{
    CGRect  frame = self.frame;
    frame.size.width = xql_width;
    self.frame = frame;
}

-(CGFloat)xql_width
{
    return self.frame.size.width;
}

-(void)setXql_height:(CGFloat)xql_height
{
    CGRect frame = self.frame;
    frame.size.height = xql_height;
    self.frame = frame;
}

-(void)setXql_centerX:(CGFloat)xql_centerX
{
    CGPoint point = self.center;
    point.x = xql_centerX;
    self.center = point;
}

-(CGFloat)xql_centerX
{
    return self.center.x;
}

-(void)setXql_centerY:(CGFloat)xql_centerY
{
    CGPoint point = self.center;
    point.y = xql_centerY;
    self.center = point;
}

-(CGFloat)xql_centerY
{
    return self.center.y;
}

-(CGFloat)xql_height
{
    return self.frame.size.height;
}

-(CGFloat)xql_bottom
{
    return CGRectGetMaxY(self.frame);
}

-(void)setXql_bottom:(CGFloat)xql_bottom
{
    CGRect frame = self.frame;
    frame.size.height = xql_bottom-frame.origin.y;
    self.frame = frame;
}

-(CGFloat)xql_top
{
    return CGRectGetMinY(self.frame);
}

-(void)setXql_top:(CGFloat)xql_top
{
    CGRect frame = self.frame;
    frame.origin.y = xql_top;
    self.frame = frame;
}

@end
