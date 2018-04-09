//
//  SWQRCodeManager.m
//  SWQRCode_Objc
//
//  Created by zhuku on 2018/4/4.
//  Copyright © 2018年 selwyn. All rights reserved.
//

#import "SWQRCodeManager.h"
#import <Photos/PHPhotoLibrary.h>

@implementation SWQRCodeManager

/** 校验是否有相机权限 */
+ (void)sw_checkCameraAuthorizationStatusWithGrand:(void(^)(BOOL granted))permissionGranted
{
    AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    switch (videoAuthStatus) {
        // 已授权
        case AVAuthorizationStatusAuthorized:
        {
            permissionGranted(YES);
        }
            break;
        // 未询问用户是否授权
        case AVAuthorizationStatusNotDetermined:
        {
            // 提示用户授权
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                permissionGranted(granted);
            }];
        }
            break;
        // 用户拒绝授权或权限受限
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请在”设置-隐私-相机”选项中，允许访问你的相机" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            permissionGranted(NO);
        }
            break;
        default:
            break;
    }
}

/** 校验是否有相册权限 */
+ (void)sw_checkAlbumAuthorizationStatusWithGrand:(void(^)(BOOL granted))permissionGranted {
    
    PHAuthorizationStatus photoAuthStatus = [PHPhotoLibrary authorizationStatus];
    switch (photoAuthStatus) {
        // 已授权
        case PHAuthorizationStatusAuthorized:
        {
            permissionGranted(YES);
        }
            break;
        // 未询问用户是否授权
        case PHAuthorizationStatusNotDetermined:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                permissionGranted(status == PHAuthorizationStatusAuthorized);
            }];
        }
            break;
        // 用户拒绝授权或权限受限
        case PHAuthorizationStatusRestricted:
        case PHAuthorizationStatusDenied:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请在”设置-隐私-相片”选项中，允许访问你的相册" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            permissionGranted(NO);
        }
            break;
        default:
            break;
    }
    
}

/** 根据扫描器类型配置支持编码格式 */
+ (NSArray *)sw_metadataObjectTypesWithType:(SWScannerType)scannerType {
    switch (scannerType) {
        case SWScannerTypeQRCode:
        {
            return @[AVMetadataObjectTypeQRCode];
        }
            break;
        case SWScannerTypeBarCode:
        {
            return @[AVMetadataObjectTypeEAN13Code,
                     AVMetadataObjectTypeEAN8Code,
                     AVMetadataObjectTypeUPCECode,
                     AVMetadataObjectTypeCode39Code,
                     AVMetadataObjectTypeCode39Mod43Code,
                     AVMetadataObjectTypeCode93Code,
                     AVMetadataObjectTypeCode128Code,
                     AVMetadataObjectTypePDF417Code];
        }
            break;
        case SWScannerTypeBoth:
        {
            return @[AVMetadataObjectTypeQRCode,
                     AVMetadataObjectTypeEAN13Code,
                     AVMetadataObjectTypeEAN8Code,
                     AVMetadataObjectTypeUPCECode,
                     AVMetadataObjectTypeCode39Code,
                     AVMetadataObjectTypeCode39Mod43Code,
                     AVMetadataObjectTypeCode93Code,
                     AVMetadataObjectTypeCode128Code,
                     AVMetadataObjectTypePDF417Code];
        }
            break;
        default:
            break;
    }
}

/** 根据扫描器类型配置导航栏标题 */
+ (NSString *)sw_navigationItemTitleWithType:(SWScannerType)scannerType {
    switch (scannerType) {
        case SWScannerTypeQRCode:
        {
            return @"二维码";
        }
            break;
        case SWScannerTypeBarCode:
        {
            return @"条码";
        }
            break;
        case SWScannerTypeBoth:
        {
            return @"二维码/条码";
        }
            break;
        default:
            break;
    }
}

/** 手电筒开关 */
+ (void)sw_FlashlightOn:(BOOL)on {
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([captureDevice hasTorch] && [captureDevice hasFlash]) {
        [captureDevice lockForConfiguration:nil];
        if (on) {
            [captureDevice setTorchMode:AVCaptureTorchModeOn];
            [captureDevice setFlashMode:AVCaptureFlashModeOn];
        }else
        {
            [captureDevice setTorchMode:AVCaptureTorchModeOff];
            [captureDevice setFlashMode:AVCaptureFlashModeOff];
        }
        [captureDevice unlockForConfiguration];
    }
}


@end
