//
//  PersonMessageTableViewController.m
//  fanmore---
//
//  Created by lhb on 15/5/25.
//  Copyright (c) 2015年 HT. All rights reserved.
//  账号信息

#import <SDWebImageManager.h>
#import "PersonMessageTableViewController.h"
#import "PersonCenterModel.h"
#import "TwoOption.h"

#import "ProfessionalController.h"
//#import "userData.h"
//#import "GlobalData.h"
//#import "twoOption.h"
#import "NameController.h"
#import "SexController.h"
#import "HobbyController.h"
#import <CoreLocation/CoreLocation.h>
//#import "PinYin4Objc.h"

@interface PersonMessageTableViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,ProfessionalControllerDelegate,ProfessionalControllerDelegate,NameControllerdelegate,HobbyControllerDelegate,UIActionSheetDelegate,SexControllerdelegate,UIAlertViewDelegate>

@property(nonatomic,strong)NSArray * messages;
/**1用户头像*/
@property (weak, nonatomic) IBOutlet UIButton *iconView;
/**2用户姓名*/
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
/**3用户性别*/
@property (weak, nonatomic) IBOutlet UILabel *sexLable;

/**5用户职业*/
@property (weak, nonatomic) IBOutlet UILabel *careerLable;
/**6用户收入*/
@property (weak, nonatomic) IBOutlet UILabel *userIncomeLable;
/**7用户爱好*/
@property (weak, nonatomic) IBOutlet UILabel *favLable;
///**8用户所在区域*/
//@property (weak, nonatomic) IBOutlet UILabel *placeLable;
/**9用户账号时间*/
@property (weak, nonatomic) IBOutlet UILabel *registTimeLable;


@property(nonatomic,strong)  PersonCenterModel * person;
/**生日*/
@property (weak, nonatomic) IBOutlet UITextField *birDate;

/**自己的性别*/
@property(assign,nonatomic) int selfsex;


/**时间选择器*/
@property(nonatomic,strong) UIDatePicker *datePicker;

//@property (nonatomic, strong) userData *userinfo;


@property(nonatomic,strong) CLGeocoder *geocoder;



@property(nonatomic,strong) UserModel * userInfo;

- (IBAction)iconViewCkick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *accountCl;
- (IBAction)asdsdfsqfgqwerewrqew:(id)sender;


/**我的等级*/
@property (weak, nonatomic) IBOutlet UILabel *myLevelName;

/**转发数*/
@property (weak, nonatomic) IBOutlet UILabel *turnLable;

/**浏览量*/
@property (weak, nonatomic) IBOutlet UILabel *browLable;

@property (weak, nonatomic) IBOutlet UILabel *huobanLable;


@end

@implementation PersonMessageTableViewController


- (CLGeocoder *)geocoder{
    
    if (_geocoder == nil) {
        
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //初始化个人信息
}

- (void)setInitDate{
    
    
    self.iconView.layer.cornerRadius = self.iconView.frame.size.width * 0.5;
    self.iconView.layer.masksToBounds = YES;
    
    __weak PersonMessageTableViewController * wself = self;
    
    self.iconView.layer.borderWidth = 3;
    self.iconView.layer.borderColor = [UIColor whiteColor].CGColor;
    UserModel *user = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:user.userHead] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        [wself.iconView setImage:image forState:UIControlStateNormal];
    }];
    self.userInfo = user;
    self.navigationController.navigationBarHidden = NO;
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"loginCode"] = user.loginCode;
    NSDictionary * dict = [UserLoginTool LogingetDateSyncWith:@"UserInfo" WithParame:parame];
    if ([dict[@"status"] integerValue] == 1 && [dict[@"resultCode"] integerValue] == 1) {
        PersonCenterModel * person = [PersonCenterModel mj_objectWithKeyValues:dict[@"resultData"]];
        LWLog(@"%@",[person mj_keyValues]);
        self.person = person;
        if (person) {
            self.nameLable.text = person.name;
            self.sexLable.text = person.sex==1 ? @"男":@"女";  //1男
            self.birDate.text = [[person.birth componentsSeparatedByString:@" "] firstObject];
            self.careerLable.text =person.industry;
            self.favLable.text = person.favorite;
            self.userIncomeLable.text = person.income;
            
        }
        self.registTimeLable.text = [[self.userInfo.regTime componentsSeparatedByString:@" "] firstObject] ;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInitDate];
    self.title = @"个人信息";
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.date = [NSDate date];
    _datePicker.backgroundColor = [UIColor colorWithWhite:0.955 alpha:1];
    _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    self.birDate.inputView= _datePicker;
    [self setupDatePicker];
    
    AppDelegate * ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ad.currentVC = self;

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    [self initDate];
}


