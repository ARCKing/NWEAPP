//
//  WithDrawVC.m
//  NewApp
//
//  Created by gxtc on 2017/5/22.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "WithDrawVC.h"

@interface WithDrawVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>


@property (nonatomic,strong)UIView * line;

@property (nonatomic,strong)UILabel * currentMoneyLabel;
@property (nonatomic,strong)UILabel * todayIncomeLabel;
@property (nonatomic,strong)UILabel * allIncomeLabel;


@property (nonatomic,strong)UIButton * bt1;
@property (nonatomic,strong)UIButton * bt2;
@property (nonatomic,strong)UIButton * bt3;


@property (nonatomic,strong)NSMutableArray * dataArray1;
@property (nonatomic,strong)NSMutableArray * dataArray2;
@property (nonatomic,strong)NSMutableArray * dataArray3;


@property (nonatomic,assign)NSInteger type;


//=============
@property (nonatomic,strong)UIView * tableHeadView;

@property (nonatomic,strong)UITableView * tableView;

@property(nonatomic,assign)NSInteger currentIndexRow;
@property(nonatomic,assign)NSInteger lastIndexRow;

@property(nonatomic,retain)ExchangeRecordCell * cell;
@property(nonatomic,retain)ExchangeRecordCell * LastCell;

@property(nonatomic,strong)NSMutableArray * cashRecordArray;

@property (nonatomic,assign)NSInteger page;

@property(nonatomic,assign)BOOL isRefresh;

@property (nonatomic,assign)BOOL isOpen;

@property (nonatomic,strong)UIView * unLoginView;


@end

@implementation WithDrawVC


- (void)viewDidAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self getMineDataFromnet];

    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * dic = [defaults objectForKey:@"userInfo"];
    
    NSLog(@"------------------->%@",dic);
    
    if ([dic[@"login"] isEqualToString:@"1"]) {
        
        [self.unLoginView removeFromSuperview];
        
        
    }else{
        
        [self addLoginViewNewWithTitle:@"钱包中心"];
        
    }
    
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.page = 1;    
    self.currentIndexRow = 10110;
    self.lastIndexRow = 10110;
    
    self.type = 0;
    
    [self addUI];
}


- (void)addUI{
    
    self.navigationBarView = [self NavBarViewNew];
    self.navigationBarView.backgroundColor =[UIColor colorWithRed:0.0/255.0 green:191.0/255.0 blue:255.0/255.0 alpha:1.0];

    [self addTitleLabelNew];
    [self addLineNew];
    self.titleLabel.text = @"钱包中心";
    self.titleLabel.textColor = [UIColor whiteColor];
    
    [self headViewCreatNew];
    [self tableViewCreatNew];
    
}

- (void)addLoginViewNewWithTitle:(NSString *)title{
    
    
    if (self.unLoginView ) {
        
        [self.view addSubview:self.unLoginView];
        
        return;
    }
    
    UIView * BGview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenHeight - 49)];
    BGview.backgroundColor = [UIColor whiteColor];
    self.unLoginView = BGview;
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, 64)];
    titleLabel.backgroundColor = [UIColor colorWithRed:0 green:191.0/255.0 blue:1.0 alpha:1.0];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [BGview addSubview:titleLabel];
    
    UIImageView * imagev = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_un_login"]];
    imagev.frame = CGRectMake(ScreenWith/4, ScreenWith/4, ScreenWith/3, ScreenWith/4);
    imagev.center = CGPointMake(ScreenWith/2,ScreenWith/2 + ScreenWith/4);
    [BGview addSubview:imagev];
    
    UIButton * bt = [self addRootButtonNewFram:CGRectMake(0, 0, ScreenWith/5, ScreenWith/10) andSel:@selector(goToLogin) andTitle:@"点我登录"];
    bt.center = CGPointMake(ScreenWith/2, ScreenWith);
    bt.layer.cornerRadius = 3.0;
    bt.layer.backgroundColor = [UIColor clearColor].CGColor;
    bt.layer.borderWidth = 1.0;
    bt.layer.borderColor = [UIColor colorWithRed:0 green:191.0/255.0 blue:1.0 alpha:1.0].CGColor;
    
    [BGview addSubview:bt];
    
    [self.view addSubview:BGview];
    
    
    
}


