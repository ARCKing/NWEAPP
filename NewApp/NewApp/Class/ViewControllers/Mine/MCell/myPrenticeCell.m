//
//  myPrenticeCell.m
//  发发啦
//
//  Created by gxtc on 16/11/23.
//  Copyright © 2016年 gxtc. All rights reserved.
//

#import "myPrenticeCell.h"
#import "UIImageView+WebCache.h"
#define SCREEN_H [UIScreen mainScreen].bounds.size.height
#define SCREEN_W [UIScreen mainScreen].bounds.size.width

@interface myPrenticeCell()

@property(nonatomic,strong)UIImageView * imageV;

@property(nonatomic,strong)UILabel * nickNameLabel;
@property(nonatomic,strong)UILabel * levelLabel;

@property(nonatomic,strong)UIImageView * littleImageView;

@property(nonatomic,strong)UILabel * sumIncomeMoney;

@property(nonatomic,strong)UILabel * timeLabel;

@property(nonatomic,strong)UILabel * inviter_money;
@property(nonatomic,strong)UILabel * inviter_label;

@property(nonatomic,strong)UILabel * toTheAccount;
@end


@implementation myPrenticeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{


    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W/6, SCREEN_W/6)];
        self.imageV.center = CGPointMake(SCREEN_W/12 + 10, SCREEN_W/10);
        self.imageV.layer.cornerRadius = SCREEN_W/12;
        self.imageV.clipsToBounds = YES;
        [self.contentView addSubview:self.imageV];
        
        self.nickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.imageV.frame) + 15, 5, SCREEN_W/3, SCREEN_W/20)];
        self.nickNameLabel.textColor = [UIColor blackColor];
        self.nickNameLabel.font = [UIFont systemFontOfSize:16.0];
        
        [self.contentView addSubview:self.nickNameLabel];
        
        
        self.toTheAccount = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.nickNameLabel.frame) + 10, 8, SCREEN_W/7, SCREEN_W/28)];
        self.toTheAccount.textColor = [UIColor redColor];
        self.toTheAccount.font = [UIFont systemFontOfSize:10.0];
        self.toTheAccount.layer.borderWidth = 1.0;
        self.toTheAccount.layer.borderColor = [UIColor redColor].CGColor;
        self.toTheAccount.textAlignment = NSTextAlignmentCenter;
        self.toTheAccount.hidden = YES;
        [self.contentView addSubview:self.toTheAccount];

        
        
        
        self.levelLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.imageV.frame) + 15, CGRectGetMaxY(self.nickNameLabel.frame), SCREEN_W/7, SCREEN_W/15)];
        self.levelLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.levelLabel];
        self.levelLabel.textColor = [UIColor lightGrayColor];
        self.levelLabel.font = [UIFont systemFontOfSize:14];
        
        self.littleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.imageV.frame) + 15, ScreenWith/10 - ScreenWith/40, SCREEN_W/20, SCREEN_W/20)];
        [self.contentView addSubview:self.littleImageView];

        self.sumIncomeMoney = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.littleImageView.frame) + 10, SCREEN_W/5 - SCREEN_W/15, SCREEN_W/2, SCREEN_W/15)];
        
        self.sumIncomeMoney.center = CGPointMake(self.littleImageView.center.x + SCREEN_W/4 + SCREEN_W/25, self.littleImageView.center.y);
        
        self.sumIncomeMoney.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.sumIncomeMoney];
        self.sumIncomeMoney.textColor = [UIColor lightGrayColor];
        self.sumIncomeMoney.font = [UIFont systemFontOfSize:14];
        
        
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.imageV.frame)+15, ScreenWith/5 - ScreenWith/20 - 5, SCREEN_W *2/3, SCREEN_W/20)];
        self.timeLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.timeLabel];
        self.timeLabel.textColor = [UIColor lightGrayColor];
        self.timeLabel.font = [UIFont systemFontOfSize:14];
        
        UILabel * inviter_moneyLabel = [self addCellRootLabelNewWithFram:CGRectMake(ScreenWith - ScreenWith/3 - 10, ScreenWith/20, ScreenWith/3, ScreenWith/20) andBackGroundColor:[UIColor clearColor] andTextColor:[UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1.0] andFont:15.0 andTitle:@"邀请奖励" andNSTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:inviter_moneyLabel];
        self.inviter_label = inviter_moneyLabel;
        
        UILabel * inviter_money = [self addCellRootLabelNewWithFram:CGRectMake(ScreenWith - ScreenWith/4 - 10, CGRectGetMaxY(inviter_moneyLabel.frame)+5, ScreenWith/4, ScreenWith/20) andBackGroundColor:[UIColor clearColor] andTextColor:[UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1.0] andFont:15.0 andTitle:@"---" andNSTextAlignment:NSTextAlignmentRight];
        self.inviter_money = inviter_money;
        [self.contentView addSubview:inviter_money];

        
        self.imageV.image =[UIImage imageNamed:@"head_icon"];
        self.nickNameLabel.text = @"***";
        self.sumIncomeMoney.text = @"徒弟进贡:%@元";
        self.littleImageView.image = [UIImage imageNamed:@"zq"];

    }



    return self;

}


- (void)setModel:(FriendListModel *)model{

    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.headimgurl] placeholderImage:[UIImage imageNamed:@"head_icon"]];
    self.nickNameLabel.text = [NSString stringWithFormat:@"%@",model.phone];
//    self.levelLabel.text =[ NSString stringWithFormat:@"等级:%@",model.level];
    self.sumIncomeMoney.text = [NSString stringWithFormat:@"徒弟进贡:%@元",model.sum_money];
    self.inviter_money.text = [NSString stringWithFormat:@"%@",model.inviter_money];
    NSString * time = [self timeStringWitmAddTime:model.inputtime];
    self.timeLabel.text = [NSString stringWithFormat:@"注册时间:%@",time];
    
    
    
    if ([model.listType isEqualToString:@"2"]) {
        
        self.inviter_label.hidden = YES;
        self.inviter_money.hidden = YES;
        self.toTheAccount.hidden = YES;
        
        return;
    }
    
    self.inviter_label.hidden = NO;
    self.inviter_money.hidden = NO;
    
    if ([model.is_inviter_re isEqualToString:@"1"]) {
        self.toTheAccount.hidden = NO;
        self.toTheAccount.text = @"已到账";
    }else{
    
        self.toTheAccount.hidden = YES;
    }
    
    
    
}



- (NSString *)timeStringWitmAddTime:(NSString *)times{

    NSString *str=times;//时间戳
    //    NSTimeInterval time=[str doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    NSTimeInterval time=[str doubleValue];
    
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yy-MM-dd HH:mm"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];

    return currentDateStr;
}



@end
