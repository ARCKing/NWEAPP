//
//  RootViewController.h
//  NewApp
//
//  Created by gxtc on 17/2/13.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UMSocialCore/UMSocialCore.h>

@interface RootViewController : UIViewController

@property(nonatomic,strong)UIView * navigationBarView;

@property(nonatomic,strong)UILabel * titleLabel;



/**评论框*/

@property (nonatomic,strong)UIView * commentView;
@property (nonatomic,strong)UITextView * textView;
@property (nonatomic,strong)UILabel * placeHolderLabel;
@property (nonatomic,strong)UILabel * woeldNumberLabel;
@property (nonatomic,strong)UIButton * commentViewCancleButton;
@property (nonatomic,strong)UIButton * commentViewPushButton;
@property (nonatomic,copy)NSString * commentString;

@property (nonatomic,assign)BOOL isCommnetViewShow;

@property (nonatomic,assign)BOOL isComment;

@property (nonatomic,assign)BOOL netStatus;

@property(nonatomic,strong)UIButton * leftNavBarButton;

//
//@property(nonatomic,strong)UIButton * rightShareViewcollectionButton;
//
//@property(nonatomic,strong)UIButton * rightShareViewWarningButton;
//
//@property(nonatomic,strong)UIView * rightShareView;
//
//@property(nonatomic,assign)BOOL rightShareViewIsShow;



/**评论数量*/
@property(nonatomic,strong)UILabel * commentCount;//

@property(nonatomic,strong)UIView * noNetView;

/**
 *创建自定义导航栏View
 */
- (UIView *)NavBarViewNew;

- (void)addLineNew;

- (void)addLeftBarButtonNew;

- (void)addRightBarButtonNew;

- (void)addTitleLabelNew;


- (void)addRightBarClearButtonNew:(NSString *)titles;

- (void)rightBarButtonAction;

- (void)rightBarClearButtonAction;

- (void)addUI;



/**
 *富文本插入
 */
- (NSMutableAttributedString *)addRootAttributedText:(NSString *)str andArticleNum:(NSString *)num;

/**
 *富文本拼接
 */

- (NSMutableAttributedString *)addAppandRootAttributedText:(NSString *)str andArticleNum:(NSString *)num
                                                 andColor1:(UIColor *)color1
                                                 andColor2:(UIColor *)color2;



/**
 *Root富文本拼接
 */
- (NSMutableAttributedString *)addRootAppandAttributedText1:(NSString *)text1
                                                       andText2:(NSString *)text2
                                                      andColor1:(UIColor *)color1
                                                      andColor2:(UIColor *)color2
                                                       andFont1:(CGFloat)font1 andFont2:(CGFloat)font2;

/**
 *Root富文本插入
 */
- (NSMutableAttributedString *)addRootInsertAttributedText1:(NSString *)text1 andText2:(NSString *)text2 andIndex:(NSUInteger)index andColor1:(UIColor *)color1 andColor2:(UIColor *)color2 andFont1:(CGFloat)font1 andFont2:(CGFloat)font2;



/**
 *Root图文合成
 */
- (UIImage *)addRootComposeTextAndImageWithText:(NSString *)text angImage:(UIImage *)image andTextPoint:(CGPoint)textPoint
                                    andFontName:(NSString *)fontName andFontSize:(CGFloat)fontSize
                                   andTextColor:(UIColor *)color;

/**
 *添加按钮1
 */
- (UIButton *)addRootButtonNewFram:(CGRect)fram andSel:(SEL)sel andTitle:(NSString *)title;



/**
 *添加按钮2
 */
- (UIButton *)addRootButtonTypeTwoNewFram:(CGRect)fram andImageName:(NSString * )imageName andTitle:(NSString *)title
                            andBackGround:(UIColor *)color1 andTitleColor:(UIColor *)color2 andFont:(CGFloat)font
                          andCornerRadius:(CGFloat)radius;
