//
//  SystemMessageCell.m
//  NewApp
//
//  Created by gxtc on 17/2/20.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "SystemMessageCell.h"

#define rowHight ScreenWith/7

@interface SystemMessageCell()

@property (nonatomic,strong)UIImageView * iconImageView;

@property (nonatomic,strong)UILabel * titlesLabel;

@property (nonatomic,strong)UILabel * detailLabel;

@property (nonatomic,strong)UILabel * dateLabel;

@end

@implementation SystemMessageCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addUI];
        
    }
    
    return self;
}



- (void)setModel:(systemMessageModel *)model{

    self.titlesLabel.text = model.title;
    [self.titlesLabel sizeToFit];
    
    self.detailLabel.text = model.content;
    self.dateLabel.text = [self cellFinallyTime:model.ptime ];

}

- (void)addUI{

    UIImageView * icon = [[UIImageView alloc]initWithFrame:CGRectMake(15, rowHight/4, rowHight/2, rowHight/2)];
    [self.contentView addSubview:icon];
    self.iconImageView = icon;
    icon.image = [UIImage imageNamed:@"SYmessage"];
    
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(15 + rowHight/2 + 5,rowHight/2 - 15,ScreenWith/2,15)];
    title.textColor = [UIColor blackColor];
    [self.contentView addSubview:title];
    title.font = [UIFont systemFontOfSize:13];
    [title setTextColor:[UIColor blackColor]];
    self.titlesLabel = title;
    
    UILabel * detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(15 + rowHight/2 + 5,rowHight/2 +5 ,ScreenWith * 2/3,15)];
    detailLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:detailLabel];
    detailLabel.font = [UIFont systemFontOfSize:11];
    [detailLabel setTextColor:[UIColor lightGrayColor]];
    self.detailLabel = detailLabel;
    
    UILabel * dateLabel =  [[UILabel alloc]initWithFrame:CGRectMake(ScreenWith - ScreenWith/4 - 5,rowHight/2 - 10,ScreenWith/4,10)];
    dateLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:dateLabel];
    dateLabel.font = [UIFont systemFontOfSize:10];
    [dateLabel setTextColor:[UIColor lightGrayColor]];
    self.dateLabel = dateLabel;

    
    title.text = @"春节假期打款通知";
    detailLabel.text = @"是的放大师傅的师傅的还是教科书的粉红色的健康和监控记录";
    dateLabel.text = @"2017-01-22 15:32:07";
    
       
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