-(void)goToLogin{
    LoginViewController * vc = [[LoginViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}





- (void)getMineDataFromnet{

    
   BOOL netOK = [self RootCurrentNetState];
    
    
    if (netOK == NO) {
        
        
    }else{
    
        NetWork * net = [NetWork shareNetWorkNew];
    
        [net getMineDataSource];
    
        __weak WithDrawVC * weakSelf = self;
        
        net.mineDataSourceBK = ^(NSString * code, NSString * message, NSString * str, NSArray * dataArray, NSArray * arr) {
        
            if ([code isEqualToString:@"1"]) {
            
                if (dataArray.count > 0) {
                
                    MineDataSourceModel * model = dataArray[0];
                
                    weakSelf.currentMoneyLabel.text = [NSString stringWithFormat:@"余额:%@元",model.residue_money];
                }
            }
        };

    }
}



- (void)MJ_refreshData{
    
    self.isRefresh = YES;
    self.page = 1;
    
    [self aliPayWithDrawRecordFromNetWithPage:self.page];
    
}


- (void)MJ_loadMoreData{
    
    self.isRefresh = NO;
    self.page ++;
    
    [self aliPayWithDrawRecordFromNetWithPage:self.page];
}


- (void)aliPayWithDrawRecordFromNetWithPage:(NSInteger)page{
    
    
    BOOL netOK = [self RootCurrentNetState];
    
    
    if (netOK == NO) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

        return;
    }
    
    
    NetWork * net = [NetWork shareNetWorkNew];
    [net AliPayWithDrawRecordWithPage:page];
    
    __weak WithDrawVC * weakSelf = self;
    
    net.aliPayWithDrawRecordBK=^(NSString * code,NSString * message,NSString * str,NSArray * dataArray,NSArray * array){
        
        
        if (self.isRefresh) {
        
            if (dataArray.count > 0) {
                
                weakSelf.cashRecordArray = [NSMutableArray arrayWithArray:dataArray];
                [weakSelf.tableView.mj_header endRefreshing];
                
                [weakSelf.tableView reloadData];
            
            }else{
            
                [weakSelf.tableView.mj_header endRefreshing];

            
            }
        
            
            
        }else{
        
            if (dataArray.count > 0) {
                
                
                [weakSelf.cashRecordArray addObjectsFromArray:dataArray];
                
                [weakSelf.tableView.mj_footer endRefreshing];

                [weakSelf.tableView reloadData];

            }else{
            
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];

            
            }
        }

    };
    
    
    net.netFailBK = ^{
      
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        
        [weakSelf rootShowMBPhudWith:@"网络请求超时！" andShowTime:1.0];
        
    };
    
    
}

- (void)headViewCreatNew{

    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenWith, ScreenWith/7+ ScreenWith/10 + ScreenWith/9)];
    view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    [self.view addSubview:view];
    
    UIView * BGview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenWith/10 + ScreenWith/9 +ScreenWith/7)];
    BGview.backgroundColor = [UIColor whiteColor];
    
    [view addSubview:BGview];
    
