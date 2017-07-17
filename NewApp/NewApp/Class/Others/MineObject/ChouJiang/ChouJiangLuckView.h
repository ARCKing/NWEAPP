//
//  ChouJiangLuckView.h
//  九宫格抽奖
//
//  Created by gxtc on 17/2/8.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootView.h"

@interface giftModel : NSObject

@end



@interface ChouJiangLuckView : RootView
@property(nonatomic,strong)UIButton * backBt;

- (void)getDataSource;

@end
