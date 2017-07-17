//
//  RespondGiftVC.m
//  聊天界面
//
//  Created by root on 17/3/12.
//  Copyright © 2017年 root. All rights reserved.
//

#import "RespondGiftVC.h"

@interface RespondGiftVC()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSMutableArray * dataStringArray;

@property (nonatomic,strong)UITextField * textField;


@property (nonatomic,strong)UIView * textsView;

@property (nonatomic,strong)NSString * pushString;

@property (nonatomic,assign)NSInteger page;

@property (nonatomic,assign)BOOL isRefresh;


@end

@implementation RespondGiftVC


- (void)viewDidLoad{

    [super viewDidLoad];
    
    self.page = 1;
    self.isRefresh = YES;
    
    self.view.backgroundColor =[ UIColor whiteColor];

    self.dataStringArray = [NSMutableArray new];

    [self addUI];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self registerForKeyboardNotifications];
}


- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)addUI{

    [super addUI];
    
    self.titleLabel.text=@"客服反馈";
    
    [self addTableViewNew];
    
    [self addTextFieldViewNew];
    
    [self QQButtonCreatNew];
}



#pragma mark- 官方QQ QQ群
- (void)QQButtonCreatNew{

    BOOL canOpenQQ = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]];
    
    if (canOpenQQ == NO) {
        
        return;
    }
    
    
    UIButton * mainQQ = [self addRootButtonTypeTwoNewFram:CGRectMake(10, 70, ScreenWith/7, ScreenWith/7) andImageName:@"" andTitle:@"官方群" andBackGround:[UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1] andTitleColor:[UIColor whiteColor] andFont:12.0 andCornerRadius:ScreenWith/14];
    [self.view addSubview:mainQQ];

    [mainQQ addTarget:self action:@selector(openQQ) forControlEvents:UIControlEventTouchUpInside];
    
    /*
    UIButton * QQGroup = [self addRootButtonTypeTwoNewFram:CGRectMake(10, 70 + ScreenWith/7 + 10, ScreenWith/7, ScreenWith/7) andImageName:@"" andTitle:@"官方群" andBackGround:[UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1] andTitleColor:[UIColor whiteColor] andFont:12.0 andCornerRadius:ScreenWith/14];
    [self.view addSubview:QQGroup];
    [QQGroup addTarget:self action:@selector(openQQGroup) forControlEvents:UIControlEventTouchUpInside];
    */
}



- (void)openQQ{

//    [self qqChatActionWitnUin:@""];
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NetWork * net = [NetWork shareNetWorkNew];
    [net getQQnumberFromNet];
    
    __weak RespondGiftVC * weakSelf = self;
    
    net.QQnumberLinkGetBK = ^(NSString * code, NSString * qq, NSString * key,NSArray * arr1,NSArray * arr2) {
        
        [hud hideAnimated:YES];
        
        if ([code isEqualToString:@"1"]) {
            
            [weakSelf joinGroup:qq key:key
             ];
            
        }else{
            
            
        }
        
        
    };

}


- (void)openQQGroup{

//    [self joinGroup:@"" key:@""];
    
    
   
    
}

//加群
- (BOOL)joinGroup:(NSString *)groupUin key:(NSString *)key{
    
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external", groupUin,key];
    
    
    NSURL *url = [NSURL URLWithString:urlStr];
    if([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
        return YES;
    }
    else return NO;
}


//聊天
- (void)qqChatActionWitnUin:(NSString *)uin{
    
    NSLog(@"qqChat");
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    // 提供uin, 你所要联系人的QQ号码
    NSString *qqstr = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",@"1027355279"];
    NSURL *url = [NSURL URLWithString:qqstr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
}


- (void)MJreloadData{
    self.page = 1;
    self.isRefresh = YES;
    [self getDataFromNetWithPage:self.page];

}



- (void)MJloadMoreData{

    self.page ++;
    self.isRefresh = NO;
    
    [self getDataFromNetWithPage:self.page];
}


- (void)getDataFromNetWithPage:(NSInteger)page{

    NetWork * net = [NetWork shareNetWorkNew];
    
    [net respondListFromNetWithPage:page];
    
    __weak RespondGiftVC * weakSelf = self;
    
    net.respondListBK=^(NSString * code,NSString * message,NSString * str,NSArray * dataArray,NSArray * arr){
    
        if (dataArray.count > 0) {
            
        
        
            if (weakSelf.isRefresh) {
            
                self.dataStringArray = [NSMutableArray arrayWithArray:dataArray];
            
        
            }else{
        
        
                [self.dataStringArray addObjectsFromArray:dataArray];
        
            }
        
            [weakSelf.tableView reloadData];
            
            
            [weakSelf setToBottom];
            
            
        
        }
        
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
    };
    
}



- (void)addTextFieldViewNew{


    UIView * view =[[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 50, self.view.bounds.size.width, 50)];

    view.backgroundColor = [UIColor whiteColor];
    
    view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    view.layer.shadowOpacity = 0.8;
    view.layer.shadowOffset = CGSizeMake(0, 0);
    self.textsView = view;
    [self.view addSubview:view];
    
    
    
    UITextField * textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width*3/4, 30)];
    
    textField.backgroundColor =[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];
    textField.layer.cornerRadius = 3;
    textField.placeholder = @" 期待您的意见反馈";
    textField.delegate = self;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField = textField;
    [view addSubview:textField];

    
    UIButton * pushBt = [UIButton buttonWithType:UIButtonTypeCustom];
    pushBt.frame = CGRectMake(CGRectGetMaxX(textField.frame) + 10, 10, self.view.bounds.size.width/4 - 10 - 10 - 10, 30);
    [pushBt setTitle:@"发送" forState:UIControlStateNormal];
    pushBt.backgroundColor =[UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1];
    pushBt.layer.cornerRadius = 3;
    [pushBt addTarget:self action:@selector(pushuBtAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:pushBt];

    
}

- (void)pushuBtAction{

    [self.textField resignFirstResponder];

    if (self.pushString == nil || [self.pushString isEqualToString:@""]) {
        

        return;
    }
    
    NSLog(@"发送");

    
    [self sendStringWithContent:self.pushString];
    
}



- (void)sendStringWithContent:(NSString *)content{

    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    NetWork * net = [NetWork shareNetWorkNew];
    
    [net respondSendToNetWithContent:content];

    __weak RespondGiftVC * weakSelf = self;
    
    net.respondSendBk=^(NSString * code,NSString * message){
    
        [hud hideAnimated:YES];
        
        [weakSelf rootShowMBPhudWith:message andShowTime:0.5];
        
        
        if ([code isEqualToString:@"1"]) {
            
            
            [self MJreloadData];

        }
        
        
    };
    
}


- (void)addTableViewNew{

    UITableView * tableView =[[ UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 50) style:UITableViewStylePlain];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 50;
    tableView.tableFooterView =[[ UIView alloc]init];
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
    self.tableView = tableView;
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJreloadData)];
    
    tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(MJloadMoreData)];
    
    [tableView.mj_header beginRefreshing];

}


