//
//  TestCenterVC.m
//  NewApp
//
//  Created by gxtc on 17/2/22.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "TestCenterVC.h"

@interface TestCenterVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign)NSInteger currentIndex;
@property (nonatomic,assign)NSInteger lastIndex;

@property (nonatomic,assign)BOOL isOpen;


@property (nonatomic,strong)TestCenterModel * model;

//我的金币
@property (nonatomic,strong)UILabel * goldCoin;

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)UILabel * lastLabel;

@property (nonatomic,strong)SectionThreeCell * lastCell;

//签到进度
@property (nonatomic,strong)CAShapeLayer * signLineProgress;

//签到天数
@property (nonatomic,strong)UILabel * signDay;

//签到按钮
@property (nonatomic,strong)UIButton * signButton;

//奖励金币数
@property (nonatomic,strong)NSMutableArray * coinArray;


//连续签到得金币数
@property (nonatomic,strong)NSMutableArray * tableHeadViewFourLabelArray;

//查看更多
@property (nonatomic,assign)BOOL isLookMore;


@property (nonatomic,assign)BOOL hiddenCell;

@property (nonatomic,strong)NSMutableArray * explainArray;

@property (nonatomic,strong)NSMutableArray * oldExplainArray;

@end

@implementation TestCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    NSArray * explain = @[@"首次注册:注册成功即送:",
                          
                          @"首次签到奖励0.1元,连续签到10天，额外奖励0.1元,连续签到20天，额外奖励0.3元,连续签到30天，额外奖励0.5元,日常签到奖励:",
                          
                          @"邀请奖励:每邀请一个好友成功注册并分享文章获得首次分享收益后奖励:",
                          
                          @"分享文章:文章分享到微信端被好友阅读，每阅读奖励(以文章实际单价为准):",
                          
                          @"徒弟提成:邀请好友除了可获得1.5元/人的收徒奖励还可以坐享一级徒弟15%收益提成，以及二级徒弟5%收益提成"];
                          
//                          @"阅读文章:自己阅读文章可获得(限制20次):",
//                          @"有奖反馈:为平台提供有价值的建议,可获得:",
//                          @"优质评论:给出文章优质评论可获得:",
//                          @"评论点赞:给文章下方的评论专区的评论点赞,(每天最多可获得5次奖励)即可获得:"];

    
    
    self.coinArray = [NSMutableArray new];
    
    self.explainArray = [NSMutableArray arrayWithArray:explain];
    self.oldExplainArray = [NSMutableArray arrayWithArray:explain];
    
    self.tableHeadViewFourLabelArray = [NSMutableArray new];
    self.hiddenCell = NO;
    
    self.currentIndex = 1000;
    self.lastIndex = 2000;
    self.isOpen = NO;
    
    [self addUI];
    
}



/**下拉刷新*/
- (void)MJRefreshData{

    [self getDataFromNet];

}



#pragma mark- 数据请求

