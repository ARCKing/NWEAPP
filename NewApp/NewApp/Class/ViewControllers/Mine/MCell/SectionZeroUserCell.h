//
//  SectionZeroUserCell.h
//  NewApp
//
//  Created by gxtc on 17/2/16.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootTableViewCell.h"
@interface SectionZeroUserCell : RootTableViewCell

@property (nonatomic,strong)UIScrollView * scrollView;

@property (nonatomic,strong)UIButton * loginBt;



@property (nonatomic,strong)UIImageView * userIconImage;
@property (nonatomic,strong)UILabel * nameLabel;
@property (nonatomic,strong)UIImageView * sex;
@property (nonatomic,strong)UILabel * lvLabel;
@property (nonatomic,strong)UILabel * todayReadLabel;
@property (nonatomic,strong)UILabel * totalReadLabel;

@property (nonatomic,strong)UILabel * IDLabel;

@property (nonatomic,strong)UIImageView * QRimage;

/**
 *添加富文本
 */
- (NSMutableAttributedString *)addAttributedText:(NSString *)str andArticleNum:(NSString *)num;
@end
