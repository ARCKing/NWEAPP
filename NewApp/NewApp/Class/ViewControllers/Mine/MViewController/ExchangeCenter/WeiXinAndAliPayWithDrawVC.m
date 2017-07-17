//
//  WeiXinAndAliPayWithDrawVC.m
//  微信支付宝UI
//
//  Created by gxtc on 17/3/29.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "WeiXinAndAliPayWithDrawVC.h"


@interface WeiXinAndAliPayWithDrawVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong)UISegmentedControl * weixinsegmented;
@property (nonatomic,strong)UISegmentedControl * alipaysegmented;

@property (nonatomic,strong)NSMutableArray * moneyDataArray;

@property (nonatomic,copy)NSString * nicekName;
@property (nonatomic,copy)NSString * aliPayAccount;
@property (nonatomic,copy)NSString * appPassWorld;

@property (nonatomic,copy)NSString * weixinmoneyCount;
@property (nonatomic,copy)NSString * alipaymoneyCount;


@property (nonatomic,strong)UITextField * nickNameField;
@property (nonatomic,strong)UITextField * aliPayAccountField;
@property (nonatomic,strong)UITextField * appPassWorldField;

@property (nonatomic,strong)UILabel * currentMoneyLabel;

@property (nonatomic,strong)UITableView * weiXinTableView;
@property (nonatomic,strong)UITableView * aliPayTableView;

@property (nonatomic,strong)UIView * navView;

@property (nonatomic,strong)NSMutableArray * aliCashArray;
@property (nonatomic,strong)NSMutableArray * weiXinCashArray;


@property (nonatomic,strong)MBProgressHUD * HUD;
@property (nonatomic,strong)NetWork * net;

@property (nonatomic,strong)UIView * redV;

@end

@implementation WeiXinAndAliPayWithDrawVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor whiteColor];
    
    NetWork * net = [[NetWork alloc]init];
    self.net = net;
    
    [self addUI];
    
    }



- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    if (self.isWeiXinPay) {
        
        
        
    }else{
        
        
    }

}



- (void)addUI{
    
    self.navigationBarView = [self NavBarViewNew];
    self.navigationBarView.backgroundColor =[UIColor whiteColor];
    [self addTitleLabelNew];
    [self addLineNew];
    [self addLeftBarButtonNew];
    self.titleLabel.text = @"钱包中心";
    

    if (self.isWeiXinPay) {
    
        self.weiXinTableView = [self tableViewNew];
        self.weiXinTableView.tag = 336699;
        
        [self.weiXinTableView.mj_header beginRefreshing];
        
    }else{
    
        self.aliPayTableView = [self tableViewNew];
        
        self.aliPayTableView.tag = 996633;
        
        [self.aliPayTableView.mj_header beginRefreshing];

    }
    
    
}