- (void)initDate{
    
    UserModel *user = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
    
    self.myLevelName.text = user.levelName;
    
    self.turnLable.text = [NSString stringWithFormat:@"%ld",[self.userInfo.TotalTurnAmount integerValue]];
    
    
    self.browLable.text = [NSString stringWithFormat:@"%ld",[self.userInfo.TotalBrowseAmount integerValue]];
    
    self.huobanLable.text = [NSString stringWithFormat:@"%ld",[self.userInfo.PrenticeAmount integerValue]];
}





/**
 *  日期取消
 */
- (void)cancleClick
{
    [self.view endEditing:YES];
    
}

/**
 *  日期确定
 */
- (void)selectClick
{
    [self.view endEditing:YES];
    
    NSDate * dateS = self.datePicker.date;
    
        
    NSTimeInterval  interval = [dateS timeIntervalSinceNow];
    
    if (interval>0) {
            
        [MBProgressHUD showError:@"不能选择比当前大的日期"];
        return;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
//    NSLog(@"%.f", [dateS timeIntervalSince1970] * 1000);
    NSString * time =  [dateFormatter stringFromDate:dateS];
    LWLog(@"%@",time);
    
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"loginCode"] = self.userInfo.loginCode;
    parame[@"industry"] = @(self.person.industryId);
    parame[@"income"] = @(self.person.incomeId);
    parame[@"name"] = self.person.name;
    parame[@"sex"] = @(self.person.sex);
    parame[@"favorite"] = self.person.favorite;
    parame[@"birth"] = time;//self.person.birth;
    [MBProgressHUD showMessage:@"资料上传中"];
    [UserLoginTool loginRequestGet:@"UpdateUserInfo" parame:parame success:^(id json) {
        if ([json[@"status"] integerValue] == 1 && [json[@"resultCode"] integerValue] == 1) {
            LWLog(@"%@",json);
            self.birDate.text = time;
        }
        [MBProgressHUD hideHUD];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];
}




#pragma tableview

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2.5;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {//头像
            UIActionSheet * aa = [[UIActionSheet alloc] initWithTitle:@"选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"相机", nil];
                [aa showInView:self.view];
                
            
        }
        if (indexPath.row == 1) { //姓名
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            NameController *nameVC = [storyboard instantiateViewControllerWithIdentifier:@"NameController"];
            nameVC.name = self.person.name;
            nameVC.delegate = self;
            [self.navigationController pushViewController:nameVC animated:YES];
        }
        if (indexPath.row == 2) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SexController *nameVC = [storyboard instantiateViewControllerWithIdentifier:@"SexController"];
            nameVC.sex = self.selfsex;
            nameVC.delegate = self;
            [self.navigationController pushViewController:nameVC animated:YES];
        }
        if (indexPath.row == 3) {//我的等级
            
        }
    }
