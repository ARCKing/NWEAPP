//
//  AliPayWithDrawVC.m
//  NewApp
//
//  Created by gxtc on 17/2/23.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "AliPayWithDrawVC.h"

@interface AliPayWithDrawVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong)UISegmentedControl * segmented;
@property (nonatomic,strong)NSMutableArray * moneyDataArray;

@property (nonatomic,copy)NSString * nicekName;
@property (nonatomic,copy)NSString * aliPayAccount;
@property (nonatomic,copy)NSString * appPassWorld;
@property (nonatomic,copy)NSString * moneyCount;


@property (nonatomic,strong)UITextField * nickNameField;
@property (nonatomic,strong)UITextField * aliPayAccountField;
@property (nonatomic,strong)UITextField * appPassWorldField;

@property (nonatomic,strong)UILabel * currentMoneyLabel;

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,copy)NSString * currentMoney;

@end

@implementation AliPayWithDrawVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addUI];
    
    [self aliPayCashDataSourceFromNet];
}

- (void)addUI{
    [super addUI];
    self.titleLabel.text = @"支付宝提现";
    
    [self addRightBarClearButtonNew:@"提现记录"];
}


- (void)rightBarClearButtonAction{
    
    [super rightBarClearButtonAction];
    
    AliPayWithDrawRecordVC * vc = [[AliPayWithDrawRecordVC alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
};



#pragma mark- MJReloadData
/**下拉刷新*/
- (void)MJReloadData{
    
    [self getMineDataSourceFromNet];
    
}


#pragma mark- 我的信息
- (void)getMineDataSourceFromNet{
    
    
    NSDictionary * userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    
    NSString * login = userDic[@"login"];
    
    
    if (![login isEqualToString:@"1"]) {
        
        [self.tableView.mj_header endRefreshing];
        
        return;
    }
    NetWork * net = [NetWork shareNetWorkNew];
    __weak AliPayWithDrawVC * weakSelf = self;

    [net getMineDataSource];
    
    net.mineDataSourceBK=^(NSString * code,NSString * message,NSString * str,NSArray * dataArray,NSArray * arr){
        
        
        MineDataSourceModel * mineModel;
        
        if (dataArray.count > 0) {
            
            mineModel = dataArray[0];
            
        }
        
        
        if (mineModel) {
            
            CGFloat currentMoneys = [mineModel.residue_money floatValue];
            
            if (currentMoneys > 0) {
                
                currentMoneys = currentMoneys/1000.0;
            }
            
            NSString * money = [NSString stringWithFormat:@"%.3f",currentMoneys];
            
            weakSelf.currentMoneyLabel.attributedText = [weakSelf addRootInsertAttributedText1:@"余额:元" andText2:money andIndex:3 andColor1:[UIColor blackColor] andColor2:[UIColor redColor] andFont1:15 andFont2:17];
            
        }
        
        [weakSelf.tableView.mj_header endRefreshing];
        
    };
    
}







- (void)aliPayCashDataSourceFromNet{

    NetWork * net  = [NetWork shareNetWorkNew];
    
    [net aliPayCashGetFromNet];
    
    __weak AliPayWithDrawVC * weakSelf = self;
    
    net.aliPayCashBK=^(NSString * code,NSString * message ,NSString * currentMoney,NSArray * dataArray,NSArray * data){
    
        weakSelf.moneyDataArray = [NSMutableArray arrayWithArray:dataArray];

        weakSelf.currentMoney = currentMoney;
        
        if (dataArray.count>0) {
            
            weakSelf.moneyCount = dataArray[0];

        }
        
        
        [ weakSelf tableViewNew];

    };
}


- (UISegmentedControl *)addSegmentedControlNewWithLabel:(UILabel *)titleLabel{

    
//    NSArray * titleArray = @[@"30",@"50",@"100",@"200"];
//    
//    self.moneyDataArray = [NSMutableArray arrayWithArray:titleArray];
    
    UISegmentedControl * segment = [[UISegmentedControl alloc]initWithItems:self.moneyDataArray];
    
    segment.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame),(ScreenWith/6 - ScreenWith/13)/2, (ScreenWith * 2/3), ScreenWith/13);
    segment.selectedSegmentIndex = 0;
    segment.tintColor = [UIColor colorWithRed:0.0 green:217.0/255.0 blue:225.0/255.0 alpha:1.0];
    [segment addTarget:self action:@selector(segmentedSelect:) forControlEvents:UIControlEventValueChanged];
    return segment;
}

- (void)segmentedSelect:(UISegmentedControl *)segmented{

    NSInteger index = segmented.selectedSegmentIndex;
    
    NSLog(@"%@",self.moneyDataArray[index]);
    
    self.moneyCount = self.moneyDataArray[index];
    [self outOfFistRspond];
}


#pragma mark- tableViewNew

