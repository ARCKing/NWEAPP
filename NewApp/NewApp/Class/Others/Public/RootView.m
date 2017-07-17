//
//  RootView.m
//  NewApp
//
//  Created by gxtc on 17/2/28.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "RootView.h"

@implementation RootView


- (UILabel * )addViewRootLabelNewWithFram:(CGRect)fram andBackGroundColor:(UIColor *)color1 andTextColor:(UIColor *)color2
                                  andFont:(NSUInteger)font andTitle:(NSString *)title
                       andNSTextAlignment:(NSTextAlignment)textAlignment{
    
    UILabel * label = [[UILabel alloc]initWithFrame:fram];
    label.textAlignment = textAlignment;
    label.textColor = color2;
    label.backgroundColor = color1;
    label.font = [UIFont systemFontOfSize:font];
    label.text = title;
    return label;
    
}


- (UIButton *)addViewRootButtonNewFram:(CGRect)fram andImageName:(NSString * )imageName andTitle:(NSString *)title
                         andBackGround:(UIColor *)color1 andTitleColor:(UIColor *)color2 andFont:(CGFloat)font
                       andCornerRadius:(CGFloat)radius{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = fram;
    button.backgroundColor = color1;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color2 forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    button.layer.cornerRadius = radius;
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    button.clipsToBounds = YES;
    
    return button;
}



- (NSMutableAttributedString *)addAppandRootViewAttributedText:(NSString *)str andArticleNum:(NSString *)num
                                                 andColor1:(UIColor *)color1
                                                 andColor2:(UIColor *)color2{
    
    NSMutableAttributedString * attributrdString1 = [[NSMutableAttributedString alloc]initWithString:str];
    NSMutableAttributedString * attributrdString2 = [[NSMutableAttributedString alloc]initWithString:num];
    
    
    NSRange range1 = [str rangeOfString:str];
    NSRange range2 = [num rangeOfString:num];
    
    [attributrdString1 addAttribute:NSForegroundColorAttributeName value:color1 range:NSMakeRange(0, range1.length)];
    
    [attributrdString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, range1.length)];
    
    [attributrdString2 addAttribute:NSForegroundColorAttributeName value:color2 range:NSMakeRange(0,range2.length)];
    [attributrdString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, range2.length)];
    
    
    [attributrdString1 appendAttributedString:attributrdString2];
    
    return attributrdString1;
}



@end
