//
//  SetUserDataVC.m
//  NewApp
//
//  Created by gxtc on 17/2/21.
//  Copyright © 2017年 gxtc. All rights reserved.
//

#import "SetUserDataVC.h"

@interface SetUserDataVC ()<UITableViewDelegate,UITableViewDataSource,
UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong)NSArray * titleArray;

@property (nonatomic,strong)UIImageView * iconImageView;

@property (nonatomic,strong)MineDetailModel * model;

@property (nonatomic,strong)UILabel * sexLabel;
@property (nonatomic,strong)UILabel * nickNameLabel;

@end

@implementation SetUserDataVC



- (void)viewWillAppear:(BOOL)animated{

    [self getMineDetailDataFromNet];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleArray];
    [self addUI];
    
}

- (void)addUI{
    
    
    [self addNavBarNew];
    [self addTableViewNew];
    
    [self rootShowTheBlackMessageAleterNewWithFram:CGRectMake(ScreenWith/2 - 50, -30, 100, 30)];
    
}


- (void)getMineDetailDataFromNet{


    NetWork * net = [NetWork shareNetWorkNew];

    [net mineDetailDataFromNet];

    __weak SetUserDataVC * weakSelf = self;
    
    net.MineDetailDataBK=^(NSString * code,NSString * message,NSString * str,NSArray * dataArray,NSArray * data){
    
        if ([code isEqualToString:@"1"]) {
            
            if (dataArray.count > 0) {
                
                weakSelf.model = dataArray[0];
                
            }
            
            
            if (weakSelf.model) {
                
                [weakSelf.iconImageView sd_setImageWithURL:[NSURL URLWithString:weakSelf.model.headimgurl] placeholderImage:[UIImage imageNamed:@"head_icon"]];
                
                
                weakSelf.nickNameLabel.text = weakSelf.model.nickname;
                
                [weakSelf.nickNameLabel sizeToFit];
                
                weakSelf.nickNameLabel.center = CGPointMake(ScreenWith - weakSelf.nickNameLabel.bounds.size.width/2 - 35, ScreenWith/16);
                
                NSString * sex = weakSelf.model.sex;
                
                if ([sex isEqualToString:@"1"]) {
                
                    weakSelf.sexLabel.text = @"男";
                    
                }else if([sex isEqualToString:@"2"]){
                
                    weakSelf.sexLabel.text = @"女";
                    
                }else{
                    weakSelf.sexLabel.text = @"不详";
                
                }
            }
            
            
            
        }
        
    };
}



- (void)addNavBarNew{
    
    self.navigationBarView = [self NavBarViewNew];
    self.navigationBarView.backgroundColor =[UIColor whiteColor];
    [self addTitleLabelNew];
    [self addLeftBarButtonNew];
    self.titleLabel.text = @"我的资料";
    [self addLineNew];
    
}

- (void)addTitleArray{
    
    NSArray * array0 = @[@"头像"];
    NSArray * array1 = @[@"昵称",@"性别",@"收货地址"];
    NSArray * array2 = @[@"修改密码"];
    
    self.titleArray = [NSArray arrayWithObjects:array0,array1,array2, nil];
    
}
- (void)addTableViewNew{

    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWith, ScreenHeight - 64) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}


#pragma mark- 头像
/**修改头像*/
- (void)changeUserIconImage{

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera | UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        UIAlertController * alerate = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alerate addAction:[UIAlertAction actionWithTitle:@"从相机拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:imagePicker animated:YES completion:nil];

            
        }]];
        
        
        [alerate addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            [self presentViewController:imagePicker animated:YES completion:nil];
            
//            self.imagePicker = imagePicker;
            
        }]];
        
        
        [alerate addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"用户取消");
        }]];
        [self presentViewController:alerate animated:YES completion:nil];
        
        
    }else if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary | UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
        
        UIAlertController * alerate = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alerate addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            [self presentViewController:imagePicker animated:YES completion:nil];
            
//            self.imagePicker = imagePicker;
            
        }]];
        
        [alerate addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"用户取消");
        }]];
        
        [self presentViewController:alerate animated:YES completion:nil];
        
    }

}

#pragma mark- imagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    
    NSLog(@"done");
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.iconImageView.image = image;
    
    //    压缩图片
        NSData * iconData = UIImageJPEGRepresentation(image,0.5);
#pragma mark- 上传图片
    
//    UIImage * image2 = [self compressOriginalImage:image toSize:CGSizeMake(640, 640)];
    
