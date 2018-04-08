//
//  NetWorkStatusManager.h
//  MiniCars
//
//  Created by David on 2017/2/17.
//  Copyright © 2017年 xiaxia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGReachability.h"

typedef void(^NetStatusChange)(NetworkStatus status);

@interface NetWorkStatusManager : NSObject

@property (nonatomic, assign) NetworkStatus status;

@property (nonatomic, copy)NetStatusChange NetStatusChange;

+ (NetWorkStatusManager *)manager;



- (NetworkStatus)currentStatus;


@end