- (void)rightBarClearButtonAction{
    
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * dic = [defaults objectForKey:@"userInfo"];
    
    if (![dic[@"login"] isEqualToString:@"1"]) {

        LoginViewController * vc = [[LoginViewController alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    }else{
    
        AliPayWithDrawRecordVC * vc = [[AliPayWithDrawRecordVC alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}


#pragma mark- 微信支付宝金额数量
- (void)getWeiChatAndAliPayCashFromNetWithType:(NSString *)type{
    
    
    [self.net NetWeiChatAndAliPayCashNumberWithType:type];
    
    __weak WeiXinAndAliPayWithDrawVC * weakSelf = self;
    
    self.net.WeiChatAndAliPayCashNumberBK = ^(NSString * code, NSString *message, NSString *type, NSArray * cashArray, NSArray * data) {
        
        
        if (cashArray.count > 0) {
            
            
            if ([type isEqualToString:@"0"]) {
                
                weakSelf.weiXinCashArray = [NSMutableArray arrayWithArray:cashArray];
                
                weakSelf.isWeiXinPay = YES;
                
                
                [weakSelf.weiXinTableView reloadData];
                
                
                [weakSelf.view addSubview:weakSelf.weiXinTableView];
                
                [weakSelf.aliPayTableView removeFromSuperview];
                
            }else if([type isEqualToString:@"1"]){
                
                weakSelf.aliCashArray = [NSMutableArray arrayWithArray:cashArray];
                
                weakSelf.isWeiXinPay = NO;
                
                [weakSelf.aliPayTableView reloadData];
                
                
                [weakSelf.view addSubview:weakSelf.aliPayTableView];
                [weakSelf.weiXinTableView removeFromSuperview];


            }
            
            
        }
        
        /*
        if (![code isEqualToString:@"1"] && (weakSelf.isWeiXinPay == YES)) {
            
            
            [weakSelf showAlterWithMessage:message];
        }
        */
        [weakSelf.weiXinTableView.mj_header endRefreshing];
        [weakSelf.aliPayTableView.mj_header endRefreshing];
        
    };
    
}






#pragma mark- MJReloadData
/**下拉刷新*/
- (void)MJReloadData{
    
    
    if (self.isWeiXinPay) {
        
        [self getWeiChatAndAliPayCashFromNetWithType:@"0"];
        
    }else{
    
        [self getWeiChatAndAliPayCashFromNetWithType:@"1"];

    }
    
    
}



- (UISegmentedControl *)addSegmentedControlNewWithLabel:(UILabel *)titleLabel{
    
    
    //    NSArray * titleArray = @[@"30",@"50",@"100",@"200"];
    //
    //    self.moneyDataArray = [NSMutableArray arrayWithArray:titleArray];
    
    
    if (self.isWeiXinPay) {
    
        self.moneyDataArray = [NSMutableArray arrayWithArray:self.weiXinCashArray];
        
        self.weixinmoneyCount = self.weiXinCashArray[0];
        
    }else{
    
        self.moneyDataArray = [NSMutableArray arrayWithArray:self.aliCashArray];
        
        self.alipaymoneyCount = self.aliCashArray[0];
    }
    
    
    
    UISegmentedControl * segment = [[UISegmentedControl alloc]initWithItems:self.moneyDataArray];
    
    segment.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame),(ScreenWith/6 - ScreenWith/13)/2, (ScreenWith * 2/3), ScreenWith/13);
    
    segment.selectedSegmentIndex = 0;
    segment.tintColor = [UIColor colorWithRed:0.0 green:217.0/255.0 blue:225.0/255.0 alpha:1.0];
    [segment addTarget:self action:@selector(segmentedSelect:) forControlEvents:UIControlEventValueChanged];
    return segment;
}

- (void)segmentedSelect:(UISegmentedControl *)segmented{
    
    NSInteger index = segmented.selectedSegmentIndex;
    
    if (self.isWeiXinPay) {
        self.weixinmoneyCount = self.weiXinCashArray[index];

    }else{
        self.alipaymoneyCount = self.aliCashArray[index];

    }
    
    
    
    [self outOfFistRspond];
}


#pragma mark- tableViewNew

- (UITableView *)tableViewNew{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, ScreenWith, ScreenHeight - 64) style:UITableViewStyleGrouped];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = ScreenWith/6;
    
    [self.view addSubview:tableView];
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJReloadData)];
    
    [tableView.mj_header beginRefreshing];
    
    return tableView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.isWeiXinPay) {
    
        AliPayCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell_one"];
        
        if (cell == nil) {
            cell = [[AliPayCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell_one"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        
        [[cell.contentView.subviews lastObject] removeFromSuperview];
    
        UILabel * label = [cell addCellRootLabelNewWithFram:CGRectMake(15, 0, ScreenWith/4, ScreenWith/6) andBackGroundColor:[UIColor whiteColor] andTextColor:[UIColor blackColor] andFont:15 andTitle:@"提现金额:" andNSTextAlignment:NSTextAlignmentLeft];
        [cell.contentView addSubview:label];

        
        UISegmentedControl * vc = [self addSegmentedControlNewWithLabel:label];
        self.weixinsegmented = vc;
        
        
        
        [cell.contentView addSubview:vc];
        
        return cell;

    }else{
    
        AliPayCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell_two"];
        
        if (cell == nil) {
            cell = [[AliPayCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell_two"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        
        [[cell.contentView.subviews lastObject] removeFromSuperview];

        
        
        NSArray * titleArray = @[@"姓名:",@"支付宝账号:",@"用户密码:",@"提现金额:"];
        NSArray * placeHolderArray = @[@"你的支付宝实名",@"你的支付宝账号",@"招财兔登录密码"];
    
    
        UILabel * label = [cell addCellRootLabelNewWithFram:CGRectMake(15, 0, ScreenWith/4, ScreenWith/6) andBackGroundColor:[UIColor whiteColor] andTextColor:[UIColor blackColor] andFont:15 andTitle:titleArray[indexPath.row] andNSTextAlignment:NSTextAlignmentLeft];
        [cell.contentView addSubview:label];
    
    
        if (indexPath.row != 3) {
        
            UITextField * field = [[UITextField alloc]initWithFrame:CGRectMake(ScreenWith/4 +10, 0, ScreenWith*3/4 - 10, ScreenWith/6)];
            field.placeholder = placeHolderArray[indexPath.row];
            field.font = [UIFont systemFontOfSize:15];
            field.delegate = self;
            field.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell.contentView addSubview:field];
        
            if (indexPath.row == 0) {
            
                self.nickNameField = field;
            
            }else if (indexPath.row == 1){
            
                self.aliPayAccountField = field;
            
            }else{
            
                field.secureTextEntry = YES;
                self.appPassWorldField = field;
            }
        }
    
        if (indexPath.row == 3) {
        
            UISegmentedControl * vc = [self addSegmentedControlNewWithLabel:label];
            self.alipaysegmented = vc;
            [cell.contentView addSubview:vc];
        }
        return cell;

    }
    
}




- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    
    NSLog(@"1==>%@",self.nickNameField.text);
    NSLog(@"2==>%@",self.aliPayAccountField.text);
    NSLog(@"3==>%@",self.appPassWorldField.text);
    
    self.nicekName = self.nickNameField.text;
    self.aliPayAccount = self.aliPayAccountField.text;
    self.appPassWorld = self.appPassWorldField.text;
    
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self outOfFistRspond];
    return YES;
}

- (void)outOfFistRspond{
    
    [self.nickNameField resignFirstResponder];
    [self.aliPayAccountField resignFirstResponder];
    [self.appPassWorldField resignFirstResponder];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.HUD hideAnimated:YES];

    
    [self outOfFistRspond];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.isWeiXinPay == YES) {
        return 1;
    }else{
    
        return 4;
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
    
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenWith/8)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIButton * aliPayBt = [self addRootButtonTypeTwoNewFram:CGRectMake(ScreenWith/2, 0, ScreenWith/2, ScreenWith/8) andImageName:@"zfbtx" andTitle:@"支付宝提现" andBackGround:[UIColor colorWithRed:0.0 green:150.0/255.0 blue:230.0/255.0 alpha:1] andTitleColor:[UIColor whiteColor] andFont:17.0 andCornerRadius:0.0];
    [aliPayBt addTarget:self action:@selector(aliPayWithDrawAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:aliPayBt];
    aliPayBt.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    
    
    UIButton * weiXinPayBt = [self addRootButtonTypeTwoNewFram:CGRectMake(0, 0, ScreenWith/2, ScreenWith/8) andImageName:@"wxtx" andTitle:@"微信提现" andBackGround:[UIColor colorWithRed:65.0/255.0 green:190.0/255.0 blue:30.0/255.0 alpha:1] andTitleColor:[UIColor whiteColor] andFont:17.0 andCornerRadius:0.0];
    [weiXinPayBt addTarget:self action:@selector(weixinWithDrawAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:weiXinPayBt];
    weiXinPayBt.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);

    
    if (self.isWeiXinPay) {
        
        aliPayBt.backgroundColor = [UIColor lightGrayColor];
    }else{
    
        weiXinPayBt.backgroundColor = [UIColor lightGrayColor];
    }
    
    
    
    return view ;
}


- (void)weixinWithDrawAction{

    NSLog(@"微信提现");
    
    self.isWeiXinPay = YES;
    
    
    [self weiXinBangDingStatus];


}

- (void)aliPayWithDrawAction{

    NSLog(@"支付宝提现");
    self.isWeiXinPay = NO;

    if (self.aliPayTableView == nil) {
        
        self.aliPayTableView = [self tableViewNew];
        self.aliPayTableView.tag = 996633;
        
    }else{
    
        [self.view addSubview:self.aliPayTableView];
        [self.weiXinTableView removeFromSuperview];
    }
}



//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    
    return ScreenHeight - 64 - ScreenWith/8 - ScreenWith/6 * 4;
    
}
//section底部视图
- (UIView * )tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenHeight/2)];
    view.backgroundColor = [UIColor clearColor];
    
    
    UILabel * titleLabel1 = [self addRootLabelWithfram:CGRectMake(20, 10, ScreenWith - 40, ScreenWith/10) andTitleColor:[UIColor lightGrayColor] andFont:14.0 andBackGroundColor:[UIColor clearColor] andTitle:@"*提现后将于24小时内日内到账"];
    
    
    UIButton * bt = [self addRootButtonTypeTwoNewFram:CGRectMake(20, CGRectGetMaxY(titleLabel1.frame) + 5, ScreenWith - 40, ScreenWith/10) andImageName:@"" andTitle:@"申请提现" andBackGround:[UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1] andTitleColor:[UIColor whiteColor] andFont:15.0 andCornerRadius:5.0];
    [bt addTarget:self action:@selector(AliPayWithDraw) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * titleLabel2 = [self addRootLabelWithfram:CGRectMake(20, CGRectGetMaxY(bt.frame) + 10, ScreenWith - 40, 0) andTitleColor:[UIColor redColor] andFont:13.0 andBackGroundColor:[UIColor clearColor] andTitle:@"注意!\n提现规则:\n1.为保证平台的公平性，所有提现申请都将进行人工审核;非正常佣金获取将被视为作弊行为,其提现申请将被拒绝\n2.为保障您的佣金安全，提现申请审核通过后，将通过人工处理第三方支付平台汇入到您的账户\n3.提现到账日期一般为24小时，遇到法定节假日顺延，请注意查询您的申请状态和支付宝账户"];
    titleLabel2.numberOfLines = 0;
    [titleLabel2 sizeToFit];
    
    [view addSubview:titleLabel1];
    [view addSubview:bt];
    [view addSubview:titleLabel2];
    
    
    return view;
}

