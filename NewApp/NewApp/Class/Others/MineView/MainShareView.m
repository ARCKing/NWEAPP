//
//  MainShareView.m
//  NewApp
//
//  Created by gxtc on 17/2/17.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "MainShareView.h"

@interface MainShareView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray * advStringArray;

@property (nonatomic,strong)NSMutableArray * imageViewArray;

@property (nonatomic,strong)UITableView * tableView;

@end
@implementation MainShareView

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        
        self.advStringArray = [NSMutableArray new];
        self.imageViewArray = [NSMutableArray new];
        self.shareType = 404;
        
//        [self advStringGetFromNet];
    }

    return self;
}



- (void)advStringGetFromNet{

    NetWork * net = [NetWork shareNetWorkNew];

    __weak MainShareView * weakSelf = self;
    
    [net advStringGetDataFromNet];
    
    net.advStringBK=^(NSString * code,NSString * message,NSString * str,NSArray * dataAray,NSArray * data){
    
        if ([code isEqualToString:@"1"] && dataAray.count > 0) {
            
            weakSelf.advStringArray = [NSMutableArray arrayWithArray:dataAray];
            
            AdvStringModel * model = dataAray[0];
            
            weakSelf.selectAdvString = model.content;
            
            [weakSelf.tableView reloadData];
        }
    
        
    };
}



- (void)addBottomShareViewNew{

    
    if (self.shareBottomView) {
        
        [self addSubview:self.shareBottomView];

        return;
    }
    
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - ScreenWith/8 - 1 - ScreenWith/4, ScreenWith, ScreenWith/4 + ScreenWith/8)];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    self.shareBottomView = bottomView;
    
    [self addSubview:bottomView];
    
    UIButton * cancleButton = [self addViewRootButtonNewFram:CGRectMake(-1, ScreenWith / 4 + 2, ScreenWith + 2, ScreenWith/8) andImageName:@"" andTitle:@"取消" andBackGround:[UIColor whiteColor] andTitleColor:[UIColor colorWithRed:0.0 green:210.0/255.0 blue:1.0 alpha:1.0] andFont:16.0 andCornerRadius:0.0];
    self.cancleButton = cancleButton;
    cancleButton.layer.borderWidth = 1.0;
    cancleButton.layer.borderColor = [UIColor blackColor].CGColor;
    
    [bottomView addSubview: cancleButton];
    
//    
//    NSArray * imageNames = @[@"weChat_inviate",@"friend_inviate",@"qq_inviate",@"qzone_inviate",@"copy_inviate"];
//    NSArray * titles = @[@"微信分享",@"朋友圈",@"QQ好友",@"QQ空间",@"复制链接"];
    
    
    NSArray * imageNames = @[@"weChat_inviate",@"friend_inviate",@"copy_inviate",@"icon_c"];
    NSArray * titles = @[@"微信分享",@"朋友圈",@"复制链接",@"收藏"];

    
    for (int i = 0; i<4; i++) {
        
        UIButton * bt = [self addViewRootButtonNewFram:CGRectMake((ScreenWith - ScreenWith * 4/6)/5 + (ScreenWith/6 + (ScreenWith - ScreenWith * 4/6)/5) * i, 5, ScreenWith/6, ScreenWith/6) andImageName:imageNames[i] andTitle:@"" andBackGround:[UIColor whiteColor] andTitleColor:[UIColor whiteColor] andFont:15.0 andCornerRadius:0.0];
        
        UILabel * title = [self addViewRootLabelNewWithFram:CGRectMake(CGRectGetMinX(bt.frame), CGRectGetMaxY(bt.frame), ScreenWith/6, 15) andBackGroundColor:[UIColor whiteColor] andTextColor:[UIColor lightGrayColor] andFont:13.0 andTitle:titles[i] andNSTextAlignment:NSTextAlignmentCenter];
        
        [bottomView addSubview:bt];
        [bottomView addSubview:title];
        
        if (i == 0) {
        
            self.WeiXinShareButton = bt;
            
        }else if (i == 1){
            
            self.WeiXinFriendShareButton = bt;
            
        }else if (i == 2){

//            self.QQShareButton = bt;
//            
//        }else if (i == 3){
//
//            self.QzoneShareButton = bt;
//
//        }else{
        
            self.LinkCopyButton = bt;
        }else if (i == 3){
        
            self.collectionButton = bt;
        
        }
    }
}



