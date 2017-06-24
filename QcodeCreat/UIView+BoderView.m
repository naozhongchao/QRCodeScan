//
//  UIView+BoderView.m
//  Miaobiandemo
//
//  Created by YiChuan on 16/6/24.
//  Copyright © 2016年 YiChuan. All rights reserved.
//

#import "UIView+BoderView.h"

@implementation UIView (BoderView)

- (void)setBorderViewCornerRadius:(CGFloat)cornerRadius borderColor:(CGColorRef)borderColor borderWidth:(CGFloat)borderWidth {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderColor = borderColor;
    self.layer.borderWidth = borderWidth;
    

}
@end