- (UILabel *)addRootLabelWithfram:(CGRect)fram andTitleColor:(UIColor *)color andFont:(CGFloat)size andBackGroundColor:(UIColor *)backColor andTitle:(NSString *)text{
    
    UILabel * label = [[UILabel alloc]initWithFrame:fram];
    label.backgroundColor = backColor;
    label.textColor = color;
    label.text =  text;
    label.font = [UIFont systemFontOfSize:size];
    
    return label;
}


- (UIButton *)addRootButtonTypeTwoNewFram:(CGRect)fram andImageName:(NSString * )imageName andTitle:(NSString *)title
                            andBackGround:(UIColor *)color1 andTitleColor:(UIColor *)color2 andFont:(CGFloat)font
                          andCornerRadius:(CGFloat)radius{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = fram;
    button.backgroundColor = color1;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color2 forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    button.layer.cornerRadius = radius;
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    button.clipsToBounds = YES;
    
    return button;
}

- (NSMutableAttributedString *)addRootInsertAttributedText1:(NSString *)text1 andText2:(NSString *)text2 andIndex:(NSUInteger)index andColor1:(UIColor *)color1
                                                  andColor2:(UIColor *)color2 andFont1:(CGFloat)font1 andFont2:(CGFloat)font2{
    
    NSMutableAttributedString * attributrdString1 = [[NSMutableAttributedString alloc]initWithString:text1];
    NSMutableAttributedString * attributrdString2 = [[NSMutableAttributedString alloc]initWithString:text2];
    
    
    NSRange range1 = [text1 rangeOfString:text1];
    NSRange range2 = [text2 rangeOfString:text2];
    
    [attributrdString1 addAttribute:NSForegroundColorAttributeName value:color1 range:NSMakeRange(0, range1.length)];
    
    [attributrdString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font1] range:NSMakeRange(0, range1.length)];
    
    [attributrdString2 addAttribute:NSForegroundColorAttributeName value:color2 range:NSMakeRange(0,range2.length)];
    [attributrdString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font2] range:NSMakeRange(0, range2.length)];
    
    
    [attributrdString1 insertAttributedString:attributrdString2 atIndex:index];
    
    return attributrdString1;
}



