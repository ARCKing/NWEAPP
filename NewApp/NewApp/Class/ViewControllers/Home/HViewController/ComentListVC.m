//
//  ComentListVC.m
//  NewApp
//
//  Created by gxtc on 17/3/2.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "ComentListVC.h"

@interface ComentListVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong)NSMutableArray * dataArray;

@property(nonatomic,strong)CommentListModel * currentModel;

/***/
@property(nonatomic,strong)NSMutableArray * cellHeighArray;

@property(nonatomic,strong)NSMutableArray * respondHeightArray;

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,assign)BOOL isNew;

@end

@implementation ComentListVC


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self registerForKeyboardNotifications];
    
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.dataArray = [NSMutableArray new];
    self.cellHeighArray = [NSMutableArray new];
    self.respondHeightArray = [NSMutableArray new];
    self.page = 1;
    
    [self addUI];
    
    [self getListFromNetWithAid:self.aid];
}

- (void)addUI{
    
    self.navigationBarView = [self NavBarViewNew];
    self.navigationBarView.backgroundColor =[UIColor whiteColor];
    [self addTitleLabelNew];
    self.titleLabel.text = @"评论列表";
    [self addLeftBarButtonNew];
    [self addLineNew];
    
    [self tableViewNew:[self headView]];
    
    
    [self addBottomButton];
}



- (void)getListFromNetWithAid:(NSString *)aid{

    NetWork * net = [NetWork shareNetWorkNew];
    [net getCommentListDataFromNetWithAid:aid andPage:self.page];

    
    NSLog(@"%ld",self.page);
    
    __weak ComentListVC * weakSelf = self;
    
    net.commentListBK=^(NSString * code,NSString * message,NSString * str,NSArray * dataArray,NSArray * data){
    
        
        if (weakSelf.page == 1) {
            weakSelf.dataArray = [NSMutableArray arrayWithArray:dataArray];
            [weakSelf.tableView.mj_header endRefreshing];

        }else{
            [weakSelf.dataArray addObjectsFromArray:dataArray];
            [weakSelf.tableView.mj_footer endRefreshing];

        }
        
        
        NSLog(@"%@",message);
        
        [weakSelf.tableView reloadData];
        
        
    };
    
}



- (UILabel *)headView{
    UILabel * label = [self addRootLabelWithfram:CGRectMake(0, 0, ScreenWith, ScreenWith/12) andTitleColor:[UIColor blackColor] andFont:15.0 andBackGroundColor:[UIColor colorWithRed:0.0 green:217.0/255.0 blue:1.0 alpha:1.0] andTitle:@"   最新评论"];
    return label;
}


- (void)addBottomButton{

    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - ScreenWith/10, ScreenWith, ScreenWith/10)];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.layer.shadowOffset = CGSizeMake(0, 0);
    bottomView.layer.shadowOpacity = 0.8;
    bottomView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    UIButton * commentBt = [self addRootButtonNewFram:CGRectMake(30, (ScreenWith/10 - ScreenWith/12)/2, ScreenWith - 60, ScreenWith/12) andSel:@selector(rootWriteCommentButtonAction) andTitle:@"写评论"];
    commentBt.layer.borderWidth = 1.0;
    commentBt.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [bottomView addSubview:commentBt];
    [self.view addSubview:bottomView];
}





#pragma mark- 下拉刷新
- (void)MJdataReload{
    
//    [self tableViewNew:[self headView]];
    self.page = 1;
    [self getListFromNetWithAid:self.aid];
}


#pragma mark- 上拉加载
- (void)MJdataLoadMore{
    
    self.page += 1;
    [self getListFromNetWithAid:self.aid];

}

