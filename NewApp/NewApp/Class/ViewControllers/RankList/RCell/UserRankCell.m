//
//  UserRankCell.m
//  NewApp
//
//  Created by gxtc on 17/2/16.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "UserRankCell.h"

@interface UserRankCell()

@property (nonatomic,strong)UIImageView * iconImageView;
@property (nonatomic,strong)UILabel * userNamelabel;
@property (nonatomic,strong)UILabel * redLabe;

@end

@implementation UserRankCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addUI];
        
    }
    
    return self;
}



-(void)setDataWithModel:(UserRankModel * )model andType:(NSInteger)type andHidenReview:(BOOL)hiden{

    self.userNamelabel.text =[NSString stringWithFormat:@"%@",model.name];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.headimgurl] placeholderImage:[UIImage imageNamed:@"head_icon"]];
    
    if (type == userRankType_read) {
        
        if (model.share_count == nil) {
            
            model.share_count = @"0";
        }
        
        
        self.redLabe.text = [NSString stringWithFormat:@"%@阅读",model.share_count];
        
    }else if (type == userRankType_share){
    
        if (model.read_count == nil) {
            
            model.read_count = @"0";
        }
        
        
        self.redLabe.text = [NSString stringWithFormat:@"%@分享",model.read_count];

    }else{
    
        
        if (model.sum_money == nil) {
            
            model.sum_money = @"0";
        }
        
        
        if (hiden == YES) {
            self.redLabe.text = [NSString stringWithFormat:@"%@",@""];

        }else{
            
            self.redLabe.text = [NSString stringWithFormat:@"%@收入",model.sum_money];
        }
    
    }

}


- (void)addUI{
    
    UILabel * number = [[UILabel alloc]initWithFrame:CGRectMake(10, ScreenWith/10 - ScreenWith/40, ScreenWith / 20, ScreenWith / 20)];
    number.textAlignment = NSTextAlignmentCenter;
    number.layer.cornerRadius = 2.0;
    number.clipsToBounds = YES;
    number.textColor = [UIColor whiteColor];
    number.font = [UIFont systemFontOfSize:13];

    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10 + ScreenWith/20 + 10, ScreenWith/10 - ScreenWith/20, ScreenWith/10, ScreenWith/10)];
    imageV.layer.cornerRadius = ScreenWith/20;
    imageV.clipsToBounds = YES;
    
    UILabel * name = [[UILabel alloc]initWithFrame:CGRectMake(10 + ScreenWith/20 + ScreenWith/10 + 20, ScreenWith/10 - 10, ScreenWith/3, 20)];
    name.font = [UIFont systemFontOfSize:15];
    
    UILabel * red = [[UILabel alloc]initWithFrame:CGRectMake( ScreenWith - ScreenWith/4 - 10, ScreenWith/10 - 10, ScreenWith/4, 20)];
    red.font = [UIFont systemFontOfSize:15];
    red.textColor = [UIColor redColor];
    red.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:number];
    [self.contentView addSubview:imageV];
    [self.contentView addSubview:name];
    [self.contentView addSubview:red];
    
    self.numberRankLabel = number;
    self.iconImageView = imageV;
    self.userNamelabel = name;
    self.redLabe = red;
    
    number.text = @"1";
    number.backgroundColor = [UIColor redColor];
    imageV.image = [UIImage imageNamed:@"launchImage.jpg"];
    name.text = @"159****4712";
    red.text = @"25000分享";
    
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
