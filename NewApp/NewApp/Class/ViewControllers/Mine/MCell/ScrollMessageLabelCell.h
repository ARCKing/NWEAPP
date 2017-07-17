//
//  ScrollMessageLabelCell.h
//  NewApp
//
//  Created by gxtc on 2017/6/2.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "RootTableViewCell.h"

@interface ScrollMessageLabelCell : RootTableViewCell

@property(nonatomic,strong)UIScrollView * scrollView;

@property(nonatomic,strong)UILabel * messageLabe;


- (void)setMessageWithMessage:(NSString *)message;


@end
