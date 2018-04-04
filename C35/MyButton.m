//
//  MyButton.m
//  C35
//
//  Created by TimeMachine on 2018/3/30.
//  Copyright © 2018年 TimeMachine. All rights reserved.
//

#import "MyButton.h"
#import <AVFoundation/AVFoundation.h>

@implementation MyButton
{
    SystemSoundID soundFileObject;
}

-(void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents withSoundType:(SoundType)type
{
    _type = type;
    [self addTarget:target action:action forControlEvents:controlEvents];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent*)event

{
    
    NSString *name;
    switch (_type) {
        case SoundTypeNormal:
            name = @"btn";
            break;
        case SoundTypeFail:
            name = @"wrong";
            break;
        case SoundTypeSuccess:
            name = @"success";
            break;
        case SoundTypeCard:
            name = @"card";
            break;
            
    }
    !name?:[self playSoundEffect:name type:@"mp3"];
    [super touchesBegan:touches withEvent:event];
    
}

- (void)playSoundEffect:(NSString*)name type:(NSString*)type

{
    
    //得到音效文件的地址
    
    NSString*soundFilePath =[[NSBundle mainBundle]pathForResource:name ofType:type];
    
    //将地址字符串转换成url
    
    NSURL*soundURL = [NSURL fileURLWithPath:soundFilePath];
    
    //生成系统音效id
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &soundFileObject);
    
    //播放系统音效
    
    AudioServicesPlaySystemSound(soundFileObject);
    
}

@end
