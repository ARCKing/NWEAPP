//
//  ImpoartArticleClassify.h
//  NewApp
//
//  Created by gxtc on 2017/7/21.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "RootView.h"

typedef void(^selectBtBlock)(NSInteger );

@interface ImpoartArticleClassify : RootView

@property(nonatomic,strong)NSArray * titleArr;

@property(nonatomic,copy)selectBtBlock  selectBK;
@end
