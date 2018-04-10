# SWQRCode_Objc

![image](https://github.com/RockChanel/SWGIF/blob/master/SWQRCode.gif)

简书地址：[iOS 高仿微信扫一扫](https://www.jianshu.com/p/1fc34089adf5)

`SWQRCode_Objc` 为 `SWQRCode` objecive-c 版本，高仿微信扫一扫功能，包括`二维码/条码识别、相册图片二维码/条码识别、手电筒功能`等，请使用真机进行测试。

`SWQRCode_Objc` 舍弃了 `NSTimer` 而采用 `CABasicAnimation` 实现扫一扫动画效果。

若需在项目中使用，只需将 `SWQRCode` 文件夹拖入项目中，并在 `info.plist` 中添加 `Privacy - Photo Library Usage Description` 以及 `Privacy - Camera Usage Description` 配置，声明相机相册权限。
 
`SWQRCode_Objc` 主要 API :

    #pragma mark -- 扫一扫API
    /**
     处理扫一扫结果
     @param value 扫描结果
     */
    - (void)sw_handleWithValue:(NSString *)value {
        NSLog(@"sw_handleWithValue === %@", value);
    }
    
    /**
     相册选取图片无法读取数据
     */
    - (void)sw_didReadFromAlbumFailed {
        NSLog(@"sw_didReadFromAlbumFailed");
    }

