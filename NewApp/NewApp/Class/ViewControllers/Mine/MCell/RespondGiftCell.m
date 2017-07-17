//
//  RespondGiftCell.m
//  聊天界面
//
//  Created by root on 17/3/12.
//  Copyright © 2017年 root. All rights reserved.
//

#import "RespondGiftCell.h"

@implementation RespondGiftCell




- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor =[UIColor clearColor];
        
        [self addUI];
    }

    return self;
}


- (void)addUI{
    
    
    UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"head_icon"]];
    imageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 6, 50, 50);
    [self.contentView addSubview:imageView];
    self.iconImageV = imageView;
    
    
    UIImageView * textImageV = [[UIImageView alloc]initWithFrame:CGRectMake( 10, 6, [UIScreen mainScreen].bounds.size.width - 70, 50)];
    textImageV.backgroundColor =[ UIColor clearColor];
    [self.contentView addSubview:textImageV];
    self.textImageView = textImageV;
    
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 6, [UIScreen mainScreen].bounds.size.width - 90, 50)];
//    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:16.0];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:label];
    self.stringLabel = label;
}

@end