- (void)getDataFromNet{

    NetWork * net =[NetWork shareNetWorkNew];

    [net testCenterDataFromNet];
    
    __weak TestCenterVC * weakSelf = self;
    
    net.testCenterBK=^(NSString * code,NSString * message,NSString * str,NSArray * data,NSArray * array){
    
        [weakSelf.tableView.mj_header endRefreshing];
        
        
        if (![code isEqualToString:@"1"]) {
            
            return;
        }
        
        
        
        
        if (data.count > 0) {
            
            weakSelf.model = data[0];
        }
        
        if (weakSelf.model) {
            
            if (weakSelf.coinArray.count > 0) {
                
                [weakSelf.coinArray removeAllObjects];
            }
            
            /*
            if ([weakSelf.model.type isEqualToString:@"1"]) {
                
                self.hiddenCell = NO;
                
            }else{
            
                self.hiddenCell = YES;
            }
            */
            
            
        //首次登陆
            [weakSelf.coinArray addObject:weakSelf.model.hb_new_hb_money];
        //签到积分
            [weakSelf.coinArray addObject:weakSelf.model.signDay_money];
        //邀请好友
            [weakSelf.coinArray addObject:weakSelf.model.inviter_money];
        //文章分享
            [weakSelf.coinArray addObject:weakSelf.model.share_money];
        //徒弟收益
            
            NSString * superior = [NSString stringWithFormat:@"%@",weakSelf.model.superior];
            NSString * prentice = [NSString stringWithFormat:@"%@",weakSelf.model.prentice];

            NSInteger number = [superior integerValue] + [prentice integerValue];
            
            
            [weakSelf.coinArray addObject:[NSString stringWithFormat:@"%ld%%",number]];
            
            
            /*
        //阅读文章
            [weakSelf.coinArray addObject:weakSelf.model.read_money];
        //有奖反馈
            [weakSelf.coinArray addObject:weakSelf.model.feedback_money];
        //优质评论
            [weakSelf.coinArray addObject:weakSelf.model.comment_money];
        //评论点赞
            [weakSelf.coinArray addObject:weakSelf.model.up_data_money];
            */
            
            for (int i = 0 ; i < weakSelf.tableHeadViewFourLabelArray.count ; i ++) {
                NSString * money = [NSString stringWithFormat:@"%@",weakSelf.model.sign_money[i]];
                UILabel * label = weakSelf.tableHeadViewFourLabelArray[i];
                label.text = [NSString stringWithFormat:@"+%@元",money];
            
            }
            
            
        }
        
        
        NSLog(@"%@",weakSelf.model);
        
        if ([weakSelf.model.signDay_num isEqualToString:@"1"]) {
            
            [weakSelf.signButton setTitle:@"已签到" forState:UIControlStateNormal];
        }
        
        
        
        weakSelf.goldCoin.text = weakSelf.model.sum_money;
        weakSelf.signDay.text = [NSString stringWithFormat:@"连续%@天",weakSelf.model.sign_num];
        
        CGFloat signDats = [weakSelf.model.sign_num floatValue];
        
        CGFloat currentProgress = signDats/30.0;
        
        weakSelf.signLineProgress.strokeEnd = currentProgress;
        
        
        
        [weakSelf explainNewStringWitnCoinArray:weakSelf.coinArray];
        
        
        
        
        [self.tableView reloadData];
    };
}



//字符串拼接
- (void)explainNewStringWitnCoinArray:(NSArray *)coinArray{

    NSMutableArray * arrayNew = [NSMutableArray new];
    
    for (int i = 0; i < coinArray.count ; i++) {
        
        NSString * explain = self.oldExplainArray[i];
        NSString * coin = self.coinArray[i];
        
        
        if (i == coinArray.count - 1) {
            
            NSString * string = [NSString stringWithFormat:@"%@",explain];
            [arrayNew addObject:string];
            
        }else{
            NSString * string = [NSString stringWithFormat:@"%@%@元",explain,coin];
            [arrayNew addObject:string];
        }
    }
    
    self.explainArray = [NSMutableArray arrayWithArray:arrayNew];
    
}





- (void)addUI{
    [super addUI];
    self.titleLabel.text = @"任务中心";
    
    [self tableViewNew:[self addTableHeadViewNew]];
}


