//
//  PayViewController.m
//  ModuleCommuication
//
//  Created by L's on 2017/1/23.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "PayViewController.h"
#import "ModuleProtocol.h"

@interface PayViewController ()<ModuleDelegate>

@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)chooseCoupong:(UIButton *)sender {
    Class class = NSClassFromString(@"CouponViewController");
    
    UIViewController* couponVC = [[class alloc] init];
    
    //设置delegate
    SEL delegateSEL = NSSelectorFromString(@"setDelegate:");
    if ([couponVC respondsToSelector:delegateSEL]) {
        SuppressPerformSelectorLeakWarning(
         [couponVC performSelector:delegateSEL withObject:self];
        );
       
    }
    
    //    设置block
    void (^block)(id) = ^(id couponObj){
        NSLog(@"通过block回调：%@", couponObj);
    };
    SEL blockSEL = NSSelectorFromString(@"setBlock:");
    if ([couponVC respondsToSelector:blockSEL]) {
        SuppressPerformSelectorLeakWarning(
                                           [couponVC performSelector:blockSEL withObject:block];
                                           );
    }
    
    //传递参数
    SEL selector = NSSelectorFromString(@"setCouponFilter:");
    if ([couponVC respondsToSelector:selector]) {
        SuppressPerformSelectorLeakWarning(
          [couponVC performSelector:selector withObject:@{@"name": @"This is a super order"}];
                                           );
    }

    [self.navigationController pushViewController:couponVC animated:YES];
    
}

-(void)module:(id)obj info:(id)info{
    NSLog(@"module: %@      info: %@", obj, info);
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