//    NSData * iconData2 = UIImageJPEGRepresentation(image2,0.5);
    
    [self upLoadUserIconImageData:iconData];

    
}


/**上传头像*/
- (void)upLoadUserIconImageData:(NSData *)imageData{

    NetWork * net = [NetWork shareNetWorkNew];
    
    __weak SetUserDataVC * weakSelf = self;
    
    [net userIconUpLoadToPhp:imageData];
    
    net.userIconUpLoadBK=^(NSString * code,NSString * message){
    
        [weakSelf rootShowTheBlackMessageAlter:message];
        
        if ([code isEqualToString:@"1"]) {
            
            [weakSelf getMineDetailDataFromNet];
        }
    };
}


- (void)iconUpLoadAlerate:(BOOL)isSucceed{
    
    UILabel * laber = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    laber.center = CGPointMake(ScreenWith/2, -15);
    laber.backgroundColor = [UIColor blackColor];
    laber.textColor = [UIColor whiteColor];
    laber.font = [UIFont boldSystemFontOfSize:14];
    laber.textAlignment = NSTextAlignmentCenter;
    laber.layer.cornerRadius = 6;
    laber.clipsToBounds = YES;
    [self.view addSubview:laber];
    
    if (isSucceed) {
        laber.text = @"头像上传成功";
    }else{
        
        laber.text = @"头像上传失败";
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        
        laber.center = CGPointMake(ScreenWith/2, 42);
        
        
    } completion:^(BOOL finished) {
        
        [self performSelector:@selector(removeLabel:) withObject:laber afterDelay:1];
    }];
    
    
}


- (void)removeLabel:(UILabel *)label{
    
    [label removeFromSuperview];
}


#pragma mark- tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSArray * title = self.titleArray[indexPath.section];
        cell.textLabel.text = title[indexPath.row];
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
        if (indexPath.section == 0) {
            
            UIImageView * iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWith - ScreenWith/6 - 35, (ScreenWith/5 - ScreenWith/6)/2, ScreenWith/6, ScreenWith/6)];
            iconImage.backgroundColor = [UIColor clearColor];
            iconImage.image = [UIImage imageNamed:@"head_icon"];
            iconImage.layer.cornerRadius = ScreenWith/12;
            iconImage.clipsToBounds = YES;
            [cell.contentView addSubview:iconImage];
            self.iconImageView = iconImage;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        
        if (indexPath.section == 1) {
            
            if (indexPath.row == 0 || indexPath.row == 1) {
                
                UILabel * label = [[UILabel alloc]init];
                [cell.contentView addSubview:label];
                label.textColor = [UIColor lightGrayColor];
                label.font = [UIFont systemFontOfSize:15];
                label.textAlignment = NSTextAlignmentRight;
                label.text = @"***";
//                label.backgroundColor = [UIColor redColor];
                
                if (indexPath.row == 0) {
                    self.nickNameLabel = label;
                }else{
                    self.sexLabel = label;
                }
                
                
                [label sizeToFit];
                
                label.frame = CGRectMake(ScreenWith - label.frame.size.width - 35, (ScreenWith/8 - label.frame.size.height)/2, label.frame.size.width, label.frame.size.height);
            }
            
        }
        
        
    }
    return cell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        [self changeUserIconImage];
    }else if (indexPath.section == 1 && (indexPath.row == 0||indexPath.row == 1)){
    
        EditDetailDataVC * vc = [[EditDetailDataVC alloc]init];
        vc.model = self.model;
        
        if (indexPath.row == 0) {
            vc.titleString = @"修改昵称";
            vc.type = 1;
        }else{
            vc.titleString = @"修改性别";
            vc.type = 2;
        }
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];

        
    }else if (indexPath.section == 1 && indexPath.row == 2){
        
        AddressVC * vc = [[AddressVC alloc]init];
        vc.model = self.model;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        
        ResetPasswordViewController * vc = [[ResetPasswordViewController alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    NSLog(@"section = %ld,row = %ld",indexPath.section,indexPath.row);
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        return ScreenWith/5;
    }else{
    
        return ScreenWith/8;
    }

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    
    if (section == 0) {
        
        return 1;

    }else if (section == 1){
        
        return 3;

    }else{
    
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 3;
}

#pragma mark- 分组高度
//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 6.9;//section头部高度
}


//section头部视图
- (UIView * )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWith, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view ;
}


//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.1;
}
//section底部视图
- (UIView * )tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWith, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}



@end