//    ic_cash_image
    
    UIImageView * imagev = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_cash_image"]];
    imagev.frame = CGRectMake(0, 0, ScreenWith/7, ScreenWith/7);
    imagev.center = CGPointMake(ScreenWith/2,ScreenWith/14);
    [BGview addSubview:imagev];
    
    UILabel * label = [self addRootLabelWithfram:CGRectMake(0, ScreenWith/7, ScreenWith, ScreenWith/10) andTitleColor:[UIColor lightGrayColor] andFont:20.0 andBackGroundColor:[UIColor clearColor] andTitle:@"余额 -- 元"];
    [BGview addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    self.currentMoneyLabel = label;
    
    
    UIButton * weiChatBt = [self addRootButtonTypeTwoNewFram:CGRectMake(40, CGRectGetMaxY(label.frame), (ScreenWith - 80 - 20)/2, ScreenWith/9) andImageName:nil andTitle:@"微信提现" andBackGround:[UIColor clearColor] andTitleColor:[UIColor colorWithRed:60.0/255.0 green:179.0/255.0 blue:133.0/255.0 alpha:1.0] andFont:16.0 andCornerRadius:5.0];
    weiChatBt.tag = 11111;
    [weiChatBt setImage:[UIImage imageNamed:@"wx_icon"] forState:UIControlStateNormal];
    weiChatBt.layer.borderWidth = 1.0;
    weiChatBt.layer.borderColor = [UIColor colorWithRed:60.0/255.0 green:179.0/255.0 blue:133.0/255.0 alpha:1.0].CGColor;
    
    
    UIButton * aliPayBt = [self addRootButtonTypeTwoNewFram:CGRectMake(CGRectGetMaxX(weiChatBt.frame)+20, CGRectGetMaxY(label.frame), (ScreenWith - 80 - 20)/2, ScreenWith/9) andImageName:nil andTitle:@"支付宝提现" andBackGround:[UIColor clearColor] andTitleColor:[UIColor colorWithRed:0.0/255.0 green:191.0/255.0 blue:255.0/255.0 alpha:1.0] andFont:16.0 andCornerRadius:5.0];
    
    aliPayBt.layer.borderWidth = 1.0;
    aliPayBt.layer.borderColor = [UIColor colorWithRed:0.0/255.0 green:191.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor;

    [BGview addSubview:weiChatBt];
    [BGview addSubview:aliPayBt];
    aliPayBt.tag = 22222;
    [aliPayBt setImage:[UIImage imageNamed:@"zfb_icon"] forState:UIControlStateNormal];
    
    [weiChatBt addTarget:self action:@selector(weiChatPayAndAliPayButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [aliPayBt addTarget:self action:@selector(weiChatPayAndAliPayButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    /*
    UILabel * label1 = [self addRootLabelWithfram:CGRectMake(0, CGRectGetMaxY(weiChatBt.frame) + ScreenWith / 10, ScreenWith/2, ScreenWith/10) andTitleColor:[UIColor lightGrayColor] andFont:15.0 andBackGroundColor:[UIColor clearColor] andTitle:@"今日收益"];
   
    UILabel * label2 = [self addRootLabelWithfram:CGRectMake(0, CGRectGetMaxY(label1.frame), ScreenWith/2, ScreenWith/15) andTitleColor:[UIColor lightGrayColor] andFont:15.0 andBackGroundColor:[UIColor clearColor] andTitle:@"--元"];
    self.todayIncomeLabel = label2;
    
    UILabel * label3 = [self addRootLabelWithfram:CGRectMake(ScreenWith/2, CGRectGetMaxY(weiChatBt.frame)+ ScreenWith / 10, ScreenWith/2, ScreenWith/10) andTitleColor:[UIColor lightGrayColor] andFont:15.0 andBackGroundColor:[UIColor clearColor] andTitle:@"累计收益"];

    UILabel * label4 = [self addRootLabelWithfram:CGRectMake(ScreenWith/2, CGRectGetMaxY(label3.frame), ScreenWith/2, ScreenWith/15) andTitleColor:[UIColor lightGrayColor] andFont:15.0 andBackGroundColor:[UIColor clearColor] andTitle:@"--元"];
    self.allIncomeLabel = label4;
    
    
    label1.textAlignment = NSTextAlignmentCenter;
    label2.textAlignment = NSTextAlignmentCenter;
    label3.textAlignment = NSTextAlignmentCenter;
    label4.textAlignment = NSTextAlignmentCenter;

    [BGview addSubview:label1];
    [BGview addSubview:label2];
    [BGview addSubview:label3];
    [BGview addSubview:label4];

    */
    
  
    
    
    /*
    NSArray * title = @[@"收入明细",@"收徒明细",@"提现明细"];
    
    for (int i = 0 ;i < 3 ;i ++) {
        
        UIButton * button  = [self addRootButtonTypeTwoNewFram:CGRectMake(ScreenWith/3 * i, 0, ScreenWith/3, ScreenWith/9) andImageName:nil andTitle:title[i] andBackGround:[UIColor clearColor] andTitleColor:[UIColor lightGrayColor] andFont:15.0 andCornerRadius:0.0];
        [threeBtView addSubview:button];
        button.tag = 10000 + i;
        
        if (i == 0) {
            
            self.bt1 = button;
            
        }else if ( i == 1){
            
            self.bt2 = button;

        }else if ( i == 2){
            
            self.bt3 = button;

        }
        
        
        
    }
    
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenWith/9 - 2, ScreenWith/3, 2)];
    line.backgroundColor = [UIColor redColor];
    [threeBtView addSubview:line];
    self.line = line;
    
     */
    
}




- (void)tableHeadViewCreatNew{
    
    
    self.tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenWith/8)];
    self.tableHeadView.backgroundColor = [UIColor whiteColor];
    
    
    UILabel * timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, ScreenWith/4-10, ScreenWith/8)];
    timeLabel.text = @"时间";
    timeLabel.textColor = [UIColor blackColor];
    timeLabel.backgroundColor = [UIColor whiteColor];
    [self.tableHeadView addSubview:timeLabel];
    
    UILabel * modeLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWith/4, 0, ScreenWith/4, ScreenWith/8)];
    
    modeLabel.text = @"方式";
    modeLabel.textColor = [UIColor blackColor];
    [self.tableHeadView addSubview:modeLabel];
    modeLabel.backgroundColor = [UIColor whiteColor];
    modeLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel * cashLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWith/2 + ScreenWith/16, 0, ScreenWith/4, ScreenWith/8)];
    
    cashLabel.text = @"金额(元)";
    cashLabel.textColor = [UIColor blackColor];
    [self.tableHeadView addSubview:cashLabel];
    cashLabel.backgroundColor = [UIColor whiteColor];
    
    UILabel * stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWith -ScreenWith/4 + 30 - 10, 0, ScreenWith/4 -30, ScreenWith/8)];
    [self.tableHeadView addSubview:stateLabel];
    stateLabel.text = @"状态";
    stateLabel.textColor = [UIColor blackColor];
    stateLabel.backgroundColor = [UIColor whiteColor];
    stateLabel.textAlignment = NSTextAlignmentRight;
    
    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, ScreenWith/8, ScreenWith, 1)];
    line.backgroundColor =[UIColor lightGrayColor];
    [self.tableHeadView addSubview:line];
    
    
}






