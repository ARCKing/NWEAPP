//
//  AliPayWithDrawRecordCell.m
//  NewApp
//
//  Created by gxtc on 17/3/17.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "AliPayWithDrawRecordCell.h"

#define SCREEN_H [UIScreen mainScreen].bounds.size.height
#define SCREEN_W [UIScreen mainScreen].bounds.size.width

@interface AliPayWithDrawRecordCell()
@property(nonatomic,strong)UILabel * addtimeLabel;
@property(nonatomic,strong)UILabel * typeLabel;
@property(nonatomic,strong)UILabel * cashLabel;
@property(nonatomic,strong)UILabel * statuesLabel;


@property(nonatomic,strong)UIView * seprateLine;


@end

@implementation AliPayWithDrawRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.addtimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, ScreenWith/4, ScreenWith/7)];
        [self.contentView addSubview:self.addtimeLabel];
        self.addtimeLabel.font = [UIFont systemFontOfSize:13];
        self.addtimeLabel.textColor = [UIColor lightGrayColor];
        self.addtimeLabel.numberOfLines = 0;
        
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
     
        
        
        self.typeLabel.text = @"333";
        self.cashLabel.text = @"22";
        self.statuesLabel.text = @"ddd";
        
    }
    
    return self;
}


-(void)setModel:(withDrawCashRecordModel *)model{
    
    self.typeLabel.text = model.bank_name;
    self.cashLabel.text = model.cash_amount;
    self.statuesLabel.text = model.status;
    
    self.addtimeLabel.text = [self cellArticleTime:model.addtime];
    
    self.reasonLabel.text = [NSString stringWithFormat:@"原因:%@",model.note];
    self.reasonLabel.font = [UIFont systemFontOfSize:16];
    self.reasonLabel.textColor = [UIColor blackColor];

    if (self.isShow == YES) {
        
        self.reasonLabel.alpha = 1;
        
    }else{
        
        self.reasonLabel.alpha = 0;
        
    }
    
}


@end