- (void)tableViewNew{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, ScreenWith, ScreenHeight - 64) style:UITableViewStyleGrouped];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = ScreenWith/6;
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
     tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJReloadData)];
    
    [tableView.mj_header beginRefreshing];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    AliPayCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSArray * titleArray = @[@"姓名:",@"支付宝账号:",@"用户密码:",@"兑换金额:"];
    NSArray * placeHolderArray = @[@"你的支付宝实名",@"你的支付宝账号",@"知了的登录密码"];
    
    if (cell == nil) {
        cell = [[AliPayCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UILabel * label = [cell addCellRootLabelNewWithFram:CGRectMake(15, 0, ScreenWith/4, ScreenWith/6) andBackGroundColor:[UIColor whiteColor] andTextColor:[UIColor blackColor] andFont:15 andTitle:titleArray[indexPath.row] andNSTextAlignment:NSTextAlignmentLeft];
    [cell.contentView addSubview:label];
    
    
    if (indexPath.row != 3) {
        
        UITextField * field = [[UITextField alloc]initWithFrame:CGRectMake(ScreenWith/4 +10, 0, ScreenWith*3/4 - 10, ScreenWith/6)];
        field.placeholder = placeHolderArray[indexPath.row];
        field.font = [UIFont systemFontOfSize:15];
        field.delegate = self;
        field.clearButtonMode = UITextFieldViewModeWhileEditing;
        [cell addSubview:field];
        
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
        self.segmented = vc;
        [cell.contentView addSubview:vc];
    }
    
    
   
    
    
    return cell;
    
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

    [self outOfFistRspond];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 4;
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
    
    UIImageView * imagev = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zfb"]];
    imagev.frame = CGRectMake(20, 0, ScreenWith/6, ScreenWith/8);
    [view addSubview:imagev];
    
    NSMutableAttributedString * attri = [self addRootInsertAttributedText1:@"余额:元" andText2:@"0.000" andIndex:3 andColor1:[UIColor blackColor] andColor2:[UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1] andFont1:15 andFont2:17];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWith/2, 0, ScreenWith/2 - 20, ScreenWith/8)];
    label.textAlignment = NSTextAlignmentRight;
    label.attributedText = attri;
    self.currentMoneyLabel = label;
    [view addSubview:label];
    
    return view ;
}


//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    
        return ScreenHeight - 64 - ScreenWith/8 - ScreenWith/6 * 4;
    
}
//section底部视图
- (UIView * )tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenHeight - 64 - ScreenWith/8 - ScreenWith/6 * 4)];
    view.backgroundColor = [UIColor clearColor];
    
    
    UILabel * titleLabel1 = [self addRootLabelWithfram:CGRectMake(20, 10, ScreenWith - 40, ScreenWith/10) andTitleColor:[UIColor lightGrayColor] andFont:14.0 andBackGroundColor:[UIColor clearColor] andTitle:@"*提现后将于5个工作日内到账"];
    
    
    UIButton * bt = [self addRootButtonTypeTwoNewFram:CGRectMake(20, CGRectGetMaxY(titleLabel1.frame) + 5, ScreenWith - 40, ScreenWith/10) andImageName:@"" andTitle:@"申请提现" andBackGround:[UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1] andTitleColor:[UIColor whiteColor] andFont:15.0 andCornerRadius:5.0];
    [bt addTarget:self action:@selector(AliPayWithDraw) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * titleLabel2 = [self addRootLabelWithfram:CGRectMake(20, CGRectGetMaxY(bt.frame) + 10, ScreenWith - 40, 0) andTitleColor:[UIColor redColor] andFont:14.0 andBackGroundColor:[UIColor clearColor] andTitle:@"注意!\n提现规则:\n1.为保证平台的公平性，所有提现申请都将进行人工审核;非正常积分获取将被视为作弊行为,其提现申请将被拒绝\n2.为保障您的资金安全，提现申请审核通过后，将通过人工处理第三方支付平台汇入到您的账户\n3.提现到账期一般为1-3个工作日,法定节假日顺延,请注意查收"];
    titleLabel2.numberOfLines = 0;
    [titleLabel2 sizeToFit];
    
    [view addSubview:titleLabel1];
    [view addSubview:bt];
    [view addSubview:titleLabel2];
    
    
    return view;
}



- (void)AliPayWithDraw{

    
    [self outOfFistRspond];
    
    NSLog(@"申请提现");
    
    NSLog(@"%@",self.nicekName);
    NSLog(@"%@",self.aliPayAccount);
    NSLog(@"%@",self.appPassWorld);
    NSLog(@"%@",self.moneyCount);

    
    NetWork * net = [NetWork shareNetWorkNew];
    
    [net aliPayCashOrderGetFromNetWithMoney:self.moneyCount andAliPayAccount:self.aliPayAccount andName:self.nicekName andPassWord:self.appPassWorld];
    
    __weak AliPayWithDrawVC * weakSelf = self;
    
    net.aliPayWithDrawOrderBK=^(NSString * code,NSString * message){
    
        [weakSelf rootShowMBPhudWith:message andShowTime:1.5];
    };
}

@end
