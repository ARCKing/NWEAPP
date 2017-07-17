//
//  AdvStringCell.m
//  NewApp
//
//  Created by gxtc on 17/3/13.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "AdvStringCell.h"

@implementation AdvStringCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addUI];
        
    }
    
    return self;
}


- (void)addUI{
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30,5,100,10)];
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:label];
    
    self.advLabel = label;
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
    self.selectImageView = imageView;
    
//  imageView.image = [UIImage imageNamed:@"sel"];
        
    imageView.image = [UIImage imageNamed:@"unsel"];
    
    [self.contentView addSubview:imageView];

}

@end
