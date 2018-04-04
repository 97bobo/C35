//
//  MyButton.h
//  C35
//
//  Created by TimeMachine on 2018/3/30.
//  Copyright © 2018年 TimeMachine. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SoundTypeNormal,
    SoundTypeFail,
    SoundTypeSuccess,
    SoundTypeCard,
} SoundType;

@interface MyButton : UIButton

-(void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents withSoundType:(SoundType)type;
@property (nonatomic,assign) SoundType type;

@end