- (void)tableViewNew:(UIView *)tableHeadView{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, ScreenWith, ScreenHeight - 64 - ScreenWith/9) style:UITableViewStylePlain];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.rowHeight = ScreenWith/5;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableFooterView = [[UIView alloc]init];
    tableView.tableHeaderView = tableHeadView;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJdataReload)];
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(MJdataLoadMore)];
    
    [tableView.mj_header beginRefreshing];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    CommentListCell * cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%ld_cell",indexPath.row]];
    if (cell == nil) {
        
        cell = [[CommentListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%ld_cell",indexPath.row]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
    
        [cell.detailComentTextLabel removeFromSuperview];
        [cell.respondLabel removeFromSuperview];
        
    }
    

    
    cell.zanButton.tag = indexPath.row + 1110;
    cell.respondButton.tag = indexPath.row + 1110;
    
    
    [cell.zanButton addTarget:self action:@selector(zanButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.respondButton addTarget:self action:@selector(respondsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    CommentListModel * model = self.dataArray[indexPath.row];
    
    NSInteger count = self.dataArray.count;
    
    cell.numberLabel.text = [NSString stringWithFormat:@"%ld",count -indexPath.row];
    cell.model = model;
    
//    CGFloat cellHeigh = [self.cellHeighArray[indexPath.row] floatValue];

    
    CGFloat respondTotaleHeight = 0.0;
    
    NSDictionary * dic = model.rel_comment;
    NSString * userName = dic[@"username"];
    NSString * content = dic[@"content"];
    
    if (userName && content) {
        
        NSString * str = [NSString stringWithFormat:@"\n%@:\n%@\n",userName,content];
        
        CGRect respondStr_fram = [str boundingRectWithSize:CGSizeMake(ScreenWith*3/4, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]} context:nil];
        
        NSLog(@"w = %f h= %f",respondStr_fram.size.width,respondStr_fram.size.height);
        
        respondTotaleHeight  = respondStr_fram.size.height;
        
        cell.respondLabel.frame = CGRectMake(CGRectGetMaxX(cell.imageV.frame) + 5, CGRectGetMaxY(cell.timeLabel.frame) + 5, ScreenWith *3/4, respondTotaleHeight);
        
        cell.respondLabel.text = [NSString stringWithFormat:@"%@",str];
        cell.respondLabel.layer.borderWidth = 1.0;
        cell.respondLabel.layer.borderColor = [UIColor colorWithRed:0.0 green:217.0/255.0 blue:1.0 alpha:0.8].CGColor;
//        [cell.respondLabel sizeToFit];
        
        [cell.contentView addSubview:cell.respondLabel];
        
    }
    
    
    
    CGRect frame_str = [model.content boundingRectWithSize:CGSizeMake(ScreenWith * 2/3, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil];
    
    
    if (respondTotaleHeight > 0) {
         cell.detailComentTextLabel.frame = CGRectMake(CGRectGetMaxX(cell.imageV.frame) + 5, CGRectGetMaxY(cell.timeLabel.frame)+10+respondTotaleHeight, ScreenWith * 3/4, frame_str.size.height);
    }else{
    
    cell.detailComentTextLabel.frame = CGRectMake(CGRectGetMaxX(cell.imageV.frame) + 5, CGRectGetMaxY(cell.timeLabel.frame) + 5, ScreenWith * 3/4, frame_str.size.height);
    }
    NSLog(@"%f",frame_str.size.height);
    
    cell.detailComentTextLabel.text = model.content;
    
    [cell.detailComentTextLabel sizeToFit];
    
    [cell.contentView addSubview:cell.detailComentTextLabel];

    
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (self.dataArray.count <= 0) {
        return 0;
    }
    
    CommentListModel *  model = self.dataArray[indexPath.row];
    
    CGFloat respondTotaleHeight = 0.0;
    
    NSDictionary * dic = model.rel_comment;
    NSString * userName = dic[@"username"];
    NSString * content = dic[@"content"];
        
        if (userName && content) {
        
        NSString * str = [NSString stringWithFormat:@"\n%@\n%@\n",userName,content];
            
        CGRect respondStr_fram = [str boundingRectWithSize:CGSizeMake(ScreenWith*3/4, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]} context:nil];
            
        NSLog(@"w = %f h= %f",respondStr_fram.size.width,respondStr_fram.size.height);
            
        respondTotaleHeight  = respondStr_fram.size.height;
        

        NSString * content = model.content;
        CGRect content_fram = [content boundingRectWithSize:CGSizeMake(ScreenWith * 2/3, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil];
        
        [self.cellHeighArray addObject:[NSString stringWithFormat:@"%f",ScreenWith/7 + respondTotaleHeight + content_fram.size.height]];

            CGFloat finallyHeigh = ScreenWith/7 + respondTotaleHeight + content_fram.size.height;
            
        return finallyHeigh + 5;
            
        }else{
        
            NSString * content = model.content;
            CGRect content_fram = [content boundingRectWithSize:CGSizeMake(ScreenWith * 2/3, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil];
            
            [self.cellHeighArray addObject:[NSString stringWithFormat:@"%f",ScreenWith/7  + content_fram.size.height]];
            
            CGFloat finallyHeigh = ScreenWith/7 + content_fram.size.height;
            
            return finallyHeigh;
            

        }
        
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"我点击了%ld",indexPath.row);
}




/**赞*/
- (void)zanButtonAction:(UIButton *)bt{
    NSLog(@"%ld",bt.tag);

    CommentListModel * model = self.dataArray[bt.tag - 1110];
    
    NetWork * net = [NetWork shareNetWorkNew];
    
    [net writeCommentAndRespondWithTypr:commentType_zan andContent:@"" andID:[NSString stringWithFormat:@"%d",model.id] andAID:@"" andRelation:@"" andRelname:@""];
    
    __weak ComentListVC * weakSelf = self;
    net.commentBK=^(NSString * code,NSString * message){
        
        [weakSelf rootShowMBPhudWith:message andShowTime:1.0];
        
        if ([code isEqualToString:@"1"]) {
            
            NSInteger up = [model.up integerValue];
            
            [bt setTitle:[NSString stringWithFormat:@"%ld赞",up + 1] forState:UIControlStateNormal];
        }else{
        
//            [weakSelf rootShowMBPhudWith:message andShowTime:1.0];

        }
        
        
    };
    
    
//    [UIView animateWithDuration:0.5 animations:^{
//        
//        [self.textView resignFirstResponder];
//        self.commentView.frame = CGRectMake(0, ScreenHeight, ScreenWith, ScreenWith/2);
//        
//    }completion:^(BOOL finished) {
//        
//        
//    }];

    
}

/**回复*/
- (void)respondsButtonAction:(UIButton *)bt{
    NSLog(@"%ld",bt.tag);

    self.isComment = NO;
    
    if (self.isCommnetViewShow) {
        
        return;
    }
    
    CommentListModel * model = self.dataArray[bt.tag - 1110];

    self.currentModel = model;
    
    [self addRootCommentViewNew];
    
    [self.commentViewPushButton addTarget:self action:@selector(respondPushButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.placeHolderLabel.text = [NSString stringWithFormat:@"    回复:%@",model.username];
    [self.textView becomeFirstResponder];

    self.isCommnetViewShow = YES;
    
}

/**回复Action*/
- (void)respondPushButtonAction{


    CommentListModel * model = self.currentModel;
    
    NetWork * net = [NetWork shareNetWorkNew];
    
    
    [net writeCommentAndRespondWithTypr:commentType_responds andContent:self.commentString andID:[NSString stringWithFormat:@"%d",model.id] andAID:self.aid andRelation:model.uid andRelname:model.username];
    
    __weak ComentListVC * weakSelf = self;
    net.commentBK=^(NSString * code,NSString * message){
        
        [weakSelf rootShowMBPhudWith:message andShowTime:1.0];
        weakSelf.isCommnetViewShow = NO;
        weakSelf.isComment = YES;
        
        
        if ([code isEqualToString:@"1"]) {
            
            [self MJdataReload];
        }
        
    };
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [self.textView resignFirstResponder];
        self.commentView.frame = CGRectMake(0, ScreenHeight, ScreenWith, ScreenWith/2);
        
    }completion:^(BOOL finished) {
        
        
    }];


}



#pragma mark- 评论框
- (void)rootWriteCommentButtonAction{
    [super rootWriteCommentButtonAction];
    
    [self addRootCommentViewNew];
    
    self.isCommnetViewShow = YES;
    
    [self.textView becomeFirstResponder];
}



- (void)rootCommentViewPushButtonAction{
    [super rootCommentViewPushButtonAction];
    
    NSLog(@"评论:%@",self.commentString);
  
    
    if (self.isComment == NO) {
        
        return;
    }
    
    
    NetWork * net = [NetWork shareNetWorkNew];
    
    
    [net writeCommentAndRespondWithTypr:commentType_comment andContent:self.commentString andID:@"" andAID:self.aid andRelation:@"" andRelname:@""];
    
    __weak ComentListVC * weakSelf = self;
    net.commentBK=^(NSString * code,NSString * message){
        
        [weakSelf rootShowMBPhudWith:message andShowTime:1.0];
        
        weakSelf.isCommnetViewShow = NO;
        
        
        if ([code isEqualToString:@"1"]) {
            
            [self MJdataReload];
        }
        
    };
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [self.textView resignFirstResponder];
        self.commentView.frame = CGRectMake(0, ScreenHeight, ScreenWith, ScreenWith/2);
        
    }completion:^(BOOL finished) {
        
        
    }];
    
}


- (void)rootCommentViewCancleButtonAvtion{
    [super rootCommentViewCancleButtonAvtion];
    
    
    if (self.isComment == NO) {
    
        self.isComment = YES;
        
    }
    
    
    [self.textView resignFirstResponder];
    
    self.isCommnetViewShow = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.commentView.frame = CGRectMake(0, ScreenHeight, ScreenWith, ScreenWith/2);
        
    }completion:^(BOOL finished) {
        
        
    }];
}