- (UIView *)addTableHeadViewNew{
    
    UIImageView * backGroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenWith /2)];
    backGroundView.backgroundColor = [UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1];
    backGroundView.userInteractionEnabled = YES;
    
    
    UIView * whitwView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWith/2 - ScreenWith/10, ScreenWith/10, ScreenWith/5, ScreenWith/5)];
    whitwView.backgroundColor =[ UIColor whiteColor];
    whitwView.layer.cornerRadius = ScreenWith/10;
    whitwView.clipsToBounds = YES;
    [backGroundView addSubview:whitwView];

    
    UILabel * signDay = [self addRootLabelWithfram:CGRectMake(ScreenWith/2 - ScreenWith/10, ScreenWith/8 + 5, ScreenWith/5, ScreenWith/5) andTitleColor:[UIColor lightGrayColor] andFont:13.0 andBackGroundColor:[UIColor clearColor] andTitle:@"连续0天"];
    signDay.textAlignment = NSTextAlignmentCenter;
    [backGroundView addSubview:signDay];
    self.signDay = signDay;
    
    
    UIButton * button = [self addRootButtonNewFram:CGRectMake(ScreenWith/2 - ScreenWith/10, ScreenWith/10, ScreenWith/5, ScreenWith/5) andSel:@selector(EveryDaySignButtonAction:) andTitle:@"签到"];
    button.titleEdgeInsets = UIEdgeInsetsMake(-15, 0, 0, 0);
    button.titleLabel.font = [UIFont systemFontOfSize:15.0];
    button.layer.borderWidth = 3.0;
    button.layer.borderColor = [UIColor colorWithRed:0.0 green:225.0/255.0 blue:1.0 alpha:1].CGColor;
    button.backgroundColor = [UIColor clearColor];
    
    self.signButton = button;
    
    [backGroundView addSubview:button];
    
    UILabel * label1 = [self addRootLabelWithfram:CGRectMake(10, 10, ScreenWith/4, 10) andTitleColor:[UIColor whiteColor] andFont:16.0 andBackGroundColor:[UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1] andTitle:@"我的余额"];

    [backGroundView addSubview:label1];
    
    
    UILabel * label2 = [self addRootLabelWithfram:CGRectMake(10, 30, ScreenWith/5, 20) andTitleColor:[UIColor whiteColor] andFont:17.0 andBackGroundColor:[UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1] andTitle:@"5000"];
    self.goldCoin = label2;
    [backGroundView addSubview:label2];

    
    UIButton * shaiBt = [self addRootButtonNewFram:CGRectMake(ScreenWith - ScreenWith/12 - 10, 10, ScreenWith/12, ScreenWith/12) andSel:@selector(shaiButtonAction) andTitle:@"晒"];
    [backGroundView addSubview:shaiBt];
    [shaiBt setTitleColor:[UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1] forState:UIControlStateNormal];
    
    
    
    [self addRoundLabelWithParentView:backGroundView];
    
    
    
    return backGroundView;
}


- (void)addRoundLabelWithParentView:(UIView *)view{

    NSArray * dayArray = @[@"1天",@"10天",@"20天",@"30天"];
    NSArray * coinArray = @[@"+0.02元",@"+0.1元",@"+0.3元",@"+0.5元"];
    
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith * 3/4 - ScreenWith/14, 3)];
    line.center = CGPointMake(ScreenWith/2, view.frame.size.height *2/3 + ScreenWith/24);
    line.backgroundColor = [UIColor whiteColor];
    [view addSubview:line];
    
    
    //签到进度条
    CAShapeLayer * shape = [CAShapeLayer layer];
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, 0)];
    [bezierPath addLineToPoint:CGPointMake(ScreenWith*3/4 - ScreenWith/14, 0)];
    
    shape.position = CGPointMake(0, 1.5);
    shape.path = bezierPath.CGPath;
    shape.strokeColor = [UIColor cyanColor].CGColor;
    shape.fillColor = [UIColor clearColor].CGColor;
    
    shape.strokeStart = 0.0;
    shape.strokeEnd = 0.0;
    shape.lineWidth = 3.0;
    
    self.signLineProgress = shape;
    [line.layer addSublayer:shape];

    
    
    
    
    
    
    for (int i = 0; i < 4; i++) {
     
        UILabel * label = [self addRootLabelWithfram:CGRectMake(15 + (ScreenWith/12 + (ScreenWith - 30 - ScreenWith * 4/12)/3)*i, view.frame
                                                                .size.height * 2/3, ScreenWith/12, ScreenWith/12)
                                       andTitleColor:[UIColor lightGrayColor]
                                             andFont:11.0
                                  andBackGroundColor:[UIColor whiteColor]
                                            andTitle:dayArray[i]];
        label.center = CGPointMake(ScreenWith/8 + ScreenWith/4 *i, view.frame.size.height *2/3 + ScreenWith/24);
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = ScreenWith/24;
        label.clipsToBounds = YES;
        label.layer.borderColor = [UIColor lightGrayColor].CGColor;
        label.layer.borderWidth = 1.0;
        [view addSubview:label];
        
        UILabel * label2 = [self addRootLabelWithfram:CGRectMake(ScreenWith/4*i, CGRectGetMaxY(label.frame), ScreenWith/4, ScreenWith/12)
                                       andTitleColor:[UIColor whiteColor]
                                             andFont:13.0
                                  andBackGroundColor:[UIColor whiteColor]
                                            andTitle:coinArray[i]];
        label2.textAlignment = NSTextAlignmentCenter;
        label2.backgroundColor = [UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1];
        [view addSubview:label2];

        [self.tableHeadViewFourLabelArray addObject:label2];
    }
}


