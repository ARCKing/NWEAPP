//
//  MineVC.m
//  NewApp
//
//  Created by gxtc on 17/2/13.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "MineVC.h"

@interface MineVC ()<UITableViewDelegate,UITableViewDataSource>

/**
 *cell的UI数组
 */
@property (nonatomic,strong)NSArray<NSArray *> * SectionsTitleArray;
@property (nonatomic,strong)NSArray<NSArray *> * SectionsIconArray;

/**
 *
 */
@property (nonatomic,strong)UIScrollView * loginOrUnLoginScrollView;


@property (nonatomic,strong)MineDataSourceModel * mineModel;
@property (nonatomic,strong)UILabel * goldLabel;
@property (nonatomic,copy)NSString * goldMoney;
@property (nonatomic,strong)UITableView * tableView;


@property (nonatomic,copy)NSString * uid;
@property (nonatomic,copy)NSString * token;
@property (nonatomic,copy)NSString * isLogin;

//邀请好友得**金币
@property (nonatomic,copy)NSString * inviateCoin;
@property (nonatomic,strong)UILabel * inviateCoinlb;

@property (nonatomic,assign)BOOL hiddenCell;

@property (nonatomic,strong)NSTimer * timer;
@property (nonatomic,strong)UIScrollView * scrollView;

@property (nonatomic,assign)CGFloat scroll_w;

@property (nonatomic,strong)UIButton * QRbutton;


//滚动横幅
@property (nonatomic,copy)NSString * activityMessage;
@property (nonatomic,assign)BOOL hasActivity;

@end

@implementation MineVC



- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    [self isLoginState];
    
    [self getTokenAndUid];
    
    [self MJReloadData];
    
    
    if (self.hasActivity) {
    
        [self addTime];
    }
    
    

}



- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    
    if (self.QRbutton) {
        
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary * dic = [defaults objectForKey:@"userInfo"];
        
        
        NSLog(@"------------------->%@",dic);
        
        if ([dic[@"login"] isEqualToString:@"1"]) {
        
            self.QRbutton.enabled = YES;
        }else{
        
            self.QRbutton.enabled = NO;
        }
        
        
    }

}



- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    [self stopTime];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.hiddenCell = NO;
    
    self.scroll_w = ScreenWith - 15 - ScreenWith/16 - 15 - 10;

    [self addUI];
    [self dataSource];
    
//    [self getMineDataSourceFromNet];
    
}




- (void)getTokenAndUid{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * userInfo = [defaults objectForKey:@"userInfo"];
    self.uid = userInfo[@"uid"];
    self.token = userInfo[@"token"];
    self.isLogin = userInfo[@"login"];
}




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
    
    [net getMineDataSource];
    
    __weak MineVC * weakSelf = self;
    
    net.mineDataSourceBK=^(NSString * code,NSString * message,NSString * str,NSArray * dataArray,NSArray * arr){
    
        if (dataArray.count > 0) {
            
            weakSelf.mineModel = dataArray[0];
            
            weakSelf.goldMoney = weakSelf.mineModel.residue_money;
            
        }
        
        if (weakSelf.mineModel) {
            
            /*
            if ([weakSelf.mineModel.type isEqualToString:@"1"]) {
                
                weakSelf.hiddenCell = NO;
                
            }else{
            
                weakSelf.hiddenCell = YES;
            }
             */
            
            
            weakSelf.inviateCoin = weakSelf.mineModel.prentice;
            
            CoreDataManger * CDManger = [CoreDataManger shareCoreDataManger];
            
            BOOL isDelete = [CDManger deleteMineDataSource];
            
            if (isDelete) {
                
                [CDManger insertMineDataWithMineDataModel:weakSelf.mineModel];
                
                [weakSelf checkMineDataFromCoreData];
            }
            
        }
        
        
        [weakSelf.tableView.mj_header endRefreshing];
        
    };

}


#pragma mark- 检查我的本地信息
/**检查我的本地信息*/
- (void)checkMineDataFromCoreData{

    CoreDataManger * CDManger = [CoreDataManger shareCoreDataManger];
    
    MineDataSourceModel * model = [CDManger checkMineDataSource];
    
    if (model) {
        
        self.goldMoney = model.residue_money;

        self.mineModel = model;
        
        [self.tableView reloadData];
        
        
    }else{
    
        [self getMineDataSourceFromNet];

    }
    
    
}

