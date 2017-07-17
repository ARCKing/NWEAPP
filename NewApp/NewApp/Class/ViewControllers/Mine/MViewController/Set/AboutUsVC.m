//
//  AboutUsVC.m
//  NewApp
//
//  Created by gxtc on 17/3/14.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "AboutUsVC.h"

@interface AboutUsVC ()

@property (nonatomic,strong)UILabel * label1;
@property (nonatomic,strong)UILabel * label2;
@property (nonatomic,strong)UIImageView * icon;

@end

@implementation AboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self addUI];
    
    [self usDataMessage];
}


-(void)usDataMessage{

    NetWork * net = [NetWork shareNetWorkNew];

    [net aboutUsMessageFromNet];
    
    __weak AboutUsVC * weakSelf = self;
    
    net.aboutUsBK= ^(NSString * code,NSString * message,NSString * str, NSArray * dataArray,NSArray * data){
    
    
        if (dataArray.count > 0) {
            
            AboutUsModel * model = dataArray[0];
            
            NSLog(@"%@",model);
            
//            [weakSelf.icon sd_setImageWithURL:[NSURL URLWithString:model.logo]];
            
            weakSelf.label1.text = model.content;
            [weakSelf.label1 sizeToFit];
            
            
            weakSelf.label2.frame = CGRectMake(20, CGRectGetMaxY(weakSelf.label1.frame) + 5, ScreenWith - 40, 10);
            weakSelf.label2.text = [NSString stringWithFormat:@"客服QQ:%@\n",model.kf_qq];
            [weakSelf.label2 sizeToFit];
            
        }
        
    };

}


- (void)addUI{

    [super addUI];

    self.titleLabel.text = @"关于我们";
    
    
    UIImageView * icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith/6, ScreenWith/6)];
    icon.center = CGPointMake(ScreenWith/2, 64 + ScreenWith/12 + 15);
    icon.image = [UIImage imageNamed:@"icon_180"];
    self.icon = icon;
    
    UILabel * contentLabel = [self addRootLabelWithfram:CGRectMake(20, CGRectGetMaxY(icon.frame) + 20, ScreenWith - 40, 10) andTitleColor:[UIColor blackColor] andFont:15.0 andBackGroundColor:[UIColor clearColor] andTitle:@"***"];
    self.label1 = contentLabel;
    contentLabel.numberOfLines = 0;
    
     UILabel * nextLabel = [self addRootLabelWithfram:CGRectMake(20, CGRectGetMaxY(contentLabel.frame) + 20, ScreenWith - 40, 10) andTitleColor:[UIColor blackColor] andFont:14.0 andBackGroundColor:[UIColor clearColor] andTitle:@"***"];
    self.label2 = nextLabel;
    nextLabel.numberOfLines = 0;
    
    [self.view addSubview:icon];
    [self.view addSubview:contentLabel];
    [self.view addSubview:nextLabel];
    
}





@end