- (void)shaiButtonAction{
    NSLog(@"晒");
    
    ShaiShaiMyIncomeVC * vc = [[ShaiShaiMyIncomeVC alloc]init];
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}


- (void)EveryDaySignButtonAction:(UIButton *)bt{
    
    NSLog(@"每天签到");
    
    NetWork * net = [NetWork shareNetWorkNew];
    
    [net userRegisterEveryDay];
    
    __weak TestCenterVC * weakSelf = self;
    
    net.registerEveryDayBK=^(NSString * code,NSString * message,NSString * amount,NSArray * arr1,NSArray * arr2){
    
        NSLog(@"%@%@%@",code,message,amount);
        
        
        if ([code isEqualToString:@"1"]) {
            
            [weakSelf getDataFromNet];
            
        }
        
        
        [weakSelf rootShowMBPhudWith:message andShowTime:1.5];
        
    };
}

- (void)tableViewNew:(UIView *)headView{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, ScreenWith, ScreenHeight - 64 ) style:UITableViewStyleGrouped];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.rowHeight = ScreenWith/9;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableHeaderView = headView;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJRefreshData)];
    
    [tableView.mj_header beginRefreshing];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell_zero"];
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell_zero"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        cell.imageView.image = [UIImage imageNamed:@"ic_redpack"];
        
        cell.textLabel.text = @"邀请分享 月赚1000";
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        cell.detailTextLabel.text = @"邀请一个送2元，还能享受徒弟进贡";
        cell.detailTextLabel.textColor =[UIColor redColor];
        return cell;

    }else if (indexPath.section == 1){
    
        MineHighProFitTypeTowCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell_one"];
        if (cell == nil) {
            
            cell = [[MineHighProFitTypeTowCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell_one"];
        }
        
        cell.heightModel = self.model.heightModelArray[indexPath.row];
        return cell;

    }else {
    
        
        
        NSMutableArray *  iconArray = [NSMutableArray arrayWithArray:@[@"dr",@"qiandao",@"yqhy",@"wzfx",@"sy",@"wz",@"fk",@"pl",@"dz"]];
        NSMutableArray *  titleArray = [NSMutableArray arrayWithArray:@[@"首次登陆",@"签到奖励",@"邀请分享",@"分享文章",@"徒弟收益",@"阅读文章",@"有奖反馈",@"优质评论",@"评论点赞"]];
        
        
        if (self.coinArray.count == 0) {
            
             NSMutableArray * coinArray = [NSMutableArray arrayWithArray:@[@"+0000",@"+00",@"+0000",@"+00",@"+00",@"+0",@"+000",@"+000",@"+0"]];
            
            self.coinArray = [NSMutableArray arrayWithArray:coinArray];
            
        }
        
            SectionThreeCell * cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell_%ld",indexPath.row]];
        
            if (cell == nil) {
                
                cell = [[SectionThreeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"cell_%ld",indexPath.row]];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

            }
        
        
        cell.icon.image = [UIImage imageNamed:iconArray[indexPath.row]];
        cell.title.text = titleArray[indexPath.row];
        
        if (indexPath.row == 4) {
            cell.coinLabel.attributedText = [cell addCellAppandRootAttributedText1:[NSString stringWithFormat:@"%@",self.coinArray[indexPath.row]] andText2:@"" andColor1:[UIColor redColor] andColor2:[UIColor blackColor] andFont2:13.0 andFont2:13.0];

        }else{
            cell.coinLabel.attributedText = [cell addCellAppandRootAttributedText1:[NSString stringWithFormat:@"+%@",self.coinArray[indexPath.row]] andText2:@"元" andColor1:[UIColor redColor] andColor2:[UIColor blackColor] andFont2:13.0 andFont2:13.0];
        }
    
        NSString * str = self.explainArray[indexPath.row];
        
        CGRect respondStr_fram = [str boundingRectWithSize:CGSizeMake(ScreenWith - 60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]} context:nil];
        
        cell.explainLabel.frame = CGRectMake(30, ScreenWith/8, ScreenWith - 60, respondStr_fram.size.height);
        cell.explainLabel.text = self.explainArray[indexPath.row];
        cell.explainLabel.numberOfLines = 0;
        [cell.explainLabel sizeToFit];
        
        /*
        if (indexPath.row == 0) {
            
            cell.middleLabel.text = [NSString stringWithFormat:@"%@/1",self.model.hb_new_hb_num];
        }else if (indexPath.row == 1){
            cell.middleLabel.text = [NSString stringWithFormat:@"%@/1",self.model.signDay_num];

        }else if (indexPath.row == 5){
            cell.middleLabel.text = [NSString stringWithFormat:@"%@/20",self.model.read_num];

        }else if (indexPath.row == 6){
            cell.middleLabel.text = [NSString stringWithFormat:@"%@/1",self.model.feedback_num];

        }else if (indexPath.row == 7){
            cell.middleLabel.text = [NSString stringWithFormat:@"%@/1",self.model.comment_num];

        }else if (indexPath.row == 8){
            cell.middleLabel.text = [NSString stringWithFormat:@"%@/5",self.model.up_data_num];

        }else{
        
        }
        
        */
        
        return cell;

    }
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    
    if (indexPath.section == 0) {
        return ScreenWith/6;
    }else if (indexPath.section == 1){
        
        return ScreenWith/4 + 20;
    }else {
        
        if ( indexPath.row == self.currentIndex) {
            
            
            NSString * str = self.explainArray[indexPath.row];
            
            CGRect respondStr_fram = [str boundingRectWithSize:CGSizeMake(ScreenWith - 60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]} context:nil];
            
            NSLog(@"w = %f h= %f",respondStr_fram.size.width,respondStr_fram.size.height);

            
            NSLog(@"%ld <=====> %ld",self.lastIndex,self.currentIndex);
            
            if ((self.lastIndex == self.currentIndex) && self.isOpen == NO) {
                
                self.lastIndex = 1000000;
                
                return ScreenWith/8;

            }else if (self.lastIndex == 1000000 && self.isOpen == NO){
            
                return ScreenWith/8;

            
            } else{
            
                self.lastIndex = self.currentIndex;
                                
                return respondStr_fram.size.height + ScreenWith/8 + 5;
            }
            
        }else{

            return ScreenWith/8;

        }
        
    }
    
   
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
    
        if (self.hiddenCell == YES) {
            
            return 0;
        }
        
        return 0;
        
    }else if (section == 1){

        return 0;

        /*
        NSInteger count = self.model.heightModelArray.count;

        if (count > 3 && self.isLookMore == NO) {
            
            count = 3;
        }
        
        return count;
        */
        
    }else{
        
            return 5;
        
    }
 
        
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.section == 1) {
        
        ArticleListModel * model = self.model.heightModelArray[indexPath.row];
        
        
        WKWebViewController * wk = [[WKWebViewController alloc]init];
       
        wk.isPost = NO;
        wk.article_id = [NSString stringWithFormat:@"%d",model.id];
        wk.articleModel = model;
        wk.isVideo = NO;
        wk.isHeightPrice = YES;
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wk animated:YES];
        
    }else if (indexPath.section == 2) {
        
        
        SectionThreeCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        
        NSInteger row = indexPath.row;
        
        self.currentIndex = row;
        
    
        if(cell.isOpen == NO){
            
            [UIView animateWithDuration:0.6 animations:^{
                
                cell.explainLabel.alpha = 1;

            }];
            
            cell.isOpen = YES;
            
            self.isOpen = YES;
            
        }else{
        
            [UIView animateWithDuration:0.1 animations:^{
                
                cell.explainLabel.alpha = 0;
                
            }];
            cell.isOpen = NO;
            
            self.isOpen = NO;
        }
        
        
        if (self.lastCell && (self.lastCell != cell)) {
            
            if (self.lastCell.isOpen == YES) {
                
                self.lastCell.explainLabel.alpha = 0;
                self.lastCell.isOpen = NO;
                                
            }else{
            
            }
            
        }
        
        
        self.lastCell = cell;

        
        
        [tableView beginUpdates];
        
        [tableView endUpdates];
        

        
            
//            [tableView beginUpdates];
//            
//            NSArray * indexPaths = @[[NSIndexPath indexPathForRow:row inSection:2]];
//            
//            [tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
//            
//            [tableView endUpdates];
//            
            

 
        
        
        
        
    }else if(indexPath.section == 0){
    
        InviateFriendTypeTwoVC * vc = [[InviateFriendTypeTwoVC alloc]init];
    
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    

}

