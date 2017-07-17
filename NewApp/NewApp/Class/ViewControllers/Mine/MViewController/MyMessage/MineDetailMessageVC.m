//
//  MineDetailMessageVC.m
//  NewApp
//
//  Created by gxtc on 17/2/20.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "MineDetailMessageVC.h"

@interface MineDetailMessageVC ()
@property (nonatomic,strong)UILabel * titlesLabel;

@property (nonatomic,strong)UILabel * detailLabel;

@property (nonatomic,strong)UILabel * dateLabel;

@property (nonatomic,strong)systemMessageModel * model;
@end

@implementation MineDetailMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addUI];
}

- (void)addUI{
    
    
    [self addNavBarNew];
    
    [self addLabelNew];
    
    [self messageNew];
}



- (void)messageNew{

    NetWork * net = [NetWork shareNetWorkNew];
    __weak MineDetailMessageVC * weakSelf = self;
    

    [net systemMessageDetailFromNetWithID:weakSelf.messageID];


    net.systemMessageDetailBK=^(NSString * code,NSString * message,NSString * str,NSArray * data,NSArray *data2){
    
        if ([code isEqualToString:@"1"]) {
            
            if (data.count > 0) {
            
                self.model = data[0];
                
                self.titleLabel.text = self.model.title;
                self.detailLabel.text = self.model.content;
                [self.detailLabel sizeToFit];
                
                NSString * TIME = [self articleTime:self.model.ptime];
                NSLog(@"%@",TIME);
                
                
                self.dateLabel.text = TIME;

            }
        }
    };

}


#pragma mark- 发布时间
- (NSString * )articleTime:(NSString *)times{
    
    NSString *str=times;//时间戳
    //    NSTimeInterval time=[str doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    NSTimeInterval time=[str doubleValue];
    
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * dateStr = [dateFormatter stringFromDate: detaildate];
    
    return dateStr;
    
    
}




- (void)addNavBarNew{
    
    self.navigationBarView = [self NavBarViewNew];
    self.navigationBarView.backgroundColor =[UIColor whiteColor];
    [self addTitleLabelNew];
    [self addLeftBarButtonNew];
    self.titleLabel.text = @"系统消息";
    [self addLineNew];
    
}


- (void)addLabelNew{


    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(15,64 + 10,ScreenWith/2,20)];
    title.textColor = [UIColor blackColor];
    [self.view addSubview:title];
    title.font = [UIFont systemFontOfSize:15];
    [title setTextColor:[UIColor blackColor]];
    self.titleLabel = title;
    
    
    UILabel * dateLabel =  [[UILabel alloc]initWithFrame:CGRectMake(15,64 + 10 + 20,ScreenWith/2,20)];
    dateLabel.textColor = [UIColor blackColor];
    [self.view addSubview:dateLabel];
    dateLabel.font = [UIFont systemFontOfSize:12];
    [dateLabel setTextColor:[UIColor lightGrayColor]];
    self.dateLabel = dateLabel;
    
    UILabel * detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,64 + 10 + 20 + 20,ScreenWith - 30,ScreenHeight/2)];
    detailLabel.textColor = [UIColor blackColor];
    [self.view addSubview:detailLabel];
    detailLabel.font = [UIFont systemFontOfSize:14];
    [detailLabel setTextColor:[UIColor lightGrayColor]];
    detailLabel.numberOfLines = 0;
    self.detailLabel = detailLabel;

    
    title.text = @"春节假期打款通知";
    detailLabel.text = @"是的放大师傅的师傅的还是教科书的粉红色的健康和监控记录是的放大师傅的师傅的还是教科书的粉红色的健康和监控记录";
    dateLabel.text = @"2017-01-22 15:32:07";

    [detailLabel sizeToFit];


}

@end
