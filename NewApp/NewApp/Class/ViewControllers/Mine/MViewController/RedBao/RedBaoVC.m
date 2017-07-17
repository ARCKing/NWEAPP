//
//  RedBaoVC.m
//  NewApp
//
//  Created by gxtc on 2017/6/8.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "RedBaoVC.h"

@interface RedBaoVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray * dataArray;

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong)UIView * headView;


@property(nonatomic,strong)UIImageView * icon;

@property(nonatomic,strong)UILabel * money;

@property(nonatomic,strong)UILabel * num;

@property(nonatomic,assign)BOOL getFinish;
@property(nonatomic,assign)BOOL shareLimit;

@property(nonatomic,strong)RedBaoModel * redModel;

@property(nonatomic,strong)UIView * redV;

@property(nonatomic,strong)UIView * messageV;

@end

@implementation RedBaoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataArray = [NSMutableArray new];
    
    [self addUI];
    
    
    [self getRedBaoMessageFromNet];
    
    
    
}



/**红包信息*/
- (void)getRedBaoMessageFromNet{

    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NetWork * net = [NetWork shareNetWorkNew];
    [net userRedBaoMessage];

    __weak RedBaoVC * weakSelf = self;
    
    net.RedBaoMessageBK = ^(NSString *code, NSString *message, NSString *str, NSArray *dataArray1, NSArray *arr) {
        
        [hud hideAnimated:YES];
        
        if ([code isEqualToString:@"1"]) {
            
            if (dataArray1.count > 0) {
                
                RedBaoModel * model = dataArray1[0];
                
                weakSelf.redModel = model;
                
                if ([model.is_red isEqualToString:@"1"]) {
                    
                    weakSelf.getFinish = YES;
                    
                }else{
                
                    weakSelf.getFinish = NO;
                }
                
                
                CGFloat share_money = [model.share_money floatValue];
                
                CGFloat limit = [model.limit floatValue];
                
                
                if (share_money > limit) {
                
                    weakSelf.shareLimit = YES;
                    
                }else{
                
                    weakSelf.shareLimit = NO;
                }
                
                
                
                [weakSelf.icon sd_setImageWithURL:[NSURL URLWithString:model.headimgurl] placeholderImage:[UIImage imageNamed:@"head_icon"]];
                
                weakSelf.money.text = [NSString stringWithFormat:@"%@元",model.sum_money];
                weakSelf.num.text = [NSString stringWithFormat:@"%@个",model.num];
                
                weakSelf.dataArray = [NSMutableArray arrayWithArray:dataArray1];
                
                [weakSelf.tableView reloadData];
            }
        }
        
        
        
        
    };
}


/**领取红包*/
- (void)getRedBaoFromNet{

    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    NetWork * net = [NetWork shareNetWorkNew];
    [net getRedBao];
    __weak RedBaoVC * weakSelf = self;

    net.GetRedBaoBK = ^(NSString *code, NSString *message, NSString *amount, NSArray * data1, NSArray *data2) {
        
        [hud hideAnimated:YES];
        
        NSLog(@"%@,%@,%@",code,message,amount);
        
        
        
        if ([code isEqualToString:@"1"]) {
            
            [self showRedBaoWithMessage:message];
            
        }else{
        
            [weakSelf rootShowMBPhudWith:message andShowTime:1.5];

        }
        
        
    };
}



