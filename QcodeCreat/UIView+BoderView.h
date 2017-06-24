//
//  UIView+BoderView.h
//  Miaobiandemo
//
//  Created by YiChuan on 16/6/24.
//  Copyright © 2016年 YiChuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (BoderView)
/**
 *  设置View边框
 *
 *  @param cornerRadius 边框角弧度半径
 *  @param borderColor  边框颜色
 *  @param borderWidth  边框宽度
 */
- (void)setBorderViewCornerRadius:(CGFloat)cornerRadius borderColor:(CGColorRef)borderColor borderWidth:(CGFloat)borderWidth;
@end