- (void)AliPayWithDraw{
    
    
    [self outOfFistRspond];
    
    NSLog(@"申请提现");
  
    
    NSInteger tag ;
    NSString * cash;
    
    if (self.isWeiXinPay) {
        
        NSLog(@"%@",self.weixinmoneyCount);
        cash = self.weixinmoneyCount;
        
        tag = 8889;
    }else{
    
        
        NSLog(@"%@",self.nicekName);
        NSLog(@"%@",self.aliPayAccount);
//        NSLog(@"%@",self.appPassWorld);

        NSLog(@"%@",self.alipaymoneyCount);
        cash= self.alipaymoneyCount;
        tag = 8888;
    }
    
    
    
    [self beginGetCashWithTag:tag andCash:cash];
    
    
}

#pragma mark- 申请提现

- (void)beginGetCashWithTag:(NSInteger)tag andCash:(NSString *)cash{
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak WeiXinAndAliPayWithDrawVC * weakSelf = self;
    
    if (tag == 8889) {
        NSLog(@"微信提现");
        
        [self.net NetWeiChatGetCashOrderWithCash:cash];
        
        self.net.weiChatGetCashOrderBK = ^(NSString * code, NSString * message) {
            
            [hud hideAnimated:YES];
            
            NSLog(@"微信message=>%@",message);
            [weakSelf showWithDrawResoultAlterViewWithMessage:message];
            
            
            
            if ([code isEqualToString:@"1"]) {
                
                if([weakSelf.alipaymoneyCount isEqualToString:@"3"]){
                
                    [weakSelf showRedBaoWithMessage:@"1"];
                }
            }
            
        };
        
    }else{
        
        NSLog(@"支付宝");
    
        [self.net aliPayCashOrderGetFromNetWithMoney:self.alipaymoneyCount andAliPayAccount:self.aliPayAccount andName:self.nicekName andPassWord:self.appPassWorld];
        
        self.net.aliPayWithDrawOrderBK = ^(NSString * code, NSString *message) {
            
            [hud hideAnimated:YES];
            
            NSLog(@"支付宝message=>%@",message);
            [weakSelf showWithDrawResoultAlterViewWithMessage:message];

        };
    }
}