- (void)addUI{
    
    [super addUI];
    self.titleLabel.text = @"红包";
    self.titleLabel.textColor = [UIColor whiteColor];
    
    self.navigationBarView.backgroundColor = [UIColor colorWithRed:0.0 green:191.0/255.0 blue:1.0 alpha:1.0];
    [self.leftNavBarButton setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    
    [self addTableViewNew];
}


#pragma mark- 红包展示
- (void)showRedBaoWithMessage:(NSString * )message{

//task_finish_red

    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenHeight)];
    view.backgroundColor = [UIColor colorWithRed:169.0/255.0 green:169.0/255.0 blue:169.0/255.0 alpha:0.8];
    self.redV = view;
    
    
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith*3/4, ScreenWith*3/4)];
    imageV.center = CGPointMake(ScreenWith/2, ScreenWith*2/3);
    imageV.image =[ UIImage imageNamed:@"task_finish_red"];
    imageV.userInteractionEnabled = YES;
    
    [view addSubview:imageV];
    
    UILabel * labrl = [self addRootLabelWithfram:CGRectMake(0, 0, ScreenWith/2, ScreenWith/15) andTitleColor:[UIColor whiteColor] andFont:16.0 andBackGroundColor:[UIColor clearColor] andTitle:message];
    labrl.center = CGPointMake(ScreenWith*3/8, ScreenWith/2);
    [imageV addSubview:labrl];
    labrl.textAlignment = NSTextAlignmentCenter;
    
    UIButton * bt = [self addRootButtonNewFram:CGRectMake(0, 0, ScreenWith/4, ScreenWith/12) andSel:@selector(dissmissRedBao) andTitle:@"确定"];
    bt.layer.borderColor = [UIColor orangeColor].CGColor;
    bt.layer.borderWidth = 1.0;
    bt.layer.cornerRadius = 1.0;
    bt.center = CGPointMake(ScreenWith*3/8, ScreenWith/2 + ScreenWith/12);
    
    [imageV addSubview:bt];
    
    
    [self.view addSubview:view];
}



- (void)dissmissRedBao{

    [self.redV removeFromSuperview];

}


- (void)addTableViewNew{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWith, ScreenHeight - 64) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    tableView.rowHeight = ScreenWith/2 + 15;
    
    tableView.tableFooterView = [[UIView alloc]init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.tableHeaderView = self.headView;
    
    self.tableView = tableView;
    
    [self.view addSubview:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RedBaoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        
        cell = [[RedBaoCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    if (self.getFinish) {
        
        cell.getFinish = YES;
    }
    
    RedBaoModel * model = self.dataArray[indexPath.row];
    
    cell.model = model;
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSLog(@"抽红包!");

    if (self.getFinish) {
        
        return;
    }
    
    if (self.shareLimit) {
        
        [self getRedBaoFromNet];

    }else{
    
        [self showThemessage];
    }
    
    
    

    
    
}


- (UIView *)headView{

    if (!_headView) {
        
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenWith/5 + ScreenWith/14 + ScreenWith/15+ScreenWith/10 + 1 + ScreenWith/10)];
        _headView.backgroundColor = [UIColor whiteColor];
        
        UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenWith/3)];
        imageV.image = [UIImage imageNamed:@"icon_red"];
        [_headView addSubview:imageV];
        
        
        UIImageView * icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith/7, ScreenWith/7)];
        icon.center = CGPointMake(ScreenWith/2, ScreenWith/5);
        icon.image = [UIImage imageNamed:@"head_icon"];
        [_headView addSubview:icon];
        icon.layer.cornerRadius = ScreenWith/14;
        icon.clipsToBounds = YES;
        
        UILabel * label = [self addRootLabelWithfram:CGRectMake(0, CGRectGetMaxY(icon.frame), ScreenWith, ScreenWith/15) andTitleColor:[UIColor blackColor] andFont:15.0 andBackGroundColor:[UIColor clearColor] andTitle:@"我的红包"];
        label.textAlignment = NSTextAlignmentCenter;
        [_headView addSubview:label];
        
        UILabel * money = [self addRootLabelWithfram:CGRectMake(0, CGRectGetMaxY(label.frame), ScreenWith, ScreenWith/10) andTitleColor:[UIColor redColor] andFont:20.0 andBackGroundColor:[UIColor clearColor] andTitle:@"0.00元"];
        money.textAlignment = NSTextAlignmentCenter;
        [_headView addSubview:money];
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(money.frame), ScreenWith, 1)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_headView addSubview:line];
        
        
        UILabel * num1 = [self addRootLabelWithfram:CGRectMake(0, CGRectGetMaxY(line.frame), ScreenWith/2, ScreenWith/10) andTitleColor:[UIColor lightGrayColor] andFont:15.0 andBackGroundColor:[UIColor clearColor] andTitle:@"抢红包数:"];
        num1.textAlignment = NSTextAlignmentRight;
        [_headView addSubview:num1];

        
        UILabel * num2 = [self addRootLabelWithfram:CGRectMake(ScreenWith/2, CGRectGetMaxY(line.frame), ScreenWith/2, ScreenWith/10) andTitleColor:[UIColor redColor] andFont:15.0 andBackGroundColor:[UIColor clearColor] andTitle:@"  0个"];
        num2.textAlignment = NSTextAlignmentLeft;
        [_headView addSubview:num2];

        
        self.icon = icon;
        self.money = money;
        self.num = num2;
    }
    
    
    return _headView;
}



