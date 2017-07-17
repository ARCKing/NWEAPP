//
//  ExchangeRecordCell.m
//  NewApp
//
//  Created by gxtc on 17/3/14.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "ExchangeRecordCell.h"

#define SCREEN_H [UIScreen mainScreen].bounds.size.height
#define SCREEN_W [UIScreen mainScreen].bounds.size.width

@interface ExchangeRecordCell()
@property(nonatomic,strong)UILabel * addtimeLabel;
@property(nonatomic,strong)UILabel * typeLabel;
@property(nonatomic,strong)UILabel * cashLabel;
@property(nonatomic,strong)UILabel * statuesLabel;


@property(nonatomic,strong)UIView * seprateLine;

@end

@implementation ExchangeRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.addtimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
        self.addtimeLabel.center = CGPointMake(85, SCREEN_W/14);
        [self.contentView addSubview:self.addtimeLabel];
        self.addtimeLabel.font = [UIFont systemFontOfSize:15];
        self.addtimeLabel.textColor = [UIColor lightGrayColor];
        
        self.typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
        self.typeLabel.center = CGPointMake(SCREEN_W/2 - 30, SCREEN_W/14);
        [self.contentView addSubview:self.typeLabel];
        
        self.cashLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        self.cashLabel.center = CGPointMake(SCREEN_W/2 + 60, SCREEN_W/14);
        [self.contentView addSubview:self.cashLabel];
        self.cashLabel.textColor = [UIColor orangeColor];
        
        self.statuesLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
        self.statuesLabel.center = CGPointMake(SCREEN_W - 40 - 10, SCREEN_W/14);
        [self.contentView addSubview:self.statuesLabel];
        self.statuesLabel.textAlignment = NSTextAlignmentRight;
        self.statuesLabel.textColor = [UIColor orangeColor];
        
        //        self.seprateLine = [[UIView alloc]initWithFrame:CGRectMake(20, self.bounds.size.height - 0.5, SCREEN_W-20, 0.5)];
        //        [self.contentView addSubview:self.seprateLine];
        //        self.seprateLine.backgroundColor = [UIColor lightGrayColor];
        
        self.reasonLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, SCREEN_W/5 - SCREEN_W/20 - 5, SCREEN_W, SCREEN_W/20)];
        [self.contentView addSubview:self.reasonLabel];
        
        self.reasonImgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_W - 30, SCREEN_W/7 - 10, 10, 5)];
        self.reasonImgView.image = [UIImage imageNamed:@"download_albummore.png"];
        [self.contentView addSubview:self.reasonImgView];
        
        self.reasonImgView.alpha = 0;
        
    }
    
    return self;
}


- (void)setCashModel:(withDrawCashRecordModel *)cashModel{
    
    self.typeLabel.text = cashModel.bank_name;
    self.cashLabel.text = cashModel.cash_amount;
    self.statuesLabel.text = cashModel.status;
    
    NSString *str=cashModel.addtime;//时间戳
    //    NSTimeInterval time=[str doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    NSTimeInterval time=[str doubleValue];
    
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    self.addtimeLabel.text = currentDateStr;
    
    
    self.reasonLabel.text = [NSString stringWithFormat:@"原因:%@",cashModel.note];
    self.reasonLabel.font = [UIFont systemFontOfSize:16];
    self.reasonLabel.textColor = [UIColor blackColor];
    self.reasonLabel.alpha = 0;
    
    
}


@end