#pragma mark- 分组高度
//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
 
//    if (section == 0) {
//        return 5;//section头部高度
//
//    }else{
//        return ScreenWith/11;//section头部高度
//
//    }
    
    if (section == 2) {
        
        return ScreenWith/11;
    }else{
    
        return 0.1;
    }
    
}


//section头部视图
- (UIView * )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section == 2) {
//        UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWith, 5)];
//        view.backgroundColor = [UIColor clearColor];
//        return view ;
//    }else if (section == 1){
//        UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenWith/11)];
//        label.backgroundColor = [UIColor whiteColor];
//        label.text = @"   高价任务";
//        label.font = [UIFont systemFontOfSize:15];
//        label.textColor = [UIColor blackColor];
//        return label ;
//        
//    }else{
        
        
        UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenWith/11)];
        view.backgroundColor = [UIColor whiteColor];

        UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWith/2, ScreenWith/11)];
        label.backgroundColor = [UIColor whiteColor];
        label.text = @"   更多任务";
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor blackColor];
        
        UILabel * label2=[[UILabel alloc] initWithFrame:CGRectMake(ScreenWith/2, 0, ScreenWith/2 -10, ScreenWith/11)];
        label2.backgroundColor = [UIColor whiteColor];
        label2.text = @"金额说明 ?";
        label2.font = [UIFont systemFontOfSize:14];
        label2.textColor = [UIColor blackColor];
        label2.textAlignment = NSTextAlignmentRight;
        [view addSubview:label];
        [view addSubview:label2];
        return view ;
    }else{
    
        UIView * view = [[UIView alloc]init];
    
        return view;
    }
    
}


//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    
//    NSInteger count = self.model.heightModelArray.count;
//    
//    
//    if (section == 1 && count > 3 && self.isLookMore == NO) {
//        
//        return ScreenWith/10;
//        
//    }
//
    
    
    return 5.0;

}
//section底部视图
- (UIView * )tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
//    
//    NSInteger count = self.model.heightModelArray.count;
//    
//    
//    if (section == 1 && count > 3 && self.isLookMore == NO) {
//        
//        
//        UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenWith/10)];
//        view.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];
//
//        
//        UIButton * button = [self addRootButtonNewFram:CGRectMake(0, 0, ScreenWith, ScreenWith/10 - 5) andSel:@selector(lookMoreArticl) andTitle:@"查看更多"];
//        button.backgroundColor = [UIColor whiteColor];
//        button.titleLabel.textColor = [UIColor blackColor];
//        button.layer.cornerRadius = 0.0;
//        [view addSubview:button];
//        
//        return view;
//    }

    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWith, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
    
}


//查看更多
- (void)lookMoreArticl{

    self.isLookMore = YES;

    [self.tableView reloadData];
}


@end