- (void)addMiddelShareViewNew{
    
    
    UIView * middleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith * 2/3, ScreenHeight * 7/13)];
    middleView.center = self.center;
    middleView.backgroundColor = [UIColor whiteColor];
    middleView.layer.cornerRadius = 6.0;
    middleView.clipsToBounds = YES;
    
    self.shareMiddleView = middleView;
    
    [self addSubview:middleView];
    
    
    UILabel * headTitle = [self addViewRootLabelNewWithFram:CGRectMake((middleView.bounds.size.width - ScreenWith/4)/2,0,ScreenWith/4,ScreenWith/10) andBackGroundColor:[UIColor whiteColor] andTextColor:[UIColor blackColor] andFont:16.0 andTitle:@"邀请好友" andNSTextAlignment:NSTextAlignmentCenter];
    [middleView addSubview:headTitle];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenWith/10+1, ScreenWith * 2/3, 1)];
    line.backgroundColor = [UIColor redColor];
    [middleView addSubview:line];
    
    UIButton * cancleButton = [self addViewRootButtonNewFram:CGRectMake(CGRectGetMaxX(middleView.frame)-10, CGRectGetMinY(middleView.frame)-20,30,30) andImageName:@"" andTitle:@"X" andBackGround:[UIColor whiteColor] andTitleColor:[UIColor blackColor] andFont:16.0 andCornerRadius:15.0];
    self.cancleButton = cancleButton;
    [self addSubview: cancleButton];
    
    
    NSArray * imageNames = @[@"weChat_inviate",@"friend_inviate",@"qq_inviate",@"qzone_inviate",@"copy_inviate"];
    NSArray * titles = @[@"微信分享",@"朋友圈",@"QQ好友",@"QQ空间",@"复制链接"];
    
    for (int i = 0; i<5; i++) {
        
        UIButton * bt = [self addViewRootButtonNewFram:CGRectMake( (ScreenWith * 2/3 - ScreenWith * 2/5)/3 + (ScreenWith/5+(ScreenWith * 2/3 - ScreenWith * 2/5)/3) *(i%2),  ScreenWith/4*(i/2) + CGRectGetMaxY(line.frame) + 5, ScreenWith/5, ScreenWith/5) andImageName:imageNames[i] andTitle:@"" andBackGround:[UIColor whiteColor] andTitleColor:[UIColor whiteColor] andFont:15.0 andCornerRadius:0.0];
        
        UILabel * title = [self addViewRootLabelNewWithFram:CGRectMake(CGRectGetMinX(bt.frame), CGRectGetMaxY(bt.frame), ScreenWith/5, 15) andBackGroundColor:[UIColor whiteColor] andTextColor:[UIColor lightGrayColor] andFont:13.0 andTitle:titles[i] andNSTextAlignment:NSTextAlignmentCenter];
        
        [middleView addSubview:bt];
        [middleView addSubview:title];
        
        if (i == 0) {
            
            self.WeiXinShareButton = bt;
            
        }else if (i == 1){
            
            self.WeiXinFriendShareButton = bt;
            
        }else if (i == 2){
            
            self.QQShareButton = bt;
            
        }else if (i == 3){
            
            self.QzoneShareButton = bt;
            
        }else{
            
            self.shareLinkCopyButton = bt;
            
        }
    }

}



- (void)addAdvertisementViewNew{

    
    UIView * adView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith * 3/4, ScreenHeight * 3/5)];
    adView.center = self.center;
    adView.backgroundColor = [UIColor whiteColor];
    adView.layer.cornerRadius = 6.0;
    adView.clipsToBounds = YES;
    
    [self addSubview:adView];

    
    UIButton * cancleButton = [self addViewRootButtonNewFram:CGRectMake(CGRectGetMaxX(adView.frame)-10, CGRectGetMinY(adView.frame)-20,30,30) andImageName:@"" andTitle:@"X" andBackGround:[UIColor whiteColor] andTitleColor:[UIColor blackColor] andFont:16.0 andCornerRadius:15.0];
    self.advCancleButton = cancleButton;
    [self addSubview: cancleButton];

    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith/5, ScreenWith/5)];
    imageView.center = CGPointMake(adView.center.x, CGRectGetMinY(adView.frame));
    imageView.backgroundColor = [UIColor clearColor];
    imageView.image = [UIImage imageNamed:@"icon_180"];
    [self addSubview:imageView];
    
    
    UILabel * titleLabel = [self addViewRootLabelNewWithFram:CGRectMake(0, 0, ScreenWith /2, 20) andBackGroundColor:[UIColor whiteColor] andTextColor:[UIColor blackColor] andFont:15.0 andTitle:@"滑动选择你的推广语吧!" andNSTextAlignment:NSTextAlignmentCenter];
    titleLabel.center = CGPointMake(ScreenWith*3/8, ScreenWith/10 + 20);
    [adView addSubview:titleLabel];
    
    UITableView * tableView = [self addTableViewNew:adView andlabel:titleLabel];
    
    UIButton * enterButton = [self addViewRootButtonNewFram:CGRectMake(0, 0, ScreenWith/3, ScreenWith/12) andImageName:@"" andTitle:@"确定" andBackGround:[UIColor colorWithRed:0.0/255.0 green:205.0/255.0 blue:255.0/255.0 alpha:1.0] andTitleColor:[UIColor whiteColor] andFont:14.0 andCornerRadius:ScreenWith/26];
    enterButton.center = CGPointMake(ScreenWith*3/8, CGRectGetMaxY(tableView.frame) + 15 + ScreenWith/26);
    self.shareEnterButton = enterButton;
    [adView addSubview:enterButton];
    
    
    
    [self advStringGetFromNet];

    
}


