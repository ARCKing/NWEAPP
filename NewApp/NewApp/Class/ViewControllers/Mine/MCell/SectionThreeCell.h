//
//  SectionThreeCell.h
//  NewApp
//
//  Created by gxtc on 17/3/11.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "RootTableViewCell.h"

@interface SectionThreeCell : RootTableViewCell


@property (nonatomic,strong)UIImageView * icon;

@property (nonatomic,strong)UILabel * title;

@property (nonatomic,strong)UILabel * middleLabel;

@property (nonatomic,strong)UILabel * coinLabel;

@property (nonatomic,strong)UILabel * explainLabel;

@property (nonatomic,assign)BOOL isOpen;

@end