#pragma mark- 登录状态
- (void)isLoginState{

    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * dic = [defaults objectForKey:@"userInfo"];
    
    if ([dic[@"login"] isEqualToString:@"1"]) {
        self.loginOrUnLoginScrollView.userInteractionEnabled = NO;
        self.loginOrUnLoginScrollView.contentOffset = CGPointMake(0, 0);
        
        [self checkMineDataFromCoreData];
        
    }else{
        self.loginOrUnLoginScrollView.userInteractionEnabled = YES;
        self.loginOrUnLoginScrollView.contentOffset = CGPointMake(ScreenWith, 0);
        self.goldLabel.text = @"";
    }

}


- (void)addUI{
    
    self.navigationBarView = [self NavBarViewNew];
    self.navigationBarView.backgroundColor =[UIColor whiteColor];
    [self addTitleLabelNew];
    self.titleLabel.text = @"我的";
    [self addLineNew];
    [self tableViewNew];

    
    [self getActivityNoticeFromNet];
    
}


- (void)dataSource{

    /*
    NSArray * titleArray0 = @[@"用户"];
    NSArray * titleArray1 = @[@"邀请好友",@"输入邀请码"];
    NSArray * titleArray2 = @[@"我的消息", @"我的收藏",@"历史阅读"];
    NSArray * titleArray3 = @[@"任务中心",@"收支明细",@"手气抽奖"];
    NSArray * titleArray4 = @[@"新手指南", @"有奖反馈", @"设置"];
    */
    
    
    NSArray * titleArray0 = @[@"用户"];
    NSArray * titleArray1 = @[@"喇叭"];
    NSArray * titleArray2 = @[@"新手指南",@"签到",@"抽红包",@"账号绑定",@"输入邀请码"];
    NSArray * titleArray3 = @[@"收益明细",@"我的徒弟",@"幸运抽奖",@"排行榜"];
    NSArray * titleArray4 = @[@"我的收藏",@"我的分享"];
    NSArray * titleArray5 = @[@"客服/Q群", @"商务合作", @"设置"];

    NSArray * iconImageArray0=@[@""];
    NSArray * iconImageArray1=@[@""];
    NSArray * iconImageArray2=@[@"",@"",@"",@"",@""];
    NSArray * iconImageArray3=@[@"",@"",@"",@""];
    NSArray * iconImageArray4=@[@"",@""];
    NSArray * iconImageArray5=@[@"",@"",@""];


    
    self.SectionsTitleArray = [NSArray arrayWithObjects:titleArray0,titleArray1, titleArray2,titleArray3,titleArray4,titleArray5,nil];
    
    self.SectionsIconArray = [NSArray arrayWithObjects:iconImageArray0,iconImageArray1,iconImageArray2,iconImageArray3,iconImageArray4,iconImageArray5, nil];
    
}

#pragma mark- tableViewNew

- (void)tableViewNew{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, ScreenWith, ScreenHeight - 64 - 49) style:UITableViewStyleGrouped];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.dataSource = self;
    tableView.delegate = self;
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
    
//    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJReloadData)];
    
    MJRefreshNormalHeader * MJ_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJReloadData)];
    
    MJ_header.stateLabel.textColor =[UIColor colorWithRed:0.0 green:207.0/255.0 blue:1.0 alpha:1.0];
    
    MJ_header.lastUpdatedTimeLabel.textColor = [UIColor colorWithRed:0.0 green:207.0/255.0 blue:1.0 alpha:1.0];
    
    tableView.mj_header = MJ_header;
    
    
//    [tableView.mj_header beginRefreshing];
}

/**
 *登录注册
 */
- (void)loginButtonAction{

    NSLog(@"登录注册");
    LoginViewController * vc = [[LoginViewController alloc]init];
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}


#pragma mark- 我的二维码
- (void)creatQrCodeImage{

    MineQRCodeVC * vc = [[MineQRCodeVC alloc]init];
    
    if (self.mineModel) {
        
        vc.mineModel = self.mineModel;
    }
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    NSLog(@"+++++-------+=======");
}