- (void)showThemessage{

    
    
    RedBaoModel * model = self.redModel;
    
    UIView * BGview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenHeight)];
    BGview.backgroundColor = [UIColor colorWithRed:109.0/255.0 green:109.0/255.0 blue:109.0/255.0 alpha:0.8];

    self.messageV = BGview;
    
    UIView * white = [[UIView alloc]initWithFrame:CGRectMake(30, ScreenWith*2/3, ScreenWith - 60, ScreenWith*2/3)];
    white.backgroundColor = [UIColor whiteColor];
    white.layer.cornerRadius = 2.0;
    
    
    
    UILabel * label1 = [self addRootLabelWithfram:CGRectMake(0, 0, ScreenWith-60, ScreenWith/8) andTitleColor:[UIColor blackColor] andFont:20.0 andBackGroundColor:[UIColor clearColor] andTitle:@"抢红包要求"];
    label1.textAlignment = NSTextAlignmentCenter;
    
    
    NSString * day = [NSString stringWithFormat:@"当天转发收入>%@元",model.limit];
    
    UILabel * label2 = [self addRootLabelWithfram:CGRectMake(10, ScreenWith/8, ScreenWith-80, ScreenWith/10) andTitleColor:[UIColor blackColor] andFont:15.0 andBackGroundColor:[UIColor clearColor] andTitle:day];
    label2.textAlignment = NSTextAlignmentLeft;

    NSString * day2 = [NSString stringWithFormat:@"%@,才能抢改红包(您当天的转发收入为%@元,加油哦)",day,model.share_money];
    
    
    UILabel * label3 = [self addRootLabelWithfram:CGRectMake(10, CGRectGetMaxY(label2.frame), ScreenWith-80, ScreenWith/8) andTitleColor:[UIColor lightGrayColor] andFont:15.0 andBackGroundColor:[UIColor clearColor] andTitle:day2];
    
    
    label3.numberOfLines = 0;
    label3.textAlignment = NSTextAlignmentLeft;

    UIButton * bt = [self addRootButtonTypeTwoNewFram:CGRectMake(15, CGRectGetMaxY(label3.frame) + ScreenWith/20, ScreenWith-90, ScreenWith/7) andImageName:nil andTitle:@"转发赚钱" andBackGround:[UIColor redColor] andTitleColor:[UIColor whiteColor] andFont:15.0 andCornerRadius:2.0];
    [bt addTarget:self action:@selector(earnMoneyAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    //ScreenWith-60 - ScreenWith/10, 0
    UIButton * xx = [self addRootButtonTypeTwoNewFram:CGRectMake(ScreenWith - 30 - ScreenWith/20, ScreenWith*2/3 -ScreenWith/20, ScreenWith/10, ScreenWith/10) andImageName:nil andTitle:@"X" andBackGround:[UIColor blackColor] andTitleColor:[UIColor whiteColor] andFont:15.0 andCornerRadius:ScreenWith/20];
    [xx addTarget:self action:@selector(xxBtAction) forControlEvents:UIControlEventTouchUpInside];
    
    [BGview addSubview:white];
    [white addSubview:label1];
    [white addSubview:label2];
    [white addSubview:label3];
    [white addSubview:bt];
    
    [BGview addSubview:xx];
    
    [self.view addSubview:BGview];

    
}


- (void)xxBtAction{


    [self.messageV removeFromSuperview];

}

- (void)earnMoneyAction{

    self.tabBarController.selectedIndex = 0;
    
    [self.navigationController popViewControllerAnimated:YES];

}
@end