- (void)weiChatPayAndAliPayButtonAction:(UIButton *)bt{

    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * dic = [defaults objectForKey:@"userInfo"];
    
    if (![dic[@"login"] isEqualToString:@"1"]) {
    
        [self goToLogin];
        return;
    }
    
    
    
    if (bt.tag == 11111) {
        
    
        [self weiXinBangDingStatus];
        
        
    }else if (bt.tag == 22222){
        
        WeiXinAndAliPayWithDrawVC * vc = [[WeiXinAndAliPayWithDrawVC alloc]init];

        vc.isWeiXinPay = NO;
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }

    
    


}

// 空白页的背景色
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIColor whiteColor];
}

////设置空白页
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"icon_noD"];
}

//设置垂直位置
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{

    return -ScreenWith/3;

}


// 是否 允许点击,默认是YES
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView{
    return YES;
}


// 点击中间的图片和文字时调用
- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView{
    NSLog(@"点击了view");
    
    [self.tableView.mj_header beginRefreshing];
}


// 返回可以点击的按钮 上面带文字
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f],NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    return [[NSAttributedString alloc] initWithString:@"点我刷新" attributes:attribute];
}

// 处理按钮的点击事件
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    
    [self.tableView.mj_header beginRefreshing];

}

// 标题文本，富文本样式
//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
//    NSString *text = @"点击刷新";
//    
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
//                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
//    
//    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
//}


////自定义图
//- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
//
//    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
//    
//    UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith/4, ScreenWith/4)];
//    image.image = [UIImage imageNamed:@"icon_noD"];
//    
//    UILabel * label = [self addRootLabelWithfram:CGRectMake(0, ScreenWith/4, ScreenWith, ScreenWith/15) andTitleColor:[UIColor lightGrayColor] andFont:15.0 andBackGroundColor:[UIColor clearColor] andTitle:@"点击刷新"];
//    [view addSubview:image];
//    [view addSubview:label];
//    return view;
//}



#pragma mark- tableViewCreat
- (void)tableViewCreatNew{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64 + ScreenWith/10 + ScreenWith/9 + ScreenWith/7, ScreenWith, ScreenHeight - 64) style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.rowHeight = ScreenWith/7;
    
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJ_refreshData)];
    
    MJRefreshAutoNormalFooter * foot = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(MJ_loadMoreData)];
    
    foot.stateLabel.hidden=YES;
    
    self.tableView.mj_footer = foot;
    
    [self.tableView.mj_header beginRefreshing];
    
}