//    if (indexPath.section == 1) {
//        if (indexPath.row == 0) { //职业
//             ProfessionalController *pro = [[ProfessionalController alloc] initWithStyle:UITableViewStylePlain];
//            pro.DefauleDateID = self.person.industryId;
//            pro.Setgoods = self.person.industryList;
//            pro.delegate = self;
//            pro.type = 0;
//            [self.navigationController pushViewController:pro animated:YES];
//        }
//        if (indexPath.row == 1) { //收入
//            ProfessionalController *pro = [[ProfessionalController alloc] initWithStyle:UITableViewStylePlain]; //instantiateViewControllerWithIdentifier:@"ProfessionalController"];
//            pro.delegate = self;
//            pro.Setgoods= self.person.incomeList;
//            pro.type = 1;
//            pro.DefauleDateID = self.person.incomeId;
//            [self.navigationController pushViewController:pro animated:YES];
//        }
//
//    }

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    
    __weak PersonMessageTableViewController * wself = self;
//    NSLog(@"%@",info);
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
//    NSLog(@"%@",mediaType);
    // 判断获取类型：图片s
    UIImage *photoImage = nil;
    if ([mediaType isEqualToString:( NSString *)kUTTypeImage]){
        // 判断，图片是否允许修改
        if ([picker allowsEditing]){
            //获取用户编辑之后的图像
            photoImage = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            // 照片的元数据参数
            photoImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
    }
    NSData *data;
    if (UIImagePNGRepresentation(photoImage) == nil) {
        
        data = UIImageJPEGRepresentation(photoImage, 1);
        
    } else {
        
        data = UIImagePNGRepresentation(photoImage);
        
        
        if ([data length] / 1000 > 2000) {
            data = UIImagePNGRepresentation([self imageWithImageSimple:photoImage scaledToSize:CGSizeMake(600, 600)]);
        }
        
        
    }
//    NSData *data;
//    if (UIImagePNGRepresentation(photoImage) == nil) {
//        
//        data = UIImageJPEGRepresentation(photoImage, 1);
//        
//    } else {
//        
//        data = UIImagePNGRepresentation(photoImage);
//    }
    
    NSString * imagefile = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [picker dismissViewControllerAnimated:YES completion:^{
        UserModel * userInfo = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
        NSMutableDictionary * parame = [NSMutableDictionary dictionary];
        parame[@"pic"] = [imagefile stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        parame[@"loginCode"] = userInfo.loginCode;
        [MBProgressHUD showMessage:@"头像上传中..."];
        [UserLoginTool loginRequestPostWithFile:@"UploadPicture" parame:parame success:^(id json) {
            
            LWLog(@"%@",json);
            if ([json[@"status"] integerValue] == 1 && [json[@"resultCode"] integerValue] == 1) {
                
               UserModel * model = (UserModel *)[UserLoginTool LoginReadModelDateFromCacheDateWithFileName:RegistUserDate];
                model.userHead = json[@"resultData"][@"picUrl"];
                [UserLoginTool LoginModelWriteToShaHe:model andFileName:RegistUserDate];
                [wself.iconView setImage:photoImage forState:UIControlStateNormal];
            }
            [MBProgressHUD hideHUD];
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];

            LWLog(@"%@",error.description);
        } withFileKey:@"pic"];
        
    }];
}


/**
 *  取消拍照
 *
 *  @param picker <#picker description#>
 */
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}



- (void)toupDatePersonMessageWithApi:(NSString *)urlStr withParame:(NSMutableDictionary *)paremes withOptin:(NSString *)nn{
//    
//    [MBProgressHUD showMessage:nil];
//    [UserLoginTool loginRequestPost:urlStr parame:paremes success:^(id json) {
//        [MBProgressHUD hideHUD];
////        NSLog(@"大大叔大叔大叔大叔大叔大叔大叔的时代%@",json);
//        //        NSLog(@"dadasd%@",json);
//        if ([json[@"systemResultCode"] intValue] == 1 && [json[@"resultCode"] intValue] == 1) {
//            [MBProgressHUD showSuccess:nn];
//            NSLog(@"%@",json);
//            userData * user = [userData objectWithKeyValues:json[@"resultData"][@"user"]];
//            NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//            NSString *fileName = [path stringByAppendingPathComponent:LocalUserDate];
//            [NSKeyedArchiver archiveRootObject:user toFile:fileName];
//            
//        }
//       
//        [MBProgressHUD hideHUD];
//    } failure:^(NSError *error) {
//        [MBProgressHUD hideHUD];
//        [MBProgressHUD showError:@"生日资料上传失败"];
//    }];
//    

}

