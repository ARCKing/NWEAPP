//
//  ImportArticleCell.m
//  NewApp
//
//  Created by gxtc on 2017/8/1.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "ImportArticleCell.h"

@interface ImportArticleCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addtime;


@property (nonatomic,strong)UILabel * maskLabel;

@end

@implementation ImportArticleCell

- (void)setModel:(ArticleListModel *)model{

    if ([model.state isEqualToString:@"1"]) {
        
        [self.maskLabel removeFromSuperview];
        
    }else  if ([model.state isEqualToString:@"0"]) {
    
        [self.contentView addSubview:self.maskLabel];
        
        self.maskLabel.text = @"正在审核";
        
    }else  if ([model.state isEqualToString:@"-1"]) {
        
        [self.contentView addSubview:self.maskLabel];
        
        self.maskLabel.text = @"审核失败";

    }


    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"img_loading.jpg"]];
    
    self.titleLabel.text = model.title;
    self.addtime.text = [self LabelFinallyTime:model.addtime];
    
}


- (UILabel *)maskLabel{

    if (!_maskLabel) {
        
        _maskLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenWith/4 + 20)];
        _maskLabel.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
        _maskLabel.text = @"正在审核";
        _maskLabel.textAlignment = NSTextAlignmentCenter;
        _maskLabel.textColor = [UIColor whiteColor];
    }
    return _maskLabel;
}


#pragma mark- 时间戳计算
- (NSString *)LabelFinallyTime:(NSString *)yetTime{
    
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
        
        date = [NSString stringWithFormat:@"%.f个月前",[MM floatValue]];
        
    }else if ([dd floatValue] >= 1) {
        
        date = [NSString stringWithFormat:@"%.f天前",[dd floatValue]];
        
    }else if ([hh floatValue] >= 1) {
        
        date = [NSString stringWithFormat:@"%.f小时前",[hh floatValue]];
        
    }else if ([mm floatValue] >= 1) {
        
        date = [NSString stringWithFormat:@"%.f分钟前",[mm floatValue]];
        
    }else {
        
        date = [NSString stringWithFormat:@"%.f秒前",newTime];
    }
    
    //    NSLog(@"%@",date);
    
    return date;
}

@end