#pragma mark-滑到底部
- (void)setToBottom{
    //        滑到底部
    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        
        [self.tableView setContentOffset:offset animated:NO];
        
    }else {
        
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.bounds.size.height) animated:NO];
        
    }


}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

//        return 10;
    return self.dataStringArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    RespondGiftCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        
        cell = [[RespondGiftCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell.iconImageV sd_setImageWithURL:[NSURL URLWithString:self.mineModel.headimgurl]];
    
    
    RespondListModel * model = self.dataStringArray[indexPath.row];
    NSString * str = model.content;
    
    CGFloat text_H = 50;
    CGFloat text_W = [UIScreen mainScreen].bounds.size.width - 90;
    
    
    CGRect stringFram_w = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSForegroundColorAttributeName :[UIFont systemFontOfSize:16.0]} context:nil];
    
    NSLog(@"%f",stringFram_w.size.width);
    
    NSLog(@"%f",[UIScreen mainScreen].bounds.size.width - 90);
    
    
    //长度计算
    CGSize size =[str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]}];
    
    NSLog(@"%f",size.width);
    
    //    超长怎多行显示
    if (size.width > [UIScreen mainScreen].bounds.size.width - 90) {
        
        CGRect stringFram_h = [str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 90, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSForegroundColorAttributeName :[UIFont systemFontOfSize:16.0]} context:nil];
        
        NSLog(@"%f",6 + 50 + stringFram_h.size.height - 50 + 6);
        
         text_H =   50 + stringFram_h.size.height ;
        
        cell.stringLabel.numberOfLines = 0;
        
    }else{
        
        text_W = size.width;
    }

    
    UIImage * image = [UIImage imageNamed:@"chat_qp"];

    CGFloat top = image.size.height*2/3; // 顶端盖高度
    CGFloat bottom = 10 ; // 底端盖高度
    CGFloat left = 10; // 左端盖宽度
    CGFloat right = 20; // 右端盖宽度
    
    // 指定为拉伸模式，伸缩后重新赋值
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    cell.textImageView.frame = CGRectMake(CGRectGetMinX(cell.iconImageV.frame) - text_W - 15, 6, text_W + 15,text_H);
    cell.textImageView.image = image;
    
    cell.stringLabel.frame = CGRectMake(CGRectGetMinX(cell.iconImageV.frame) - text_W - 10, 6, text_W,text_H);
    cell.stringLabel.text = str;
    
    
    return cell;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    RespondListModel * model = self.dataStringArray[indexPath.row];
    
    NSString * str = model.content;
    
    CGRect stringFram_w = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSForegroundColorAttributeName :[UIFont systemFontOfSize:16.0]} context:nil];
    
    NSLog(@"%f",stringFram_w.size.width);
    
    NSLog(@"%f",[UIScreen mainScreen].bounds.size.width - 90);

    
    //长度计算
    CGSize size =[str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]}];
    
    NSLog(@"%f",size.width);

//    超长则多行显示
    if (size.width > [UIScreen mainScreen].bounds.size.width - 90) {
        
        CGRect stringFram_h = [str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 90, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSForegroundColorAttributeName :[UIFont systemFontOfSize:16.0]} context:nil];
    
        NSLog(@"%f",6 + 50 + stringFram_h.size.height - 50 + 6);
        
        return 6 + 50 + stringFram_h.size.height + 6;
        
    }else{
    
        return 50 + 6 + 6;
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField{

    self.pushString = textField.text;
    
    NSLog(@"DidEndEditing=%@",textField.text);

    NSLog(@"DidEndEditing-pushString=%@",self.pushString);

    self.textField.text =@"";
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self.textField resignFirstResponder];

}

- (void)registerForKeyboardNotifications
{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillChangeFrameNotification object:nil];
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWillShown:(NSNotification*)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    
    NSLog(@"%f",keyboardSize.height);
    NSLog(@"%f",keyboardSize.width);
    
    
    
    //输入框位置动画加载
    [UIView animateWithDuration:duration animations:^{
        //do something
        
        self.textsView.frame = CGRectMake(0, self.view.bounds.size.height - keyboardSize.height-50, self.view.bounds.size.width,50);
        
        
    }];
}
//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification{     //do something
    
    
    [UIView animateWithDuration:0.2 animations:^{
        self.textsView.frame = CGRectMake(0, self.view.bounds.size.height - 50, self.view.bounds.size.width, 50);
        
    }];
    
    
}

@end
