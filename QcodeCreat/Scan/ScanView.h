//
//  ScanView.h
//  Learn
//
//  Created by Apple on 2017/4/15.
//  Copyright © 2017年 YiChuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#define KMainW [UIScreen mainScreen].bounds.size.width
#define KMainH [UIScreen mainScreen].bounds.size.height
#define KMainB [UIScreen mainScreen].bounds

@interface ScanView : UIView
- (instancetype)initWithColor:(CGColorRef)color;
- (void)scanLineStopAction;
- (void)scanLineStartAction;
@end
