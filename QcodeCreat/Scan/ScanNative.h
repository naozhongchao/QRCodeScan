//
//  ScanNative.h
//  Learn
//
//  Created by Apple on 2017/4/20.
//  Copyright © 2017年 YiChuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol DeviceScanDelegate<NSObject>

/**
 得到扫描结果代理方法

 @param scanResult 扫描结果
 */
- (void)getScanResult:(NSString *)scanResult;

@end

@interface ScanNative : NSObject

/**
 扫描结果代理
 */
@property (nonatomic, weak) id<DeviceScanDelegate>scanDelegate;
@property (nonatomic, assign) BOOL isOpen;
/**
 初始化方法

 @param preView 展示视图
 @param cropRect 扫描区域
 @return ScanNative实例
 */
- (instancetype)initWithPreView:(UIView *)preView cropRect:(CGRect)cropRect;

/**
 开启扫描
 */
- (void)startScan;

/**
 停止扫描
 */
- (void)stopScan;

/**
 开启或者关闭闪光灯
 */
- (void)changeFlash:(BOOL)open;

/**
 关闭闪光等
 */
//- (void)closeFlash;








@end