#pragma mark - Table view data source

/**
 *  设置datepicker的工具条
 */
- (void)setupDatePicker
{
    UIToolbar * toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    toolBar.backgroundColor = [UIColor grayColor];
    UIBarButtonItem * item1 = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancleClick)];
    UIBarButtonItem * item2 = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(selectClick)];
    UIBarButtonItem * item3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolBar.items = @[item1,item3,item2];
    self.birDate.inputAccessoryView = toolBar;
}



#pragma ProfessionalControllerDelegate


- (void)NameControllerpickName:(NSString *)name{
    LWLog(@"%@",name);
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"loginCode"] = self.userInfo.loginCode;
    parame[@"name"] = name;
    parame[@"sex"] = @(1);
    parame[@"industry"] = self.person.industry;
    parame[@"favorite"] = self.person.favorite;
    parame[@"income"] = self.person.income;
    parame[@"birth"] = [self convertDateFromString:self.person.birth];
//    parame[@"sex"] = self.userInfo.sex;
    //sex,birth,industry,industry,industry
    [MBProgressHUD showMessage:@"资料上传中"];
     NSDictionary * dict = [UserLoginTool LogingetDateSyncWith:@"UpdateUserInfo" WithParame:parame];
    LWLog(@"%@",dict);
    if ([dict[@"status"] integerValue] == 1 && [dict[@"resultCode"] integerValue] == 1) {
        self.nameLable.text = name;
    }
    [MBProgressHUD hideHUD];
}




/**
 *  获取照片选项
 *
 *  @param sender <#sender description#>
 */
- (IBAction)iconViewCkick:(id)sender {
    UIActionSheet * aa = [[UIActionSheet alloc] initWithTitle:@"选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从本地相册选择图片",@"相机", nil];
    [aa showInView:self.view];
    
}


/**
 *
 *
 *  @param uiDate 传入时间
 *
 *  @return 年月日
 */
- (NSString*) convertDateFromString:(NSString*)uiDate
{
    NSString *dateString = [uiDate substringToIndex:10];
    LWLog(@"%@",dateString);
    return dateString;

}


/**
 *  改收入
 *
 *  @param selectDict                            <#selectDict description#>
 *  @param ProfessionalControllerBringBackCareer <#ProfessionalControllerBringBackCareer description#>
 *  @param selectDict                            <#selectDict description#>
 *  @param type                                  <#type description#>
 */
- (void) ProfessionalControllerBringBackIncomeWithId:(NSMutableDictionary *)selectDictid WithName:(NSString *)name currentSelectType:(int)type{
    
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"loginCode"] = self.userInfo.loginCode;
    parame[@"industry"] = @(self.person.industryId);
    parame[@"income"] = selectDictid;
    parame[@"name"] = self.person.name;
    parame[@"sex"] = @(self.person.sex);
    parame[@"favorite"] = self.person.favorite;
    LWLog(@"%@--%@",self.person.birth,[self convertDateFromString:self.person.birth]);
    parame[@"birth"] = [[self.person.birth componentsSeparatedByString:@" "] firstObject];
    [MBProgressHUD showMessage:@"资料上传中"];
    [UserLoginTool loginRequestGet:@"UpdateUserInfo" parame:parame success:^(id json) {
        if ([json[@"status"] integerValue] == 1 && [json[@"resultCode"] integerValue] == 1) {
            LWLog(@"%@",json);
            self.userIncomeLable.text = name;
            
        }
        [MBProgressHUD hideHUD];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];

    
    
}
- (void) ProfessionalControllerBringBackCareerWithValue:(NSString* )selectDictInt withName:(NSString* )selectDictName currentSelectType:(int)type{
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"loginCode"] = self.userInfo.loginCode;
    parame[@"industry"] = selectDictInt;
    parame[@"income"] = @(self.person.incomeId);
    parame[@"name"] = self.person.name;
    parame[@"sex"] = @(self.person.sex);
    parame[@"favorite"] = self.person.favorite;
    LWLog(@"%@",[self convertDateFromString:self.person.birth]);
    parame[@"birth"] = [[self.person.birth componentsSeparatedByString:@" "] firstObject];
    [MBProgressHUD showMessage:@"资料上传中"];
    [UserLoginTool loginRequestGet:@"UpdateUserInfo" parame:parame success:^(id json) {
        if ([json[@"status"] integerValue] == 1 && [json[@"resultCode"] integerValue] == 1) {
            LWLog(@"%@",json);
            self.careerLable.text = selectDictName;
            
        }
        [MBProgressHUD hideHUD];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];

}



