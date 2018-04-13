//
//  SWScannerView.m
//  SWQRCode_Objc
//
//  Created by zhuku on 2018/4/8.
//  Copyright © 2018年 selwyn. All rights reserved.
//

#import "SWScannerView.h"
#import "objc/runtime.h"

#define Scanner_Width 0.7*self.frame.size.width /** 扫描器宽度 */
#define Scanner_X (self.frame.size.width - Scanner_Width)/2 /** 扫描器初始x值 */
#define Scanner_Y (self.frame.size.height - Scanner_Width)/2 - 50   /** 扫描器初始y值 */

NSString *const ScannerLineAnmationKey = @"ScannerLineAnmationKey"; /** 扫描线条动画Key值 */
CGFloat const Scanner_BorderWidth = 1.0f;   /** 扫描器边框宽度 */
CGFloat const Scanner_CornerWidth = 3.0f;   /** 扫描器棱角宽度 */
CGFloat const Scanner_CornerLength = 20.0f; /** 扫描器棱角长度 */
CGFloat const Scanner_LineHeight = 10.0f;   /** 扫描器线条高度 */

CGFloat const FlashlightBtn_Width = 20.0f;  /** 手电筒按钮宽度 */
CGFloat const FlashlightLab_Height = 15.0f; /** 手电筒提示文字高度 */
CGFloat const TipLab_Height = 50.0f;    /** 扫描器下方提示文字高度 */

static char FLASHLIGHT_ON;  /** 手电筒开关状态绑定标识符 */

@interface SWScannerView()

@property (nonatomic, strong) UIImageView *scannerLine; /** 扫描线条 */
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator; /** 加载指示器 */
@property (nonatomic, strong) UIButton *flashlightBtn;  /** 手电筒开关 */
@property (nonatomic, strong) UILabel *flashlightLab;   /** 手电筒提示文字 */
@property (nonatomic, strong) UILabel *tipLab;  /** 扫描器下方提示文字 */


@property (nonatomic, strong) SWQRCodeConfig *config;

@end

@implementation SWScannerView

- (instancetype)initWithFrame:(CGRect)frame config:(SWQRCodeConfig *)config {
    self = [super initWithFrame:frame];
    if (self) {
        self.config = config;
        [self _setupUI];
    }
    return self;
}

- (void)_setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.scannerLine];
    [self sw_addScannerLineAnimation];
    
    [self addSubview:self.tipLab];
    [self addSubview:self.flashlightBtn];
    [self addSubview:self.flashlightLab];
}

#pragma mark -- 手电筒点击事件
- (void)flashlightClicked:(UIButton *)button {
    button.selected = !button.selected;
    [self sw_setFlashlightOn:self.flashlightBtn.selected];
}

/** 添加扫描线条动画 */
- (void)sw_addScannerLineAnimation {
    
    // 若已添加动画，则先移除动画再添加
    [self.scannerLine.layer removeAllAnimations];
    
    CABasicAnimation *lineAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    lineAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, Scanner_Width - Scanner_LineHeight, 1)];
    lineAnimation.duration = 4;
    lineAnimation.repeatCount = HUGE;
    [self.scannerLine.layer addAnimation:lineAnimation forKey:ScannerLineAnmationKey];
    // 重置动画运行速度为1.0
    self.scannerLine.layer.speed = 1.0;
}

/** 暂停扫描器动画 */
- (void)sw_pauseScannerLineAnimation {
    // 取出当前时间，转成动画暂停的时间
    CFTimeInterval pauseTime = [self.scannerLine.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    // 设置动画的时间偏移量，指定时间偏移量的目的是让动画定格在该时间点的位置
    self.scannerLine.layer.timeOffset = pauseTime;
    // 将动画的运行速度设置为0， 默认的运行速度是1.0
    self.scannerLine.layer.speed = 0;
}

/** 显示手电筒 */
- (void)sw_showFlashlightWithAnimated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.6 animations:^{
            self.flashlightLab.alpha = 1.0;
            self.flashlightBtn.alpha = 1.0;
            self.tipLab.alpha = 0;
        } completion:^(BOOL finished) {
            self.flashlightBtn.enabled = YES;
        }];
    }else
    {
        self.flashlightLab.alpha = 1.0;
        self.flashlightBtn.alpha = 1.0;
        self.tipLab.alpha = 0;
        self.flashlightBtn.enabled = YES;
    }
}

