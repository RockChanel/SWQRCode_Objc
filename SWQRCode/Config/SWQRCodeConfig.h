//
//  SWQRCodeConfig.h
//  SWQRCode_Objc
//
//  Created by zhuku on 2018/4/4.
//  Copyright © 2018年 selwyn. All rights reserved.
//

/***
 
 扫一扫基础配置文件
 
***/


#import <UIKit/UIKit.h>

/**
 扫描器类型

 - SWScannerTypeQRCode: 仅支持二维码
 - SWScannerTypeBarCode: 仅支持条码
 - SWScannerTypeBoth: 支持二维码以及条码
 */
typedef NS_ENUM(NSInteger, SWScannerType) {
    SWScannerTypeQRCode,
    SWScannerTypeBarCode,
    SWScannerTypeBoth,
};


/**
 扫描区域

 - SWScannerAreaDefault: 扫描框以内
 - SWScannerAreaFullScreen: 全屏
 */
typedef NS_ENUM(NSInteger, SWScannerArea) {
    SWScannerAreaDefault,
    SWScannerAreaFullScreen,
};

@interface SWQRCodeConfig : NSObject

/** 类型 */
@property (nonatomic, assign) SWScannerType scannerType;
/** 扫描区域 */
@property (nonatomic, assign) SWScannerArea scannerArea;
/** 棱角颜色 */
@property (nonatomic, strong) UIColor *scannerCornerColor;
/** 边框颜色 */
@property (nonatomic, strong) UIColor *scannerBorderColor;
/** 指示器风格 */
@property (nonatomic, assign) UIActivityIndicatorViewStyle indicatorViewStyle;

@end
