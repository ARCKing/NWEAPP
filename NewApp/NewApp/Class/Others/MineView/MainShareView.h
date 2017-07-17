//
//  MainShareView.h
//  NewApp
//
//  Created by gxtc on 17/2/17.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootView.h"
@interface MainShareView : RootView

@property (nonatomic,strong)UIButton * WeiXinShareButton;

@property (nonatomic,strong)UIButton * WeiXinFriendShareButton;

@property (nonatomic,strong)UIButton * QQShareButton;

@property (nonatomic,strong)UIButton * QzoneShareButton;

@property (nonatomic,strong)UIButton * LinkCopyButton;


@property (nonatomic,strong)UIButton * cancleButton;

@property (nonatomic,strong)UIButton * advCancleButton;


@property (nonatomic,strong)UIButton * shareLinkCopyButton;
@property (nonatomic,strong)UIButton * collectionButton;


@property (nonatomic,strong)UIView * shareMiddleView;

@property (nonatomic,strong)UIView * shareBottomView;

@property (nonatomic,strong)UIView * advertisementView;//推广语
@property (nonatomic,copy)NSString * selectAdvString;

@property (nonatomic,strong)UIButton * shareEnterButton;


@property (nonatomic,assign)NSInteger shareType;



@property(nonatomic,strong)UIButton * rightShareViewShareButton;

@property(nonatomic,strong)UIButton * rightShareViewcollectionButton;

@property(nonatomic,strong)UIButton * rightShareViewWarningButton;

@property(nonatomic,strong)UIView * rightShareView;

@property(nonatomic,assign)BOOL rightShareViewIsShow;




/**底部分享*/
- (void)addBottomShareViewNew;

/**中部分享*/
- (void)addMiddelShareViewNew;


/**推广语*/
- (void)addAdvertisementViewNew;


/**导航右侧分享View*/
- (void)addBarRigthShareViewNew;



@end