/**
 *添加文本
 */
- (UILabel *)addRootLabelWithfram:(CGRect)fram andTitleColor:(UIColor *)color andFont:(CGFloat)size andBackGroundColor:(UIColor *)backColor andTitle:(NSString *)text;

/**
 *生成二维码
 */
- (UIImageView *)QrCodeWithViewFram:(CGRect)fram andCodeString:(NSString *)codeString;

/**
 *二图合成
 */
- (UIImage *)addDownImages:(UIImage *)image1 andUpImage:(UIImage *)image2 andUpImageFram:(CGRect)fram;

/**
 *返回上一级页面
 */
- (void)popVC;

/**创建黑色提示框*/
- (void)rootShowTheBlackMessageAleterNewWithFram:(CGRect)fram;

/**展示黑色提示框*/
 - (void)rootShowTheBlackMessageAlter:(NSString *)message;

/** 时间戳计算*/
- (NSString *)rootFinallyTime:(NSString *)yetTime;

/**web品论，分享View*/
- (void)rootWebBottomViewNew;


- (void)rootShareButtonAction;

/**气泡评论按钮*/
- (void)rootCommentButtonAction;

/**写评论按钮*/
- (void)rootWriteCommentButtonAction;


- (void)rootAdvCancleButtonAction;

- (void)rootCancleButtonAction;

- (void)rootWeiXinShareButtonAction:(UIButton *)bt;


- (void)rootQQShareButtonAction;

- (void)rootQzoneShareButtonAction;

- (void)rootCopyLinkButtonAction;

- (void)rootShareEnterButtonAction;

/**原生微信分享*/
- (void)rootLocationWeiXinShareWithImage:(UIImage *)image andImageUrl:(NSString *)imageUrl andString:(NSString *)str andUrl:(NSString *)url;

/**右侧分享*/
//- (void)addRootBarRigthShareViewNew;


/**收藏文章*/
- (void)rootCollectionArticleButtonAction;

/**举报文章*/
- (void)rootWarningButtonAction;

/**HUD文本提示框*/
- (void)rootShowMBPhudWith:(NSString *)message andShowTime:(NSTimeInterval)time;


#pragma mark- 评论输入框

/**评论输入框*/
- (void)addRootCommentViewNew;

/**评论发布按钮*/
- (void)rootCommentViewCancleButtonAvtion;

/**评论取消按钮*/
- (void)rootCommentViewPushButtonAction;


#pragma mark- 时间计算
/**时间戳计算*/
- (NSString * )rootArticleTime:(NSString *)times;

#pragma mark-复制链接
/**复制链接*/
- (void)rootCopyLinkWith:(NSString *)link;


#pragma mark- 调用分享
/**分享调用*/
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
                          andTitle:(NSString *)title
                        andContent:(NSString *)content
                            andUrl:(NSString *)webUrl
                     andThumbImage:(UIImage *)thumbImage;

#pragma mark- 友盟QQ图片分享
- (void)shareImageToQQandQZoneWithImage:(UIImage *)image andType:(UMSocialPlatformType)type;


/**审核隐藏状态监测*/
- (void)rootReviewStateCheckFromNet;


#pragma mark- 微信登录授权
/**微信登录授权*/
- (void)RootGetAuthWithUserInfoFromWechat;


- (void)RootBindWeiChatAccountWith:(NSString *)access_token andOpenid:(NSString *)openid andUnionid:(NSString *)unionid;

#pragma mark- 无网络
/**无网络*/
- (void)userDefaultsNoNet;


/**是否有网络*/
- (BOOL)netBool;

- (void)NoNetAction;

/**网络监测*/
- (void)RootAFNetworkStatus;


#pragma mark- 获取当前网络状态
/**获取当前网络状态*/
- (BOOL)RootCurrentNetState;


#pragma mark-设备标识号
/**设备标识号*/
- (NSString *)RootGetDeciceUUID;
@end
