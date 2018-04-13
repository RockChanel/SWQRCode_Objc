//
//  SWScannerView.h
//  SWQRCode_Objc
//
//  Created by zhuku on 2018/4/8.
//  Copyright © 2018年 selwyn. All rights reserved.
//

#import "SWQRCode.h"

@interface SWScannerView : UIView

- (instancetype)initWithFrame:(CGRect)frame config:(SWQRCodeConfig *)config;

/** 添加扫描线条动画 */
- (void)sw_addScannerLineAnimation;

/** 暂停扫描线条动画 */
- (void)sw_pauseScannerLineAnimation;

/** 添加指示器 */
- (void)sw_addActivityIndicator;

/** 移除指示器 */
- (void)sw_removeActivityIndicator;

- (CGFloat)scanner_x;
- (CGFloat)scanner_y;
- (CGFloat)scanner_width;

/**
 显示手电筒
 @param animated 是否附带动画
 */
- (void)sw_showFlashlightWithAnimated:(BOOL)animated;

/**
 隐藏手电筒
 @param animated 是否附带动画
 */
- (void)sw_hideFlashlightWithAnimated:(BOOL)animated;

/**
 设置手电筒开关
 @param on YES:开  NO:关
 */
- (void)sw_setFlashlightOn:(BOOL)on;

/**
 获取手电筒当前开关状态
 @return YES:开  NO:关
 */
- (BOOL)sw_flashlightOn;

@end
