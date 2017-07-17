//
//  MineOneTypeCell.m
//  NewApp
//
//  Created by gxtc on 17/2/14.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "MineOneTypeCell.h"

@interface MineOneTypeCell()

@property(nonatomic,strong)UILabel * headTitleLabel;
@property(nonatomic,strong)UILabel * LittleTitleLabel;
@property(nonatomic,strong)UIImageView * rightImageView;

@property(nonatomic,strong)UILabel * redHeigh;
@property(nonatomic,strong)UILabel * redHeigh_imge;


@property(nonatomic,strong)UILabel * shareCoin;
@property(nonatomic,strong)UILabel * sumCount;
@property(nonatomic,strong)UILabel * numCount;


@property(nonatomic,strong)UIView * heightView;

@property(nonatomic,strong)UILabel * normalPrice;
@end

@implementation MineOneTypeCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self addUI];
        
    }

    return self;
}


- (void)setArticleListModel:(ArticleListModel *)articleListModel{

    self.headTitleLabel.text = articleListModel.title;
    [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:articleListModel.thumb] placeholderImage:[UIImage imageNamed:@"img_loading.jpg"]];
    self.LittleTitleLabel.text = [NSString stringWithFormat:@"阅读:%@",articleListModel.view_count];
    
//    CGFloat price = [articleListModel.read_price floatValue];
    
    if ([articleListModel.height isEqualToString:@"1"]) {
        
//        self.redHeigh.hidden = NO;
        
//        self.LittleTitleLabel.hidden = YES;
//        self.normalPrice.hidden = YES;
        
//        self.heightView.hidden = NO;
        
        self.rightImageView.layer.borderWidth = 1.0;
        self.rightImageView.layer.borderColor = [UIColor redColor].CGColor;
        
        if (self.redHeigh_imge == nil) {
            
            UILabel * label = [self addCellRootLabelNewWithFram:CGRectMake(0, ScreenWith/4 - 15, ScreenWith/3, 15) andBackGroundColor:[UIColor redColor] andTextColor:[UIColor whiteColor] andFont:14.0 andTitle:@"高价任务" andNSTextAlignment:NSTextAlignmentCenter];
            self.redHeigh_imge = label;
            
            [self.rightImageView addSubview:label];
        }
        
        self.redHeigh_imge.hidden = NO;
        
        
        self.normalPrice.text = [NSString stringWithFormat:@"%@元/阅读",articleListModel.read_price];

        
        /*
        if (articleListModel.share_sum == nil) {
            
            articleListModel.share_sum = @"0";
        }
        
        self.shareCoin.text = [NSString stringWithFormat:@"分享+%@元",articleListModel.read_price];
    
        self.sumCount.text = [NSString stringWithFormat:@"共%@份",articleListModel.share_sum];
        
        
        CGFloat fontsize;
        
        NSInteger screenSize = CurrentDeviceScreen;
        
        if (screenSize == 0) {
            
            fontsize = 9.0;
            
        }else if (screenSize == 1){
            
            fontsize = 11.0;
            
        }else{
            fontsize = 12.0;
            
        }

        
        
        if (articleListModel.share_num == nil) {
            
            articleListModel.share_num = @"0";
        }
        
        self.numCount.attributedText = [self addCellInsertAttributedText1:@"剩余份" andText2:articleListModel.share_num andIndex:2 andColor1:[UIColor lightGrayColor] andColor2:[UIColor redColor] andFont2:fontsize andFont2:fontsize];
         */

        
        
    }else{
    
//        self.redHeigh.hidden = YES;
//        
//        self.LittleTitleLabel.hidden = NO;
//        self.normalPrice.hidden = NO;
//        
        self.heightView.hidden = YES;
        self.rightImageView.layer.borderWidth = 0.0;
        self.redHeigh_imge.hidden = YES;

        self.normalPrice.text = [NSString stringWithFormat:@"%@元/阅读",articleListModel.read_price];
        
    }
    
    
    
    if (self.isShareRecord) {
        
        self.normalPrice.hidden = YES;
        self.LittleTitleLabel.hidden = YES;
        
    }else{
    
        self.normalPrice.hidden = NO;
        self.LittleTitleLabel.hidden = NO;
    }
    
    
    
    
    
}




- (void)setPersonModel:(PersonCenterModel *)personModel{

    self.headTitleLabel.text = personModel.title;
    [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:personModel.thumb] placeholderImage:[UIImage imageNamed:@"key"]];
    self.LittleTitleLabel.text = [NSString stringWithFormat:@"阅读:%@",personModel.view_count];

}