/**
 *    相机掉出
 *
 *  @param actionSheet <#actionSheet description#>
 *  @param buttonIndex <#buttonIndex description#>
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        UIImagePickerController * pc = [[UIImagePickerController alloc] init];
        pc.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        pc.delegate = self;
        pc.allowsEditing = YES;
        [self presentViewController:pc animated:YES completion:nil];
        
    }else if(buttonIndex == 1) {
        
        UIImagePickerController * pc = [[UIImagePickerController alloc] init];
        pc.allowsEditing = YES;
        pc.sourceType=UIImagePickerControllerSourceTypeCamera;
        pc.delegate = self;
        [self presentViewController:pc animated:YES completion:nil];
    }
}


/**
 *  性别选择的代理方法
 *
 *  @param sex 1 男
 *             2 女
 */
- (void)selectSexOver:(NSInteger)sex
{
    
    
    LWLog(@"%ld",sex);
    if (self.selfsex) {
        self.selfsex  = 0;
    }else{
        self.selfsex = 1;
    }
    
    NSMutableDictionary * parame = [NSMutableDictionary dictionary];
    parame[@"loginCode"] = self.userInfo.loginCode;
    parame[@"industry"] = @(self.person.industryId);
    parame[@"income"] = @(self.person.incomeId);
    parame[@"name"] = self.person.name;
    parame[@"sex"] = @(sex+1);
    parame[@"favorite"] = self.person.favorite;
    parame[@"birth"] = [[self.person.birth componentsSeparatedByString:@" "] firstObject];
    [MBProgressHUD showMessage:@"资料上传中"];
    [UserLoginTool loginRequestGet:@"UpdateUserInfo" parame:parame success:^(id json) {
        if ([json[@"status"] integerValue] == 1 && [json[@"resultCode"] integerValue] == 1) {
            LWLog(@"%@",json);
            if (sex) {
                self.sexLable.text = @"女";
            }else{
                self.sexLable.text = @"男";
            }
            
        }
        [MBProgressHUD hideHUD];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
    }];

}
//压缩图片尺寸
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

/**
 *  账号退出提醒框
 *
 *  @param sender <#sender description#>
 */
- (IBAction)asdsdfsqfgqwerewrqew:(id)sender {
    
    
    UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"注销" message:@"你确定退出当前账号" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * at = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSFileManager * manger = [NSFileManager defaultManager];
        [manger removeItemAtPath:path error:nil];
        
        UIStoryboard* story = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
        LoginViewController * login = [story instantiateViewControllerWithIdentifier:@"LoginViewController"];
        //    XMGLoginRegisterViewController * vc = [[XMGLoginRegisterViewController alloc] init];
        UINavigationController * nac = [[UINavigationController alloc] initWithRootViewController:login];
        
        [UIApplication sharedApplication].keyWindow.rootViewController = nac;
    }];
    [ac addAction:at];
    
    UIAlertAction * ag = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [ac addAction:ag];
    [self presentViewController:ac animated:YES completion:nil];
    
    
}


@end
