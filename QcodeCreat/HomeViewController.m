//
//  HomeViewController.m
//  QcodeCreat
//
//  Created by Apple on 2017/6/2.
//  Copyright © 2017年 ChaoTian. All rights reserved.
//

#import "HomeViewController.h"
#import "ScanViewController.h"
#define  RGB(x, y, z)  [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:1.0]

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(240, 240, 240);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:button];
    [button setTitle:@"扫一扫" forState:0];
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    button.bounds = CGRectMake(0, 0, 100, 30);
    button.center = self.view.center;
    [button addTarget:self action:@selector(gotoScanVC:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
}
- (void)gotoScanVC:(UIButton *)sender {
    ScanViewController *vc = [[ScanViewController alloc] init];
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