#pragma mark- tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (indexPath.section == 0) {
        
        SectionZeroUserCell * cell = [tableView dequeueReusableCellWithIdentifier:@"sectionZero"];
        if (cell == nil) {
            cell = [[SectionZeroUserCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sectionZero"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell.loginBt addTarget:self action:@selector(loginButtonAction) forControlEvents:UIControlEventTouchUpInside];
            self.loginOrUnLoginScrollView = cell.scrollView;
            
            
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            NSDictionary * dic = [defaults objectForKey:@"userInfo"];
            
            if ([dic[@"login"] isEqualToString:@"1"]) {
                //cell响应关键
                cell.scrollView.userInteractionEnabled = NO;
            }else{
                //cell响应关键
                cell.scrollView.userInteractionEnabled = YES;
                cell.scrollView.contentOffset = CGPointMake(ScreenWith, 0);
            }
            
        }
        
        if (self.mineModel) {
        
            [cell.userIconImage sd_setImageWithURL:[NSURL URLWithString:self.mineModel.headimgurl] placeholderImage:[UIImage imageNamed:@"head_icon"]];
            
            
            if ([self.mineModel.nickname isEqualToString:@"(null)"]) {
                
                cell.nameLabel.text = self.mineModel.username;
                
            }else{
                
                cell.nameLabel.text = self.mineModel.nickname;
            }
            
            /*
            if ([self.mineModel.sex isEqualToString:@"1"]) {
            
                cell.sex.image = [UIImage imageNamed:@"sex_male"];
            }else{
                cell.sex.image = [UIImage imageNamed:@"sex_woman"];

            }
            
            cell.lvLabel.text = [NSString stringWithFormat:@"LV%@",self.mineModel.level];
            [cell.lvLabel sizeToFit];
            
            NSString * redCount = self.mineModel.today_read;
            
            cell.todayReadLabel.attributedText = [cell addCellInsertAttributedText1:@"今日阅读篇" andText2:redCount andIndex:4 andColor1:[UIColor blackColor] andColor2:[UIColor cyanColor] andFont2:14.0 andFont2:14.0];
            [cell.todayReadLabel sizeToFit];
            
            cell.todayReadLabel.center = CGPointMake(25 + cell.todayReadLabel.bounds.size.width/2 + ScreenWith/4 - 30, ScreenWith/5 - 10);

            
            cell.totalReadLabel.text = [NSString stringWithFormat:@"总阅读%@篇",self.mineModel.sum_read];
            cell.totalReadLabel.center = CGPointMake(cell.todayReadLabel.center.x + ScreenWith/6 + 10 + cell.todayReadLabel.bounds.size.width/2,cell.todayReadLabel.center.y);
            
            */
            
            cell.IDLabel.text = [NSString stringWithFormat:@"编号:%@",self.mineModel.username];

            
            if (self.QRbutton == nil) {
                
                cell.IDLabel.text = [NSString stringWithFormat:@"编号:%@",self.mineModel.username];
            
                UIButton * button = [self addRootButtonNewFram:CGRectMake(ScreenWith - 30 - ScreenWith/5, 0, ScreenWith/5, ScreenWith/4) andSel:@selector(creatQrCodeImage) andTitle:@""];
                button.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:button];
            
                self.QRbutton = button;
            }
        }
        
        return cell;
        
    }else if (indexPath.section == 1){
    
        [self stopTime];

        ScrollMessageLabelCell * cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell_%ld_%ld",indexPath.section,indexPath.row]];
        
        if (cell == nil) {
            
            cell = [[ScrollMessageLabelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"cell_%ld_%ld",indexPath.section,indexPath.row]];
            
            self.scrollView = cell.scrollView;
        }
        
        [cell setMessageWithMessage:self.activityMessage];
        
        
        
        if (self.hasActivity) {
            
            [self addTime];
            
        }
        
        
        return cell;
        
    }else{
    
        NSArray * iconArray1 = @[@"laba"];
        NSArray * iconArray2 = @[@"ic_tutorial",@"qd_h",@"DZP",@"ic_edit_comment_grey",@"index_invite"];
        NSArray * iconArray3 = @[@"ic_io_detail",@"people",@"index_exchange",@"phb",@"ic_task"];
        NSArray * iconArray4 = @[@"ic_collect",@"fk"];
        NSArray * iconArray5 = @[@"ic_question",@"hand",@"ic_set_up"];

        
        
        MineOneCell * cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell_%ld_%ld",indexPath.section,indexPath.row]];
        if (cell == nil) {
            cell = [[MineOneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"cell_%ld_%ld",indexPath.section,indexPath.row]];
            
            if (!(indexPath.section == 1 && indexPath.row == 0)) {
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            
        
                NSArray * title = self.SectionsTitleArray[indexPath.section];
                NSArray * image = self.SectionsIconArray[indexPath.section];
            
                [cell addIcon:image[indexPath.row] andTitle:title[indexPath.row]];
                
            }else{
                
                /*
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell addIcon:@"laba" andTitle:@""];

                
                
                UIScrollView * scrolLabel = [[UIScrollView alloc]initWithFrame:CGRectMake(15 + ScreenWith/16 + 15, ScreenWith/32, self.scroll_w, ScreenWith/16)];
                self.scrollView = scrolLabel;
                scrolLabel.contentSize = CGSizeMake((ScreenWith - 15 - ScreenWith/16 - 15 - 10)*3, 0);
                scrolLabel.scrollEnabled = NO;
                [cell.contentView addSubview:scrolLabel];
                
                UILabel * label = [[UILabel  alloc ]initWithFrame:CGRectMake(self.scroll_w,0,self.scroll_w * 2, ScreenWith/16)];
                label.textColor = [UIColor redColor];
                label.text = @"恭喜139****7640获得1次抽奖机会";
                label.font = [UIFont systemFontOfSize:14.0];
                [scrolLabel addSubview:label];
                
                self.scrolLabel = label;
                 */
            }
            

            if (indexPath.section ==1) {
                
                cell.iconImageView.image =[ UIImage imageNamed:iconArray1[indexPath.row]];
            }else if (indexPath.section == 2){
                cell.iconImageView.image =[ UIImage imageNamed:iconArray2[indexPath.row]];

            
            }else if (indexPath.section == 3){
                cell.iconImageView.image =[ UIImage imageNamed:iconArray3[indexPath.row]];

            }else if (indexPath.section == 4){
                cell.iconImageView.image =[ UIImage imageNamed:iconArray4[indexPath.row]];
                
            }else if (indexPath.section == 5){
                cell.iconImageView.image =[ UIImage imageNamed:iconArray5[indexPath.row]];
                
            }
            
        }
        
              return cell;
    }
}

