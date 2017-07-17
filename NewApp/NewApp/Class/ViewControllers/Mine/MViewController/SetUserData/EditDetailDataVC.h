//
//  EditDetailDataVC.h
//  NewApp
//
//  Created by gxtc on 17/2/21.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "RootViewController.h"
#import "MineDetailModel.h"

@interface EditDetailDataVC : RootViewController
@property (nonatomic,strong)NSString * titleString;
@property (nonatomic,assign)NSInteger type;

@property (nonatomic,strong)MineDetailModel * model;

@end
