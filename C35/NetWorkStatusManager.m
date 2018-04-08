//
//  NetWorkStatusManager.m
//  MiniCars
//
//  Created by David on 2017/2/17.
//  Copyright © 2017年 xiaxia. All rights reserved.
//

#import "NetWorkStatusManager.h"
#include <dlfcn.h>

@interface NetWorkStatusManager ()

@property (nonatomic, strong)LGReachability *reachability;

@end

@implementation NetWorkStatusManager

+ (NetWorkStatusManager *)manager{
    static NetWorkStatusManager *mgr;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mgr = [[self alloc]init];
        [mgr startNotifier];
    });
    return mgr;
}

- (void)startNotifier{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    LGReachability *reachability = [LGReachability reachabilityForInternetConnection];
    self.reachability = reachability;
    self.status = [reachability currentReachabilityStatus];
    [reachability startNotifier];
    
    
}
- (void)reachabilityChanged:(NSNotification *)noti{
    LGReachability *currReach = [noti object];
    
//    NSParameterAssert([currReach isKindOfClass:[LGReachability class]]);
    
    //对连接改变做出响应处理动作
    
    self.status = [currReach currentReachabilityStatus];
    
    !_NetStatusChange ? : _NetStatusChange(self.status);
}

- (NetworkStatus)currentStatus{
    
    return self.status;
    
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