/**
 *添加cell的小图+文字
 */
- (UILabel *)addAttributedText1:(NSString *)str1 andtext2:(NSString *)str2{
    
    NSString * str = [NSString stringWithFormat:@"%@%@",str1,str2];
    NSMutableAttributedString * attributrdString1 = [[NSMutableAttributedString alloc]initWithString:str];
    
    NSRange range1 = [str rangeOfString:str];
    
    [attributrdString1 addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, range1.length - 2)];
    
    [attributrdString1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(range1.length - 2,2)];
    
    [attributrdString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, range1.length)];
   
    UILabel * label  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    label.attributedText = attributrdString1;
    [label sizeToFit];
    label.center = CGPointMake(ScreenWith - label.frame.size.width/2 - 30, ScreenWith/16);
    return label;
}

- (UIImageView *)addCellLittleRightIcon{
    UIImageView * imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"new"]];
    imageV.frame = CGRectMake(ScreenWith - 60, (ScreenWith/8 - 33)/2, 33, 33);
    return imageV;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0 && indexPath.section == 0) {
        
        return ScreenWith/4;
    }else{
    
        return ScreenWith/8;
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{


    return self.SectionsTitleArray.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    if (self.hiddenCell == YES) {
        
        if (section == 1) {
            
            return 0;
            
        }else if (section == 3){
            
            return 0;
            
        }else{
            
            return self.SectionsTitleArray[section].count;

        }
        
    }else if (section == 1){
    
        
        if (self.hasActivity) {
            
            return 1;
            
        }else{
        
            return 0;
        }
    }else{
    
    
        return self.SectionsTitleArray[section].count;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"点击了section=%ld row=%ld",indexPath.section,indexPath.row);
    
    if (indexPath.section == 0 && indexPath.row == 0) {
    
        
        if (![self.isLogin isEqualToString:@"1"]) {
            
            [self goToLogineVC];
            
            return;
        }
        
        
        SetUserDataVC * vc = [[SetUserDataVC alloc]init];
        vc.title = @"我的资料";
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    }else if (indexPath.section == 2 && indexPath.row == 4) {

        if (![self.isLogin isEqualToString:@"1"]) {
            
            [self goToLogineVC];
            
            return;
        }
        
        InviateCodeVC * vc = [[InviateCodeVC alloc]init];
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    
        
    }else if (indexPath.section == 2 && indexPath.row == 0) {
        
        WKWebViewController * vc = [[WKWebViewController alloc]init];
        
        vc.urlString = [NSString stringWithFormat:@"%@/App/Index/help",DomainURL];
        vc.isNewTeach = YES;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    }else if (indexPath.section == 2 && indexPath.row == 1) {
        
        if (![self.isLogin isEqualToString:@"1"]) {
            
            [self goToLogineVC];
            
            return;
        }
        
        TestCenterVC * vc = [[TestCenterVC alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;

    
    }else if (indexPath.section == 2 && indexPath.row == 2) {
        
        if (![self.isLogin isEqualToString:@"1"]) {
            
            [self goToLogineVC];
            
            return;
        }
        
        RedBaoVC * vc = [[RedBaoVC alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    }else if (indexPath.section == 2 && indexPath.row == 3) {
        
        if (![self.isLogin isEqualToString:@"1"]) {
            
            [self goToLogineVC];
            
            return;
        }
        
        BindWeChatAccountVC * vc = [[BindWeChatAccountVC alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    }else if (indexPath.section == 4 && indexPath.row == 1) {
        
        ShareRecordVC * vc = [[ShareRecordVC alloc]init];
        vc.title = @"我的收藏";
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    }else if (indexPath.section == 4 && indexPath.row == 0) {
        
        if (![self.isLogin isEqualToString:@"1"]) {
            
            [self goToLogineVC];
            
            return;
        }
        
        MyCollectionArticleVC * vc = [[MyCollectionArticleVC alloc]init];
        vc.title = @"我的消息";
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;

    }else if (indexPath.section == 4 && indexPath.row == 2) {
        
        HistoryReadVC * vc = [[HistoryReadVC alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;

    }else if (indexPath.section == 3 && indexPath.row == 0) {
        
        if (![self.isLogin isEqualToString:@"1"]) {
            
            [self goToLogineVC];
            
            return;
        }
        
        IncomeDetailTypeTwoVC * vc = [[IncomeDetailTypeTwoVC alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;

    }else if (indexPath.section == 3 && indexPath.row == 3) {
        RankPeopleVC * vc = [[RankPeopleVC alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else if (indexPath.section == 3 && indexPath.row == 2) {
        
        if (![self.isLogin isEqualToString:@"1"]) {
            
            [self goToLogineVC];
            
            return;
        }
        
        ChouJiangVC * vc = [[ChouJiangVC alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    }else if (indexPath.section == 3 && indexPath.row == 1) {
        
        if (![self.isLogin isEqualToString:@"1"]) {
            
            [self goToLogineVC];
            
            return;
        }
        
        FriendListVC * vc = [[FriendListVC alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    }else if (indexPath.section == 5 && indexPath.row == 0) {
        
        
        ServiceQQTypeTwo * vc = [[ServiceQQTypeTwo alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;

    }else if (indexPath.section == 5 && indexPath.row == 1) {
        
//        WKWebViewController * vc = [[WKWebViewController alloc]init];
//        vc.urlString = [NSString stringWithFormat:@"%@/App/Index/help",DomainURL];
//        vc.isNewTeach = YES;
        
        
        ServiceQQVC * vc = [[ServiceQQVC alloc]init];
        vc.type = 1;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;


    }else if (indexPath.section == 5 && indexPath.row == 2) {
        SetVC * vc = [[SetVC alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
    }
    
    
}


- (void)goToLogineVC{

        LoginViewController * vc = [[LoginViewController alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    

}



#pragma mark- 分组高度
//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;//section头部高度
}


//section头部视图
- (UIView * )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWith, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view ;
}


//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSInteger index = self.SectionsTitleArray.count;
    
    if (index - 1 == section && index > 0) {
        
        return 0.1;
    }
    return 4.9;
}
//section底部视图
- (UIView * )tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWith, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}



#pragma mark- 定时器
- (void)addTime{
    
    if (self.timer == nil) {
        
        NSTimer * time = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(changeScrollViewContOfSet) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:time forMode:NSRunLoopCommonModes];
        self.timer = time;
    }
    

}


- (void)changeScrollViewContOfSet{
    
    
    NSLog(@"喇叭开始响了!!!");
    
   NSString * message = [self.activityMessage stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    CGSize  size = [message sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]}];
    CGFloat size_w = size.width;

    
    
    
    [UIView animateWithDuration:19.5 animations:^{
        
//        CGFloat currentOffset = self.scrollView.contentOffset.x;
        
        self.scrollView.contentOffset = CGPointMake(size_w,0);
        
    }completion:^(BOOL finished) {
        
//        if (self.scrollView.contentOffset.x == self.scroll_w * 2) {
        
            self.scrollView.contentOffset = CGPointMake(0, 0);
//        }
        
        
    }];
    
    
}


- (void)stopTime{
    
    [self.timer invalidate];
    
    self.timer = nil;
    
}



#pragma mark- 活动公告
/**活动公告*/
- (void)getActivityNoticeFromNet{
    
    NetWork * net = [NetWork shareNetWorkNew];
    
    __weak MineVC * wewakSelf = self;
    
    [net NetActivityNotice];
    
    net.activityNoticeBK = ^(NSString *code, NSString * imgUrl, NSString *wz, NSArray *arr1, NSArray *arr2) {
        
        
        if ([code isEqualToString:@"1"]) {
            
            if (![wz isEqualToString:@""]) {
                
                wewakSelf.hasActivity = YES;
                
                wewakSelf.activityMessage = wz;
                
                [wewakSelf.tableView reloadData];
     
                    
            }
                
        }

    
    };
    
}


@end
