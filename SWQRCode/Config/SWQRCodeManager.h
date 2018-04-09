//
//  SWQRCodeManager.h
//  SWQRCode_Objc
//
//  Created by zhuku on 2018/4/4.
//  Copyright © 2018年 selwyn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWQRCode.h"

@interface SWQRCodeManager : NSObject

/**
 校验是否有相机权限
 
 @param permissionGranted 获取相机权限回调
 */
+ (void)sw_checkCameraAuthorizationStatusWithGrand:(void(^)(BOOL granted))permissionGranted;

/**
 校验是否有相册权限

 @param permissionGranted 获取相机权限回调
 */
+ (void)sw_checkAlbumAuthorizationStatusWithGrand:(void(^)(BOOL granted))permissionGranted;

/**
 根据扫描器类型配置支持编码格式

 @param scannerType 扫描器类型
 @return 编码格式组成的数组
 */
+ (NSArray *)sw_metadataObjectTypesWithType:(SWScannerType)scannerType;

/** 根据扫描器类型配置导航栏标题 */
+ (NSString *)sw_navigationItemTitleWithType:(SWScannerType)scannerType;

/**
 手电筒开关
 @param on YES:打开 NO:关闭
 */
+ (void)sw_FlashlightOn:(BOOL)on;

@end