#pragma mark- 提现结果提示框
- (void)showWithDrawResoultAlterViewWithMessage:(NSString *)message{
    UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_prize_dialogs"]];
    imageView.frame = CGRectMake(0, 0, ScreenWith*2/3, ScreenWith/2);
    imageView.center = CGPointMake(ScreenWith/2, ScreenHeight/3);
    imageView.layer.shadowColor = [UIColor colorWithRed:0.0/255.0 green:191.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor;
    imageView.layer.shadowOffset = CGSizeMake(0, 0);
    imageView.layer.shadowOpacity = 1.0;
    imageView.userInteractionEnabled = YES;
    imageView.tag = 221122;
    [self.view addSubview:imageView];
    
    UILabel * labeltitle = [self addRootLabelWithfram:CGRectMake(0, ScreenWith/20, ScreenWith*2/3, ScreenWith/10) andTitleColor:[UIColor orangeColor] andFont:20.0 andBackGroundColor:[UIColor clearColor] andTitle:@"温馨提示"];
    labeltitle.textAlignment = NSTextAlignmentCenter;
    [imageView addSubview:labeltitle];
    
    UILabel * messages = [self addRootLabelWithfram:CGRectMake(0,CGRectGetMaxY(labeltitle.frame), ScreenWith*2/3, ScreenWith/8) andTitleColor:[UIColor lightGrayColor] andFont:16.0 andBackGroundColor:[UIColor clearColor] andTitle:message];
    messages.textAlignment = NSTextAlignmentCenter;
    messages.numberOfLines = 0;
    [imageView addSubview:messages];
    
    UIButton * bt = [self addRootButtonNewFram:CGRectMake(ScreenWith/6, CGRectGetMaxY(messages.frame) + ScreenWith/20, ScreenWith/3, ScreenWith/10) andSel:@selector(dissmissImageAlterView) andTitle:@"确定"];
    bt.layer.cornerRadius = 3.0;
    [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bt.backgroundColor = [UIColor colorWithRed:30.0/255.0 green:144.0/255.0 blue:255.0/255.0 alpha:0.8];
    [imageView addSubview:bt];
}

- (void)dissmissImageAlterView{

    UIImageView * image = (UIImageView *)[self.view viewWithTag:221122];
    [image removeFromSuperview];
}




#pragma mark- 授权检测
- (void)weiXinBangDingStatus{
    
    __weak WeiXinAndAliPayWithDrawVC * weakSelf = self;
    
    NetWork * net = [[NetWork alloc]init];
    
    [net NetBindWeiChatAccountFinishProgress];
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //bind, wxbind, exchange_publicno,
    net.bindWeiChatAccountFinishProgressBK = ^(NSString * bind, NSString * wxbind, NSString * exchange_publicno, NSArray * data1, NSArray * data2) {
        
        [hud hideAnimated:YES];
        
        NSLog(@"%@=%@=%@",bind,wxbind,exchange_publicno);
        
        if ([bind isEqualToString:@"1"] && [wxbind isEqualToString:@"1"]) {
            
            
            if (weakSelf.weiXinTableView == nil) {
                
                weakSelf.weiXinTableView = [self tableViewNew];
                weakSelf.weiXinTableView.tag = 336699;
            }
            
            [weakSelf.view addSubview:weakSelf.weiXinTableView];
            [weakSelf.aliPayTableView removeFromSuperview];
            
            
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




#pragma mark- 红包展示
- (void)showRedBaoWithMessage:(NSString * )message{
    
    //task_finish_red
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenHeight)];
    view.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.6];
    self.redV = view;
    
    
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith*3/4, ScreenWith*3/4)];
    imageV.center = CGPointMake(ScreenWith/2, ScreenWith*2/3);
    imageV.image =[ UIImage imageNamed:@"one_red"];
    imageV.userInteractionEnabled = YES;
    
    [view addSubview:imageV];
    
    UILabel * labrl = [self addRootLabelWithfram:CGRectMake(0, 0, ScreenWith/2, ScreenWith/15) andTitleColor:[UIColor whiteColor] andFont:16.0 andBackGroundColor:[UIColor clearColor] andTitle:@""];
    labrl.center = CGPointMake(ScreenWith*3/8, ScreenWith/2);
    [imageV addSubview:labrl];
    labrl.textAlignment = NSTextAlignmentCenter;
    
    UIButton * bt = [self addRootButtonNewFram:CGRectMake(0, 0, ScreenWith/3, ScreenWith/6) andSel:@selector(dissmissRedBao) andTitle:@""];
    bt.center = CGPointMake(ScreenWith*3/8, ScreenWith/2 + ScreenWith/6);
    bt.backgroundColor = [UIColor clearColor];
    
    [imageV addSubview:bt];
    
    
    [self.view addSubview:view];
}



- (void)dissmissRedBao{
    
    [self.redV removeFromSuperview];
    
}

@end
