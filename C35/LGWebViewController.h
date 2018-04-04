//
//  WebViewController.h
//  JianGuo
//
//  Created by apple on 16/3/23.
//  Copyright © 2016年 ningcol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface LGWebViewController : UIViewController

/** 点击的列表里的第几条进来的 */
@property (nonatomic,copy) NSString *url;

-(void)reloadData;

@end