#pragma mark- tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.cashRecordArray.count;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cell_id = @"cell_id";
    
    AliPayWithDrawRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (cell == nil) {
        cell = [[AliPayWithDrawRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell_id"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    withDrawCashRecordModel * model = self.cashRecordArray[indexPath.row];
    
    if ([model.note isEqualToString:@""]) {
        
        cell.reasonImgView.alpha = 0;
    }else{
        
        cell.reasonImgView.alpha = 1;
        
    }
    
    cell.model= model;
    
    return cell;
    
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    withDrawCashRecordModel * model = self.cashRecordArray[indexPath.row];
    
    if ([model.note isEqualToString:@""]) {
        
        return;
    }
    
    
    
    ExchangeRecordCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
    
    self.currentIndexRow = indexPath.row;
    
    if (cell.isShow == YES) {
        
        cell.isShow = !cell.isShow;
        
        cell.reasonLabel.alpha = 0;
        
        
        cell.reasonImgView.transform = CGAffineTransformIdentity;
        
        self.isOpen = NO;
        
        
    }else{
        
        cell.isShow = !cell.isShow;
        
        self.isOpen = YES;
        
        
        [UIView animateWithDuration:1 animations:^{
            cell.reasonLabel.alpha = 1;
            
        }];
        
        
        cell.reasonImgView.transform = CGAffineTransformIdentity;
        
        cell.reasonImgView.transform = CGAffineTransformMakeRotation(M_PI);
        
    }
    
    
    if (self.LastCell && self.LastCell != cell) {
        
        if (self.LastCell.isShow) {
            
            self.LastCell.reasonLabel.alpha = 0;
            
            self.LastCell.isShow = NO;
            
            self.LastCell.reasonImgView.transform = CGAffineTransformIdentity;
            
        }
        
    }
    
    
    self.LastCell = cell;
    
    
    [tableView beginUpdates];
    [tableView endUpdates];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    withDrawCashRecordModel * model = self.cashRecordArray[indexPath.row];
    
    
    
    if (self.currentIndexRow == indexPath.row) {
        
        
        if ((self.lastIndexRow == self.currentIndexRow || [model.note isEqualToString:@""])&& self.isOpen == NO) {
            
            self.lastIndexRow = 10000;
            
            return ScreenWith/7;
            
        }else if (self.isOpen == NO && self.lastIndexRow == 10000){
            
            return ScreenWith/7;
            
        }else{
            
            self.lastIndexRow = self.currentIndexRow;
            
            return ScreenWith/5;
        }
        
    }else{
        
        return ScreenWith/7;
    }
    
}


#pragma mark- 分组高度
//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
          return ScreenWith/8;//section头部高度
    
    
}


//section头部视图
- (UIView * )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    if (self.tableHeadView == nil) {
        
        [self tableHeadViewCreatNew];
    }
    
    return self.tableHeadView; ;
    
    
}


//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return 0.1;
    
}

//section底部视图
- (UIView * )tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
       UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWith, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
    
}



#pragma mark- 授权检测
- (void)weiXinBangDingStatus{
    
    __weak WithDrawVC * weakSelf = self;
    
    NetWork * net = [[NetWork alloc]init];
    
    [net NetBindWeiChatAccountFinishProgress];
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //bind, wxbind, exchange_publicno,
    net.bindWeiChatAccountFinishProgressBK = ^(NSString * bind, NSString * wxbind, NSString * exchange_publicno, NSArray * data1, NSArray * data2) {
        
        [hud hideAnimated:YES];
        
        NSLog(@"%@=%@=%@",bind,wxbind,exchange_publicno);
        
        if ([bind isEqualToString:@"1"] && [wxbind isEqualToString:@"1"]) {
        
        
            WeiXinAndAliPayWithDrawVC * vc = [[WeiXinAndAliPayWithDrawVC alloc]init];
            vc.isWeiXinPay = YES;
            
            weakSelf.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            weakSelf.hidesBottomBarWhenPushed = NO;
            
        }else{
        
            [weakSelf showAlterWithMessage:@"请先授权绑定微信账号才能提现"];
            
        }
        
       
        
    };
    
}



- (void)showAlterWithMessage:(NSString * )message{
    
    UIAlertView * alter = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:message delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"去授权", nil];
    
    [alter show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
        NSLog(@"去授权");
        
        BindWeChatAccountVC * vc = [[BindWeChatAccountVC alloc]init];
        
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else{
        
        NSLog(@"放弃");
        
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}



@end
