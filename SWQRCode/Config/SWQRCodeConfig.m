//
//  SWQRCodeConfig.m
//  SWQRCode_Objc
//
//  Created by zhuku on 2018/4/4.
//  Copyright © 2018年 selwyn. All rights reserved.
//

#import "SWQRCodeConfig.h"

@implementation SWQRCodeConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.scannerCornerColor = [UIColor colorWithRed:63/255.0 green:187/255.0 blue:54/255.0 alpha:1.0];
        self.scannerBorderColor = [UIColor whiteColor];
        self.indicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    }
    return self;
}

@end
