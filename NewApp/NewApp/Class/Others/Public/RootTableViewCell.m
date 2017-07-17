//
//  RootTableViewCell.m
//  NewApp
//
//  Created by gxtc on 17/2/23.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "RootTableViewCell.h"

@implementation RootTableViewCell



- (NSMutableAttributedString *)addCellAppandRootAttributedText1:(NSString *)text1 andText2:(NSString *)text2
                                                 andColor1:(UIColor *)color1
                                                      andColor2:(UIColor *)color2
                                                       andFont2:(NSInteger)font1 andFont2:(NSInteger)font2{
    
    NSMutableAttributedString * attributrdString1 = [[NSMutableAttributedString alloc]initWithString:text1];
    NSMutableAttributedString * attributrdString2 = [[NSMutableAttributedString alloc]initWithString:text2];
    
    
    NSRange range1 = [text1 rangeOfString:text1];
    NSRange range2 = [text2 rangeOfString:text2];
    
    [attributrdString1 addAttribute:NSForegroundColorAttributeName value:color1 range:NSMakeRange(0, range1.length)];
    
    [attributrdString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font1] range:NSMakeRange(0, range1.length)];
    
    [attributrdString2 addAttribute:NSForegroundColorAttributeName value:color2 range:NSMakeRange(0,range2.length)];
    [attributrdString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font2] range:NSMakeRange(0, range2.length)];
    
    
    [attributrdString1 appendAttributedString:attributrdString2];
    
    return attributrdString1;
}



- (NSMutableAttributedString *)addCellInsertAttributedText1:(NSString *)text1 andText2:(NSString *)text2 andIndex:(NSUInteger)index andColor1:(UIColor *)color1
     andColor2:(UIColor *)color2 andFont2:(NSInteger)font1 andFont2:(NSInteger)font2{
    
    NSMutableAttributedString * attributrdString1 = [[NSMutableAttributedString alloc]initWithString:text1];
    NSMutableAttributedString * attributrdString2 = [[NSMutableAttributedString alloc]initWithString:text2];
    
    
    NSRange range1 = [text1 rangeOfString:text1];
    NSRange range2 = [text2 rangeOfString:text2];
    
    [attributrdString1 addAttribute:NSForegroundColorAttributeName value:color1 range:NSMakeRange(0, range1.length)];
    
    [attributrdString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font1] range:NSMakeRange(0, range1.length)];
    
    [attributrdString2 addAttribute:NSForegroundColorAttributeName value:color2 range:NSMakeRange(0,range2.length)];
    [attributrdString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font2] range:NSMakeRange(0, range2.length)];
    
    
    [attributrdString1 insertAttributedString:attributrdString2 atIndex:index];
    
    return attributrdString1;
}



- (UILabel * )addCellRootLabelNewWithFram:(CGRect)fram andBackGroundColor:(UIColor *)color1 andTextColor:(UIColor *)color2
                                  andFont:(NSUInteger)font andTitle:(NSString *)title
                       andNSTextAlignment:(NSTextAlignment)textAlignment{
    
    UILabel * label = [[UILabel alloc]initWithFrame:fram];
    label.textAlignment = textAlignment;
    label.textColor = color2;
    label.backgroundColor = color1;
    label.font = [UIFont systemFontOfSize:font];
    label.text = title;
    label.numberOfLines = 0;
    return label;
    
}


#pragma mark- 时间戳计算
- (NSString *)cellFinallyTime:(NSString *)yetTime{
    
    NSDate * nowDate = [NSDate date];
    
    NSTimeInterval now = [nowDate timeIntervalSince1970];
    NSTimeInterval yet = [yetTime doubleValue];
    
    //    NSLog(@"yet = %.f",yet);
    //    NSLog(@"now = %.f",now);
    
    
    NSTimeInterval newTime = now - yet;
    //    NSLog(@"new = %.f",newTime);
    
    NSString * mm = [NSString stringWithFormat:@"%.2f",newTime/60];
    NSString * hh = [NSString stringWithFormat:@"%.2f",newTime/60/60];
    NSString * dd = [NSString stringWithFormat:@"%.2f",newTime/60/60/24];
    NSString * MM = [NSString stringWithFormat:@"%.2f",newTime/60/60/24/30];
    
    
    //    NSLog(@"mm =%@",mm);
    //    NSLog(@"hh =%@",hh);
    //    NSLog(@"dd =%@",dd);
    //    NSLog(@"MM =%@",MM);
    
    NSString * date;
    
    if ([MM floatValue] >= 1) {
        
        date = [NSString stringWithFormat:@"发布于%.f个月前",[MM floatValue]];
        
    }else if ([dd floatValue] >= 1) {
        
        date = [NSString stringWithFormat:@"发布于%.f天前",[dd floatValue]];
        
    }else if ([hh floatValue] >= 1) {
        
        date = [NSString stringWithFormat:@"发布于%.f小时前",[hh floatValue]];
        
    }else if ([mm floatValue] >= 1) {
        
        date = [NSString stringWithFormat:@"发布于%.f分钟前",[mm floatValue]];
        
    }else {
        
        date = [NSString stringWithFormat:@"发布于%.f秒前",newTime];
    }
    
    //    NSLog(@"%@",date);
    
    return date;
}


- (UIButton *)addCellRootButtonNewFram:(CGRect)fram andImageName:(NSString * )imageName andTitle:(NSString *)title
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



#pragma mark- 时间计算
/**时间戳计算*/
- (NSString * )cellArticleTime:(NSString *)times{
    
    NSString *str=times;//时间戳
    //    NSTimeInterval time=[str doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    NSTimeInterval time=[str doubleValue];
    
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yy-MM-dd HH:mm:ss"];
    NSString * dateStr = [dateFormatter stringFromDate: detaildate];
    
    return dateStr;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