/** 隐藏手电筒 */
- (void)sw_hideFlashlightWithAnimated:(BOOL)animated {
    self.flashlightBtn.enabled = NO;
    if (animated) {
        [UIView animateWithDuration:0.6 animations:^{
            self.flashlightLab.alpha = 0;
            self.flashlightBtn.alpha = 0;
            self.tipLab.alpha = 1.0;
        } completion:^(BOOL finished) {
        }];
    }else
    {
        self.tipLab.alpha = 1.0;
        self.flashlightLab.alpha = 0;
        self.flashlightBtn.alpha = 0;
    }
}

/** 添加指示器 */
- (void)sw_addActivityIndicator {
    if (!self.activityIndicator) {
        self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:self.config.indicatorViewStyle];
        self.activityIndicator.center = self.center;
        [self addSubview:self.activityIndicator];
    }
    [self.activityIndicator startAnimating];
}

/** 移除指示器 */
- (void)sw_removeActivityIndicator {
    if (self.activityIndicator) {
        [self.activityIndicator removeFromSuperview];
        self.activityIndicator = nil;
    }
}

/** 设置手电筒开关 */
- (void)sw_setFlashlightOn:(BOOL)on {
    [SWQRCodeManager sw_FlashlightOn:on];
    self.flashlightLab.text = on ? @"轻触关闭":@"轻触照亮";
    self.flashlightBtn.selected = on;
    objc_setAssociatedObject(self, &FLASHLIGHT_ON, @(on), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/** 获取手电筒当前开关状态 */
- (BOOL)sw_flashlightOn {
    return [objc_getAssociatedObject(self, &FLASHLIGHT_ON) boolValue];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // 半透明区域
    [[UIColor colorWithWhite:0 alpha:0.7] setFill];
    UIRectFill(rect);
    
    // 透明区域
    CGRect scanner_rect = CGRectMake(Scanner_X, Scanner_Y, Scanner_Width, Scanner_Width);
    [[UIColor clearColor] setFill];
    UIRectFill(scanner_rect);
    
    // 边框
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRect:CGRectMake(Scanner_X, Scanner_Y, Scanner_Width, Scanner_Width)];
    borderPath.lineCapStyle = kCGLineCapRound;
    borderPath.lineWidth = Scanner_BorderWidth;
    [self.config.scannerBorderColor set];
    [borderPath stroke];
    
    for (int index = 0; index < 4; ++index) {
        
        UIBezierPath *tempPath = [UIBezierPath bezierPath];
        tempPath.lineWidth = Scanner_CornerWidth;
        [self.config.scannerCornerColor set];
        
        switch (index) {
                // 左上角棱角
            case 0:
            {
                [tempPath moveToPoint:CGPointMake(Scanner_X + Scanner_CornerLength, Scanner_Y)];
                [tempPath addLineToPoint:CGPointMake(Scanner_X, Scanner_Y)];
                [tempPath addLineToPoint:CGPointMake(Scanner_X, Scanner_Y + Scanner_CornerLength)];
            }
                break;
                // 右上角
            case 1:
            {
                [tempPath moveToPoint:CGPointMake(Scanner_X + Scanner_Width - Scanner_CornerLength, Scanner_Y)];
                [tempPath addLineToPoint:CGPointMake(Scanner_X + Scanner_Width, Scanner_Y)];
                [tempPath addLineToPoint:CGPointMake(Scanner_X + Scanner_Width, Scanner_Y + Scanner_CornerLength)];
            }
                break;
                // 左下角
            case 2:
            {
                [tempPath moveToPoint:CGPointMake(Scanner_X, Scanner_Y + Scanner_Width - Scanner_CornerLength)];
                [tempPath addLineToPoint:CGPointMake(Scanner_X, Scanner_Y + Scanner_Width)];
                [tempPath addLineToPoint:CGPointMake(Scanner_X + Scanner_CornerLength, Scanner_Y + Scanner_Width)];
            }
                break;
                // 右下角
            case 3:
            {
                [tempPath moveToPoint:CGPointMake(Scanner_X + Scanner_Width - Scanner_CornerLength, Scanner_Y + Scanner_Width)];
                [tempPath addLineToPoint:CGPointMake(Scanner_X + Scanner_Width, Scanner_Y + Scanner_Width)];
                [tempPath addLineToPoint:CGPointMake(Scanner_X + Scanner_Width, Scanner_Y + Scanner_Width - Scanner_CornerLength)];
            }
                break;
            default:
                break;
        }
        [tempPath stroke];
    }
}

- (CGFloat)scanner_x {
    return Scanner_X;
}

- (CGFloat)scanner_y {
    return Scanner_Y;
}

- (CGFloat)scanner_width {
    return Scanner_Width;
}

/** 扫描线条 */
- (UIImageView *)scannerLine {
    if (!_scannerLine) {
        _scannerLine = [[UIImageView alloc]initWithFrame:CGRectMake(Scanner_X, Scanner_Y, Scanner_Width, Scanner_LineHeight)];
        _scannerLine.image = [UIImage imageNamed:@"SWQRCode.bundle/ScannerLine"];
    }
    return _scannerLine;
}

/** 扫描器下方提示文字 */
- (UILabel *)tipLab {
    if (!_tipLab) {
        _tipLab = [[UILabel alloc]initWithFrame:CGRectMake(0, Scanner_Y + Scanner_Width, self.frame.size.width, 50)];
        _tipLab.textAlignment = NSTextAlignmentCenter;
        _tipLab.textColor = [UIColor lightGrayColor];
        _tipLab.text = @"将二维码/条码放入框内，即可自动扫描";
        _tipLab.font = [UIFont systemFontOfSize:12];
    }
    return _tipLab;
}

/** 手电筒开关 */
- (UIButton *)flashlightBtn {
    if (!_flashlightBtn) {
        _flashlightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _flashlightBtn.frame = CGRectMake((self.frame.size.width - FlashlightBtn_Width)/2, Scanner_Y + Scanner_Width - 15 - FlashlightLab_Height - FlashlightBtn_Width, FlashlightBtn_Width, FlashlightBtn_Width);
        _flashlightBtn.enabled = NO;
        _flashlightBtn.alpha = 0;
        [_flashlightBtn addTarget:self action:@selector(flashlightClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_flashlightBtn setBackgroundImage:[UIImage imageNamed:@"SWQRCode.bundle/Flashlight_Off"] forState:UIControlStateNormal];
        [_flashlightBtn setBackgroundImage:[UIImage imageNamed:@"SWQRCode.bundle/Flashlight_On"] forState:UIControlStateSelected];
    }
    return _flashlightBtn;
}

/** 手电筒提示文字 */
- (UILabel *)flashlightLab {
    if (!_flashlightLab) {
        _flashlightLab = [[UILabel alloc]initWithFrame:CGRectMake(Scanner_X, Scanner_Y + Scanner_Width - 10 - FlashlightLab_Height, Scanner_Width, FlashlightLab_Height)];
        _flashlightLab.font = [UIFont systemFontOfSize:12];
        _flashlightLab.textColor = [UIColor whiteColor];
        _flashlightLab.text = @"轻触照亮";
        _flashlightLab.alpha = 0;
        _flashlightLab.textAlignment = NSTextAlignmentCenter;
    }
    return _flashlightLab;
}

@end
