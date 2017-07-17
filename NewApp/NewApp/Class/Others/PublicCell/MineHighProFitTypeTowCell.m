//
//  MineHighProFitTypeTowCell.m
//  NewApp
//
//  Created by gxtc on 17/2/22.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "MineHighProFitTypeTowCell.h"

@interface MineHighProFitTypeTowCell()

@property(nonatomic,strong)UIImageView * iconImage;
@property(nonatomic,strong)UILabel * titleLabel;

@property(nonatomic,strong)UILabel * allCount;
@property(nonatomic,strong)UILabel * remainCount;

@property(nonatomic,strong)CAShapeLayer * shapeLayer;

@property(nonatomic,strong)UILabel * statue;

@end


@implementation MineHighProFitTypeTowCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addUI];
        
    }
    
    return self;
}


- (void)setHeightModel:(ArticleListModel *)heightModel{

    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:heightModel.thumb] placeholderImage:[UIImage imageNamed:@"img_loading.jpg"]];

    self.titleLabel.text = heightModel.title;

    self.allCount.text = [NSString stringWithFormat:@"共%@份",heightModel.share_num];
    self.remainCount.attributedText = [self addAttributedText:@"剩余份" andArticleNum:heightModel.share_count];
    [self.remainCount sizeToFit];
    
    CGFloat progress = [heightModel.share_count floatValue]/[heightModel.share_num floatValue];
    
    self.shapeLayer.strokeEnd = 1.0 - progress;
    
    
    if (progress >= 1.0) {
        
        self.statue.text = @"已结束";
        self.statue.backgroundColor = [UIColor lightGrayColor];
    }
    
    
    
}



- (void)addUI{
    
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, ScreenWith/3 - 10, ScreenWith/4)];
    self.iconImage = imageV;
    
    UILabel * title0 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWith/8, 15)];
    title0.textColor = [UIColor whiteColor];
    title0.font = [UIFont systemFontOfSize:10];
    title0.backgroundColor = [UIColor redColor];
    title0.textAlignment = NSTextAlignmentCenter;
    title0.text = @"进行中";
    [imageV addSubview:title0];

    self.statue = title0;
    
    UILabel * title1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame) + 5, 10, ScreenWith *2/3 - 20, ScreenWith/8)];
    title1.numberOfLines = 0;
    title1.textColor = [UIColor blackColor];
    title1.font = [UIFont systemFontOfSize:15];
    self.titleLabel = title1;
    
    UILabel * title2 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWith - ScreenWith/4 - 5, ScreenWith/4 - 15, ScreenWith/4, 15)];
    title2.textColor = [UIColor whiteColor];
    title2.font = [UIFont systemFontOfSize:12];
    title2.backgroundColor = [UIColor redColor];
    title2.textAlignment = NSTextAlignmentCenter;
    
    UILabel * title3 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame) + 5, CGRectGetMaxY(imageV.frame) - 15, ScreenWith/6, 15)];
    title3.textColor = [UIColor lightGrayColor];
    title3.font = [UIFont systemFontOfSize:12];
    
    self.allCount = title3;
    
    UILabel * title4 = [[UILabel alloc]initWithFrame:CGRectMake( CGRectGetMaxX(title3.frame) + 5, CGRectGetMaxY(imageV.frame) - 15, ScreenWith/6, 15)];
    title4.textColor = [UIColor lightGrayColor];
    title4.font = [UIFont systemFontOfSize:12];
    
    self.remainCount = title4;
    
    UIView * progressView = [self lineProgress:6000.0 andCurrentProgress:2150.0 andFram:CGRectMake(CGRectGetMaxX(imageV.frame)+5, CGRectGetMinY(title2.frame), ScreenWith/3, 4)];
    
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
    
    
    [self.contentView addSubview:title1];
    [self.contentView addSubview:title2];
    [self.contentView addSubview:title3];
    [self.contentView addSubview:title4];
    [self.contentView addSubview:imageV];
    [self.contentView addSubview:progressView];
    
    
    title1.text = @"收到三个号根据俄游客和美女不女空山东墨四面佛s施工规范地方发现";
    title2.text = @"+150金币";
    [title2 sizeToFit];

    title3.text = @"共5000份";
    title4.text = @"剩余354份";
    imageV.image = [UIImage imageNamed:@"launchImage.jpg"];
    
}

- (UIView *)lineProgress:(CGFloat)progress andCurrentProgress:(CGFloat)current andFram:(CGRect)fram{
    
    UIView * view = [[UIView alloc]initWithFrame:fram];
//    view.backgroundColor = [UIColor lightGrayColor];
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    CAShapeLayer * shape = [CAShapeLayer layer];
    
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, 0)];
    [bezierPath addLineToPoint:CGPointMake(ScreenWith/3, 0)];
    
    shape.position = CGPointMake(0.5, 1.5);
    shape.path = bezierPath.CGPath;
    shape.strokeColor = [UIColor redColor].CGColor;
    shape.fillColor = [UIColor clearColor].CGColor;
    shape.lineJoin = kCALineJoinRound;
    shape.strokeStart = 0.0;
    shape.strokeEnd = 0.0;
    shape.lineWidth = 3.0;
    
    [view.layer addSublayer:shape];
    
    self.shapeLayer = shape;
    
    return view;
}


- (NSMutableAttributedString *)addAttributedText:(NSString *)str andArticleNum:(NSString *)num{
    
    NSMutableAttributedString * attributrdString1 = [[NSMutableAttributedString alloc]initWithString:str];
    NSMutableAttributedString * attributrdString2 = [[NSMutableAttributedString alloc]initWithString:num];
    
    
    NSRange range1 = [str rangeOfString:str];
    NSRange range2 = [num rangeOfString:num];
    
    [attributrdString1 addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, range1.length)];
    
    [attributrdString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, range1.length)];
    
    [attributrdString2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,range2.length)];
    [attributrdString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, range2.length)];
    
    
    [attributrdString1 insertAttributedString:attributrdString2 atIndex:2];
    
    return attributrdString1;
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
