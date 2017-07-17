//
//  MineHighProfitCell.m
//  NewApp
//
//  Created by gxtc on 17/2/14.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "MineHighProfitCell.h"

@interface MineHighProfitCell()

@property(nonatomic,strong)UILabel * headTitleLabel;

@property(nonatomic,strong)UILabel * heighProfitLabel;
@property(nonatomic,strong)UILabel * redTextLabel;
@property(nonatomic,strong)UILabel * allTextLabel;
@property(nonatomic,strong)UILabel * remainTextLabel;

@property(nonatomic,strong)UIImageView * iconImageView;
@property(nonatomic,strong)UIImageView * rightImageView;

@end
@implementation MineHighProfitCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addUI];
        
    }
    
    return self;
}


- (void)addUI{
    
    UILabel * title0 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, 20)];
    title0.textColor = [UIColor whiteColor];
    title0.font = [UIFont systemFontOfSize:13];
    title0.backgroundColor = [UIColor redColor];
    title0.textAlignment = NSTextAlignmentCenter;
    title0.text = @"高价任务";
    
    UILabel * title1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, ScreenWith *2/3 - 20, ScreenWith/8)];
    title1.numberOfLines = 0;
    title1.textColor = [UIColor blackColor];
    title1.font = [UIFont systemFontOfSize:16];
    
    UIImageView * iconImageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, ScreenWith/4 - 15, 15, 15)];
    iconImageV.image = [UIImage imageNamed:@"money"];
    
    UILabel * title2 = [[UILabel alloc]initWithFrame:CGRectMake(25, ScreenWith/4 - 15, ScreenWith/4, 15)];
    title2.textColor = [UIColor redColor];
    title2.font = [UIFont systemFontOfSize:12];
    
    UILabel * title3 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWith/4 + 25, ScreenWith/4 - 15, ScreenWith/6, 15)];
    title3.textColor = [UIColor lightGrayColor];
    title3.font = [UIFont systemFontOfSize:12];
    
    UILabel * title4 = [[UILabel alloc]initWithFrame:CGRectMake( ScreenWith/4 + 25 + ScreenWith/6, ScreenWith/4 - 15, ScreenWith/6, 15)];
    title4.textColor = [UIColor lightGrayColor];
    title4.font = [UIFont systemFontOfSize:12];
    
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWith - ScreenWith/3, 10, ScreenWith/3 - 10, ScreenWith/4)];
    
    
//    title1.backgroundColor = [UIColor cyanColor];
//    title2.backgroundColor = [UIColor purpleColor];
//    title3.backgroundColor = [UIColor orangeColor];
//    title4.backgroundColor = [UIColor grayColor];
//    
    NSInteger device = CurrentDeviceScreen;
    if (device == 0) {
        
        title2.font = [UIFont systemFontOfSize:11];
        title3.font = [UIFont systemFontOfSize:10];
        title4.font = [UIFont systemFontOfSize:10];

    }
    
    
    [self.contentView addSubview:title0];
    [self.contentView addSubview:title1];
    [self.contentView addSubview:title2];
    [self.contentView addSubview:title3];
    [self.contentView addSubview:title4];
    [self.contentView addSubview:imageV];
    [self.contentView addSubview:iconImageV];

    
    
    title1.text = @"收到三个号根据俄游客和美女不女空山东墨四面佛s施工规范地方发现";
    title2.text = @"分享+150金币";
    title3.text = @"共5000份";
    title4.text = @"剩余354份";
    imageV.image = [UIImage imageNamed:@"launchImage.jpg"];
    
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
