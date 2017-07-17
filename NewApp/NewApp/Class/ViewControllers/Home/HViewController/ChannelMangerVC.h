//
//  ChannelMangerVC.h
//  NewApp
//
//  Created by gxtc on 17/3/14.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "RootViewController.h"

typedef void (^channelMangerFinshBlock)(void);

@interface ChannelMangerVC : RootViewController

@property (nonatomic,copy)channelMangerFinshBlock channelMangerFinishBK;

@end
