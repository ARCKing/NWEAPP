//
//  ServiceQQVC.m
//  NewApp
//
//  Created by gxtc on 2017/5/27.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "ServiceQQVC.h"

@interface ServiceQQVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,copy)NSString * QQ;

@end

@implementation ServiceQQVC



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self addUI];
    
}

- (void)addUI{

    [super addUI];

    self.titleLabel.text = @"QQ";
    [self addTableViewNew];
    
    [self usDataMessage];
    
}




-(void)usDataMessage{
    
    NetWork * net = [NetWork shareNetWorkNew];
    
    [net aboutUsMessageFromNet];
    
    __weak ServiceQQVC * weakSelf = self;
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    net.aboutUsBK= ^(NSString * code,NSString * message,NSString * str, NSArray * dataArray,NSArray * data){
        
        [hud hideAnimated:YES];
        
        if (dataArray.count > 0) {
            
            AboutUsModel * model = dataArray[0];
            
            NSLog(@"%@",model);

            if (weakSelf.type == 0) {
                
                weakSelf.QQ = model.kf_qq;

            }else{
                weakSelf.QQ = model.sw;

            }
            
            weakSelf.tableView.tableFooterView = [self footViewNew];
            [weakSelf.tableView reloadData];
        }
        
    };
    
}


- (UIView *)footViewNew{

    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith/2, ScreenWith/4)];
    view.backgroundColor = [UIColor clearColor];
    
    
    BOOL canOpenQQ = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]];
    
    if (canOpenQQ == NO) {
        
        UIView * view = [[UIView alloc]init];
        
        return view;
    }

    
    
    UIButton * bt = [self addRootButtonNewFram:CGRectMake(30, (ScreenWith/4 - ScreenWith/8)/2, ScreenWith - 60, ScreenWith/8) andSel:@selector(buttonAction) andTitle:@"联系客服"];
    [bt setTitleColor:[UIColor colorWithRed:0 green:191.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    bt.layer.cornerRadius = 3.0;
    bt.backgroundColor = [UIColor clearColor];
    bt.layer.borderColor = [UIColor colorWithRed:0 green:191.0/255.0 blue:1.0 alpha:1.0].CGColor;
    bt.layer.borderWidth = 1.0;
    [view addSubview:bt];
    return view;
}


- (void)buttonAction{


    [self qqChatActionWitnUin:self.QQ];
    
}


//聊天
- (void)qqChatActionWitnUin:(NSString *)uin{
    
    NSLog(@"qqChat");
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    // 提供uin, 你所要联系人的QQ号码
    NSString *qqstr = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",self.QQ];
    NSURL *url = [NSURL URLWithString:qqstr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
}



- (void)addTableViewNew{
    
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, ScreenWith, ScreenHeight - 64 ) style:UITableViewStylePlain];
    
    tableView.rowHeight = ScreenWith/4;
    
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
    self.tableView.tableFooterView = [[UIView alloc]init];

    [self.view addSubview:tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ServiceQQCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell_zero"];
    
    if (cell == nil) {
        
        cell = [[ServiceQQCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell_zero"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    if (self.QQ == nil) {
        
        self.QQ = @"";
    }
    
    [cell setDataWithQQNumber:self.QQ];
    
    return cell;
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 1;
    
}



@end
