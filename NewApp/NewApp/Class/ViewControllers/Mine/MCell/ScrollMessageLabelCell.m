//
//  ScrollMessageLabelCell.m
//  NewApp
//
//  Created by gxtc on 2017/6/2.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "ScrollMessageLabelCell.h"

#define scroll_w (ScreenWith - 15 - ScreenWith/16 - 15 - 10)

@interface ScrollMessageLabelCell()



@end

@implementation ScrollMessageLabelCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addUI];
    }

    return self;
}


- (void)setMessageWithMessage:(NSString *)message{

    message = [message stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    CGSize  size = [message sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]}];
    CGFloat size_w = size.width;
    
    self.scrollView.contentSize = CGSizeMake(size_w, 0);
    self.messageLabe.frame = CGRectMake(0, 0, size_w, ScreenWith/16);
    self.messageLabe.text = [NSString stringWithFormat:@"%@",message];
    
}



- (void)addUI{

    UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"laba"]];
    image.frame = CGRectMake(15, ScreenWith/32, ScreenWith/16, ScreenWith/16);
    [self.contentView addSubview:image];
    
    
    UIScrollView * scrolLabel = [[UIScrollView alloc]initWithFrame:CGRectMake(15 + ScreenWith/16 + 15, ScreenWith/32,scroll_w, ScreenWith/16)];
    scrolLabel.contentSize = CGSizeMake((ScreenWith - 15 - ScreenWith/16 - 15 - 10)*3, 0);
//    scrolLabel.scrollEnabled = NO;
    scrolLabel.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:scrolLabel];
    
    UILabel * label = [[UILabel  alloc ]initWithFrame:CGRectMake(0,0,scroll_w * 2, ScreenWith/16)];
    label.textColor = [UIColor redColor];
    label.text = @"恭喜139****7640获得1次抽奖机会";
    label.font = [UIFont systemFontOfSize:14.0];
    [scrolLabel addSubview:label];
    label.numberOfLines = 1;
    self.scrollView = scrolLabel;
    self.messageLabe = label;
    
}


@end
