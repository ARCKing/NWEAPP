//
//  RootView.h
//  NewApp
//
//  Created by gxtc on 17/2/28.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootView : UIView




- (NSMutableAttributedString *)addAppandRootViewAttributedText:(NSString *)str andArticleNum:(NSString *)num
                                                     andColor1:(UIColor *)color1
                                                     andColor2:(UIColor *)color2;


/**viewLabelNew*/
- (UILabel * )addViewRootLabelNewWithFram:(CGRect)fram andBackGroundColor:(UIColor *)color1 andTextColor:(UIColor *)color2
                                  andFont:(NSUInteger)font andTitle:(NSString *)title
                       andNSTextAlignment:(NSTextAlignment)textAlignment;

/**viewButtonNew*/
- (UIButton *)addViewRootButtonNewFram:(CGRect)fram andImageName:(NSString * )imageName andTitle:(NSString *)title
                         andBackGround:(UIColor *)color1 andTitleColor:(UIColor *)color2 andFont:(CGFloat)font
                       andCornerRadius:(CGFloat)radius;
@end
