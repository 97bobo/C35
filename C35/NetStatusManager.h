//
//  NetStatusManager.h
//  MiniCars
//
//  Created by David on 2017/2/17.
//  Copyright © 2017年 xiaxia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGReachability.h"

typedef void(^NetStatusChange)(NetworkStatus status);

@interface NetStatusManager : NSObject

@property (nonatomic, assign) NetworkStatus status;

@property (nonatomic, copy)NetStatusChange NetStatusChange;

+ (NetStatusManager *)manager;



- (NetworkStatus)currentStatus;


@end
