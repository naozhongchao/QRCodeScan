//
//  ScanViewController.m
//  QcodeCreat
//
//  Created by Apple on 2017/6/2.
//  Copyright © 2017年 ChaoTian. All rights reserved.
//
// P/N:S2-10686-Z1L0T;SN:MP0616482740785;IMEI:863586033454525;BTMAC:381C4AB8B5EF;SW:1418B05SIM800C24_BT
#import "ScanViewController.h"
#import "ScanView.h"
#import "ScanNative.h"
#import "Masonry.h"
#import "CreatQcodeViewController.h"
#import "UIView+Toast.h"
#define  RGB(x, y, z)  [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:1.0]
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface ScanViewController ()<DeviceScanDelegate>

@property (nonatomic, strong) ScanView *scanView;
@property (nonatomic, strong) ScanNative *scanNative;
@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫一扫";
    self.view.backgroundColor = [UIColor blackColor];
    [self creatScan];
    
    [self initUI];
    // Do any additional setup after loading the view.
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_scanNative stopScan];
    [_scanView scanLineStopAction];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_scanNative startScan];
    [_scanView scanLineStartAction];

}

- (void)creatScan {
    CGFloat scanW = SCREEN_WIDTH * 0.65;
    CGFloat marginX = (SCREEN_WIDTH - scanW) * 0.5;
    CGFloat marginY = (SCREEN_HEIGHT - scanW) * 0.5;
    
    ScanNative *scanNative = [[ScanNative alloc] initWithPreView:self.view cropRect:CGRectMake(marginY/SCREEN_HEIGHT, marginX/SCREEN_WIDTH, scanW/SCREEN_HEIGHT, scanW/SCREEN_WIDTH)];
    scanNative.scanDelegate = self;
    self.scanNative = scanNative;
    
    
}
- (void)initUI {
    _scanView = ({
        
        UIColor *yellowColor = RGB(237, 167, 36);
        ScanView *scanView = [[ScanView alloc] initWithColor:yellowColor.CGColor];
        [self.view addSubview:scanView];
        scanView;
        
    });
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [_scanView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_scanView.mas_centerX);
        make.bottom.mas_equalTo(-40);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(200);
    }];
    [button setTitle:@"扫不出来就手动输入" forState:0];
    [button addTarget:self action:@selector(gotoVC:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)gotoVC:(UIButton *)btn {
    [self gotoCreatQcodeVC:nil];
}
- (void)getScanResult:(NSString *)scanResult {
    if (scanResult) {
        if ([scanResult containsString:@"P/N:"] == NO) {
            [self.view makeToast:@"不要乱扫，手机会坏的！！"];
            [self.scanNative startScan];
            return;
        }
        NSString *numStr = [scanResult substringWithRange:NSMakeRange(43, 15)];
        [self gotoCreatQcodeVC:numStr];
    }
}
- (void)gotoCreatQcodeVC:(NSString *)str {
    CreatQcodeViewController  *vc = [[CreatQcodeViewController alloc] initWithChipNum:str];
    [self.navigationController pushViewController:vc animated:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