- (void)textViewDidChangeSelection:(UITextView *)textView{
    
    NSLog(@"1 textViewDidChangeSelection");
    
    NSLog(@"%@",textView.text);
    
    NSUInteger worldLength = [textView.text length];
    
    self.woeldNumberLabel.text = [NSString stringWithFormat:@"%ld/200",worldLength];
    
    self.commentString = textView.text;
    
    
    if (worldLength > 0) {
        self.placeHolderLabel.hidden = YES;
    }else{
        
        self.placeHolderLabel.hidden = NO;
    }
    
}


- (void)textViewDidEndEditing:(UITextView *)textView{
    
    NSLog(@"2 textViewDidEndEditing");
    
    NSUInteger worldLength = [textView.text length];
    
    self.commentString = textView.text;
    
    self.woeldNumberLabel.text = [NSString stringWithFormat:@"%ld/200",worldLength];
    
    NSLog(@"%ld",worldLength);
}




#pragma mark- 注册键盘监听
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
    
    CGFloat keyBoard_h = keyboardSize.height;
//    CGFloat keyBoard_w = keyboardSize.width;
    
    //输入框位置动画加载
    [UIView animateWithDuration:duration animations:^{
        
        self.commentView.frame = CGRectMake(0, ScreenHeight - keyBoard_h - ScreenWith/2, ScreenWith, ScreenWith/2);
        
    }];
}
//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    
    
    //    [UIView animateWithDuration:0.2 animations:^{
    //
    //        self.commentView.frame = CGRectMake(0, ScreenHeight - ScreenWith/2, ScreenWith, ScreenWith/2);
    //
    //    }];
    
    
}










@end
