//
//  RootTableViewCell.h
//  NewApp
//
//  Created by gxtc on 17/2/23.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootTableViewCell : UITableViewCell


/**
 *Cell富文本拼接
 */
- (NSMutableAttributedString *)addCellAppandRootAttributedText1:(NSString *)text1 andText2:(NSString *)text2
                                                      andColor1:(UIColor *)color1
                                                      andColor2:(UIColor *)color2
                                                       andFont2:(NSInteger)font1 andFont2:(NSInteger)font2;

/**
 *Cell富文本插入
 */
- (NSMutableAttributedString *)addCellInsertAttributedText1:(NSString *)text1 andText2:(NSString *)text2 andIndex:(NSUInteger)index andColor1:(UIColor *)color1 andColor2:(UIColor *)color2 andFont2:(NSInteger)font1 andFont2:(NSInteger)font2;

/**
 *Cell文本New
 */
- (UILabel * )addCellRootLabelNewWithFram:(CGRect)fram andBackGroundColor:(UIColor *)color1 andTextColor:(UIColor *)color2
                                  andFont:(NSUInteger)font andTitle:(NSString *)title
                       andNSTextAlignment:(NSTextAlignment)textAlignment;

/**时间戳计算*/
- (NSString *)cellFinallyTime:(NSString *)yetTime;



/**按钮创建*/
- (UIButton *)addCellRootButtonNewFram:(CGRect)fram andImageName:(NSString * )imageName andTitle:(NSString *)title
                         andBackGround:(UIColor *)color1 andTitleColor:(UIColor *)color2 andFont:(CGFloat)font
                       andCornerRadius:(CGFloat)radius;


#pragma mark- 时间计算
/**时间戳计算*/
- (NSString * )cellArticleTime:(NSString *)times;

@end
