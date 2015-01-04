//
//  UserInfoSettingViewController.m
//  baobeiwansha
//
//  Created by PanYongfeng on 15/1/2.
//  Copyright (c) 2015年 上海震渊信息技术有限公司. All rights reserved.
//


// 处理用户个人设置信息，例如头像，背景图像等

#import "UserInfoSettingViewController.h"
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

#define ORIGINAL_MAX_WIDTH 640.0f
#define DEFAULTBGIMGURL @"defaultBackGroundImage.png"

@interface UserInfoSettingViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, VPImageCropperDelegate, UserNameSettingDelegate>

@property (nonatomic, strong) NSIndexPath *firstDatePickerIndexPath;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *userAvatarImageView;
@property (nonatomic, strong) NSString *nickNameString;
@property (nonatomic, strong) NSString *babyGenderString;
@property (nonatomic, strong) NSString *userGenderString;
@property BOOL bgOrAvatar;
@property (nonatomic, strong) UserNameViewController *userNameVC;
@property (nonatomic, strong) NSDate *birthdayDate;

@end

@implementation UserInfoSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人设置";
    self.firstDatePickerIndexPath = [NSIndexPath indexPathForRow:2 inSection:1];
    self.datePickerPossibleIndexPaths = @[self.firstDatePickerIndexPath];
    [self setDate:[NSDate date] forIndexPath:self.firstDatePickerIndexPath];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    NSInteger numberOfRows = [super tableView:tableView numberOfRowsInSection:section] ;
    if (section == 0) {
        return numberOfRows+2;
    } else {
        return numberOfRows+4;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"UserInfoSettingID";
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

    
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        
 
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"背景图";
                if (_bgImageView == nil) {
                    CGFloat w = 80.0f; CGFloat h = 60.0f;
                    CGFloat x = self.view.frame.size.width - w - 40.0f;
                    CGFloat y = 10.0f;
                    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
                    _bgImageView.image = [UIImage imageNamed:@"defaultBackGroundImage.png"];
                    [_bgImageView.layer setMasksToBounds:YES];
                    [_bgImageView setClipsToBounds:YES];
                    _bgImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
                    _bgImageView.layer.borderWidth = 1.0f;
                    [cell.contentView addSubview:_bgImageView];
                }
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"头像";

                if (_userAvatarImageView == nil) {
                    CGFloat w = 60.0f; CGFloat h = w;
                    CGFloat x = self.view.frame.size.width - 40.0f - w;
                    CGFloat y = 10.0f;
                    _userAvatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
                    _userAvatarImageView.image = [UIImage imageNamed:@"defaultBackGroundImage.png"];
                    [_userAvatarImageView.layer setCornerRadius:(_userAvatarImageView.frame.size.height/2)];
                    [_userAvatarImageView.layer setMasksToBounds:YES];
                    [_userAvatarImageView setClipsToBounds:YES];
                    _userAvatarImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
                    _userAvatarImageView.layer.borderWidth = 1.0f;
                    [cell.contentView addSubview:_userAvatarImageView];
                }
  
            }
        
        } else {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"昵称";
                if (_nickNameString == nil) {
                    _nickNameString = @"";
                }
                cell.detailTextLabel.text = _nickNameString;
            } else if (indexPath.row == 2) {
                cell.textLabel.text = @"宝贝出生日期";
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"宝贝性别";
                if (_babyGenderString == nil) {
                    _babyGenderString = @"";
                }
                cell.detailTextLabel.text = _babyGenderString;
            } else if (indexPath.row == 3){
                cell.textLabel.text = @"您的性别";
                if (_userGenderString == nil) {
                    _userGenderString = @"";
                }
                cell.detailTextLabel.text = _userGenderString;
            }
        }
        
    }
    
    if (indexPath.row == 2 && indexPath.section == 1) {
        self.birthdayDate = [self dateForIndexPath:self.firstDatePickerIndexPath];
        NSLocale *cnLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        [dateFormatter setLocale:cnLocale];
        cell.detailTextLabel.text = [dateFormatter stringFromDate:self.birthdayDate];
        [self.delegate updateUserAgeDate:self.birthdayDate];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    if (rowHeight == 0) {
        rowHeight = self.tableView.rowHeight;
        if (indexPath.section == 0) {
            rowHeight = 80.0f;
        }
    }
    return rowHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            self.bgOrAvatar = YES;
            [self editPortrait];
        }
        else if (indexPath.row == 1) {
            self.bgOrAvatar = NO;
            [self editPortrait];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            if (_userNameVC == nil) {
                _userNameVC = [[UserNameViewController alloc] initWithStyle:UITableViewStyleGrouped];
                _userNameVC.delegate = self;
            }
            [self.navigationController pushViewController:_userNameVC animated:YES];
        } else if (indexPath.row == 2) {
            //[self.delegate updateUserAgeDate:self.birthdayDate];
        } else if (indexPath.row == 1) {
            [self editBabyGender];
        } else if (indexPath.row == 3) {
            [self editUserGender];
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}








#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    if (self.bgOrAvatar) {
        self.bgImageView.image = editedImage;
        [self.delegate updateBackgroundImage:editedImage];
    } else {
        self.userAvatarImageView.image = editedImage;
        [self.delegate updateAvatarImage:editedImage];
    }
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([actionSheet.title  isEqual: @"请选择宝贝性别"]) {
        if (buttonIndex == 0) {
            self.babyGenderString = @"女";
        } else if (buttonIndex == 1){
            self.babyGenderString = @"男";
        }
        [self.tableView reloadData];
    } else if ([actionSheet.title isEqual:@"请选择您的角色"]) {
        if (buttonIndex == 0) {
            self.userGenderString = @"我是妈妈";
        } else if (buttonIndex == 1) {
            self.userGenderString = @"我是爸爸";
        } else if (buttonIndex == 2){
            self.userGenderString = @"其他";
        }
        [self.tableView reloadData];
    } else {
        if (buttonIndex == 0) {
            // 拍照
            if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                if ([self isFrontCameraAvailable]) {
                    controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                }
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = self;
                [self presentViewController:controller
                                   animated:YES
                                 completion:^(void){
                                     NSLog(@"Picker View Controller is presented");
                                 }];
            }
            
        } else if (buttonIndex == 1) {
            // 从相册中选取
            if ([self isPhotoLibraryAvailable]) {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = self;
                [self presentViewController:controller
                                   animated:YES
                                 completion:^(void){
                                     NSLog(@"Picker View Controller is presented");
                                 }];
            }
        } else if (buttonIndex == 2) {
            //恢复默认背景图片
            UIImage *tImg = [UIImage imageNamed:DEFAULTBGIMGURL];
            self.bgImageView.image = tImg;
            [self.delegate updateBackgroundImage:tImg];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // present the cropper view controller
        VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgCropperVC.delegate = self;
        [self presentViewController:imgCropperVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}


// misc functions
- (void)editPortrait {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    UIActionSheet *bgchoiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", @"默认背景", nil];
    if (self.bgOrAvatar) {
        [bgchoiceSheet showInView:self.view];
    } else {
        [choiceSheet showInView:self.view];
    }
}


- (void)editBabyGender {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:@"请选择宝贝性别"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"女孩", @"男孩", nil];
    [choiceSheet showInView:self.view];
}

- (void)editUserGender {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:@"请选择您的角色"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"我是妈妈", @"我是爸爸", @"其他", nil];
    [choiceSheet showInView:self.view];

}



-(void)updateUserNickNameText: (NSString *) nicknameText {
    [self.delegate updateUserNickNameText:nicknameText];
    self.nickNameString = nicknameText;
    [self.tableView reloadData];
}




@end