- (UITableView *)addTableViewNew:(UIView *)bgView andlabel:(UILabel * )title{

    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(title.frame) + 10, ScreenWith * 3/4 - 30, ScreenHeight * 2/5) style:UITableViewStylePlain];
    tableView.backgroundColor =[ UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableFooterView = [[UIView alloc]init];
    self.tableView = tableView;
    [bgView addSubview:tableView];
    
    return tableView;
}


- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    
    AdvStringCell * cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell_%ld",indexPath.row]];
    
    if (cell == nil) {
        
        cell = [[AdvStringCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"cell_%ld",indexPath.row]];
        
        cell.backgroundColor =[ UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 0) {
            cell.selectImageView.image = [UIImage imageNamed:@"sel"];
            
        }else{
            cell.selectImageView.image = [UIImage imageNamed:@"unsel"];
            
        }
        
        [self.imageViewArray addObject:cell.selectImageView];
    }
    
    
    if (self.advStringArray.count > 0) {
        
        AdvStringModel * model = self.advStringArray[indexPath.row];
    
        NSString *str = model.content;
        
        CGRect frameNew = [str boundingRectWithSize:CGSizeMake(ScreenWith * 3/4 - 30 - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]} context:nil];
    
        cell.advLabel.frame = CGRectMake(30, 5, ScreenWith * 3/4 - 30 - 30, frameNew.size.height);
        cell.advLabel.text = model.content;
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    
        AdvStringModel * model = self.advStringArray[indexPath.row];
    
        NSString *str = model.content;
        
        CGRect frameNew = [str boundingRectWithSize:CGSizeMake(ScreenWith * 3/4 - 30 - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]} context:nil];
        
        
        return frameNew.size.height + 10;


}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.advStringArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"%ld",indexPath.row);
    
    UIImageView * imageV = self.imageViewArray[indexPath.row];;
    
    for (UIImageView * image in self.imageViewArray) {
        image.image = [UIImage imageNamed:@"unsel"];
    }
    
    imageV.image = [UIImage imageNamed:@"sel"];


    NSLog(@"%@",imageV);
    
    
    if (self.advStringArray.count > 0) {
        
    
    AdvStringModel * model = self.advStringArray[indexPath.row];
    
    self.selectAdvString = model.content;
    
    NSLog(@"%@",self.selectAdvString);
    }
    
}




- (void)addBarRigthShareViewNew{
    
    NSArray * images = @[@"shares",@"unselstar",@"waring"];
    NSArray * titles = @[@"分享",@"收藏",@"举报"];
    
    UIView * view;
    
    if (self.rightShareView ) {
        
        [self addSubview:self.rightShareView];
        
        return;
    }
        view = [[UIView alloc]initWithFrame:CGRectMake(ScreenWith *3/4 - 10, 66, ScreenWith/4, ScreenWith/3)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.shadowOffset = CGSizeMake(0, 0);
        view.layer.shadowOpacity = 0.8;
        view.layer.shadowColor = [UIColor whiteColor].CGColor;
        self.rightShareView = view;
        [self addSubview:view];
    
    
    for (int i = 0; i < 3; i++) {
        
        
        UIButton * bt= [self addViewRootButtonNewFram: CGRectMake(0, ScreenWith/9 * i, ScreenWith/4, ScreenWith/9) andImageName:images[i] andTitle:titles[i] andBackGround:[UIColor whiteColor] andTitleColor:[UIColor lightGrayColor] andFont:16
                                      andCornerRadius:0.0];
        
        bt.imageEdgeInsets = UIEdgeInsetsMake(0, -6, 0, 0);
        bt.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -6);
        
        [view addSubview:bt];
        
        if (i == 0) {
            
            self.rightShareViewShareButton = bt;
            
        }else if (i == 1){
            
            self.rightShareViewcollectionButton = bt;
            
        }else{
            
            self.rightShareViewWarningButton = bt;
            
        }
        
        
    }
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self removeFromSuperview];
}


@end