- (void)addUI{

    UILabel * title1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, ScreenWith *2/3 - 30, ScreenWith/8)];
    title1.numberOfLines = 0;
    title1.textColor = [UIColor blackColor];
    title1.font = [UIFont systemFontOfSize:16];
    
    
    
    UILabel * title3 = [[UILabel alloc]initWithFrame:CGRectMake(10, ScreenWith/4 - 5, ScreenWith/3, 15)];
    title3.textColor = [UIColor redColor];
    title3.font = [UIFont systemFontOfSize:13];
    
    
    
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWith - ScreenWith/3 - 10, 10, ScreenWith/3, ScreenWith/4)];
    
    UILabel * title2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageV.frame) - 10 - ScreenWith/3, ScreenWith/4 - 5, ScreenWith/3, 15)];
    title2.textColor = [UIColor lightGrayColor];
    title2.font = [UIFont systemFontOfSize:13];
    title2.textAlignment = NSTextAlignmentRight;
    

//    title1.backgroundColor = [UIColor redColor];
//    title2.backgroundColor = [UIColor purpleColor];
//    imageV.backgroundColor = [UIColor orangeColor];
//    
    [self.contentView addSubview:title1];
    [self.contentView addSubview:title2];
    [self.contentView addSubview:title3];
    [self.contentView addSubview:imageV];

    
    self.headTitleLabel = title1;
    self.LittleTitleLabel = title2;
    self.rightImageView = imageV;
    self.normalPrice = title3;
    
    title1.text = @"收到公司大股东是广东省公司的收到广东省啊沙发上个人购房对方得分为丰富";
    title2.text = @"凤凰科技 阅读3872";
    title3.text = @"0.00元/阅读";
    imageV.image = [UIImage imageNamed:@"launchImage.jpg"];
    
    /*
    UILabel * readHeigh = [[UILabel alloc]initWithFrame:CGRectMake(1, 1, ScreenWith/5, 15)];
    readHeigh.backgroundColor =[ UIColor redColor];
    readHeigh.textColor = [UIColor whiteColor];
    readHeigh.text = @"高价任务";
    readHeigh.font = [UIFont systemFontOfSize:13.0];
    readHeigh.textAlignment = NSTextAlignmentCenter;
    readHeigh.hidden = YES;
    self.redHeigh = readHeigh;
    
    [self.contentView addSubview:readHeigh];
    
    
    UIView * heightView = [[UIView alloc]initWithFrame:CGRectMake(10, ScreenWith/4 + 20 - ScreenWith/20 - 12, ScreenWith *2/3 - 30, ScreenWith/18)];
    heightView.backgroundColor =[ UIColor whiteColor];
    heightView.hidden = YES;
    self.heightView = heightView;
    [self.contentView addSubview:heightView];
    
    
    CGFloat fontsize;
    
    NSInteger screenSize = CurrentDeviceScreen;
    
    if (screenSize == 0) {
        
        fontsize = 9.0;
        
    }else if (screenSize == 1){
        
        fontsize = 11.0;

    }else{
        fontsize = 12.0;

    }

    
    CGFloat f = ScreenWith *2/3 - 30;
    
    UILabel * coinLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, f/3, ScreenWith/18)];
    coinLabel.font = [UIFont systemFontOfSize:fontsize];
    coinLabel.textColor = [UIColor redColor];
    coinLabel.textAlignment = NSTextAlignmentCenter;
    coinLabel.backgroundColor = [UIColor whiteColor];
    coinLabel.text = @"分享+***金币";
    [heightView addSubview:coinLabel];
    self.shareCoin = coinLabel;
    
    
    
    UILabel * sumLabel = [[UILabel alloc]initWithFrame:CGRectMake(f/3, 0, f/3, ScreenWith/18)];
    sumLabel.font = [UIFont systemFontOfSize:fontsize];
    sumLabel.textColor = [UIColor lightGrayColor];
    sumLabel.textAlignment = NSTextAlignmentCenter;
    sumLabel.backgroundColor = [UIColor whiteColor];
    sumLabel.text = @"共10000份";
    [heightView addSubview:sumLabel];
    self.sumCount = sumLabel;
    
    UILabel * numLabel = [[UILabel alloc]initWithFrame:CGRectMake(f * 2/3, 0, f/3+5, ScreenWith/18)];
    numLabel.font = [UIFont systemFontOfSize:fontsize];
    numLabel.textColor = [UIColor lightGrayColor];
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.backgroundColor = [UIColor whiteColor];
    numLabel.text = @"剩余10000份";
    [heightView addSubview:numLabel];
    self.numCount = numLabel;
     */
    
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
