//
//  CreatQcodeViewController.m
//  QcodeCreat
//
//  Created by Apple on 2017/6/2.
//  Copyright © 2017年 ChaoTian. All rights reserved.
//

#import "CreatQcodeViewController.h"
#import "Masonry.h"
#import <CoreImage/CoreImage.h>
#import "UIView+Toast.h"
#import "UIView+BoderView.h"
#define  RGB(x, y, z)  [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:1.0]
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface CreatQcodeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *chipNumField;
@property (weak, nonatomic) IBOutlet UITextField *deviceTypeField;
@property (nonatomic, strong) NSString *chipNum;
@property (nonatomic, strong) UIImageView * qRcodeImageVie;
@property (nonatomic, strong) UILabel *stationNumLable;
@property (nonatomic, strong) UIView *qrCodeView;
@end

@implementation CreatQcodeViewController
- (instancetype)initWithChipNum:(NSString *)string
{
    self = [super init];
    if (self) {
        _chipNum =string;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _chipNumField.text = self.chipNum;
    
    _qrCodeView = [[UIView alloc] init];
    [self.view addSubview:_qrCodeView];
    
    [_qrCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(120);
        make.bottom.mas_equalTo(-150);
    }];
    [self.view layoutIfNeeded];
    UIView *borderView = [[UIView alloc] init];
    [_qrCodeView addSubview:borderView];
    [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(-5);
        make.left.top.mas_equalTo(5);
    }];
    [borderView setBorderViewCornerRadius:10 borderColor:[UIColor blackColor].CGColor borderWidth:3];

    _qRcodeImageVie = [[UIImageView alloc] init];
    [borderView addSubview:_qRcodeImageVie];
    [_qRcodeImageVie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(20);
        make.height.width.mas_equalTo(300);
    }];
    _stationNumLable = [[UILabel alloc] init];
    [borderView addSubview:_stationNumLable];
    _stationNumLable.textColor = RGB(51, 51, 51);
    _stationNumLable.font = [UIFont systemFontOfSize:30];
    [_stationNumLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(_qRcodeImageVie.mas_bottom).mas_equalTo(10);
        make.height.mas_equalTo(40);
    }];

    // Do any additional setup after loading the view from its nib.
}
- (IBAction)saveQCode:(id)sender {
    if (!self.qRcodeImageVie.image) {
        [self.view makeToast:@"还没生成二维码呢!!"];
        
        return;
    }
    UIImage *qrCodeimage = [self imageFromView:self.qrCodeView];
     UIImageWriteToSavedPhotosAlbum(qrCodeimage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    [self.view makeToastActivity:CSToastPositionCenter];

}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    [self.view hideToasts];
    if (error) {
        [self.view makeToast:@"保存失败"];
        
    } else {
        [self.view makeToast:@"保存成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

- (IBAction)creatQCode:(UIButton *)sender {
    
//    if (self.deviceTypeField.text.length != 4) {
//        [self.view makeToast:@"设备类型位数不对"];
//        return;
//    }
    if (self.chipNumField.text.length != 15) {
        [self.view makeToast:@"芯片编号位数不对"];
        return;
    }
    
    NSString *QRCodeNString = [NSString stringWithFormat:@"http://www.hzchaotiankj.com/weixin/payone?num=1000%@",self.chipNumField.text];
   self.qRcodeImageVie.image = [self SG_generateWithDefaultQRCodeData:QRCodeNString imageViewWidth:300];
    self.stationNumLable.text = [NSString stringWithFormat:@"1000%@",self.chipNumField.text];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIImage *)SG_generateWithDefaultQRCodeData:(NSString *)data imageViewWidth:(CGFloat)imageViewWidth {
    // 1、创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 恢复滤镜的默认属性
    [filter setDefaults];
    
    // 2、设置数据
    NSString *info = data;
    // 将字符串转换成
    NSData *infoData = [info dataUsingEncoding:NSUTF8StringEncoding];
    
    // 通过KVC设置滤镜inputMessage数据
    [filter setValue:infoData forKeyPath:@"inputMessage"];
    
    // 3、获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    
    return [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:imageViewWidth];
}
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

//获得屏幕图像
- (UIImage *)imageFromView: (UIView *) theView
{

    CGSize s = theView.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//获得某个范围内的屏幕图像
- (UIImage *)imageFromView: (UIView *) theView   atFrame:(CGRect)r
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(r);
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  theImage;//[self getImageAreaFromImage:theImage atFrame:r];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}








/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
