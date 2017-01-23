//
//  CouponViewController.m
//  ModuleCommuication
//
//  Created by L's on 2017/1/23.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "CouponViewController.h"

/** 优惠券类型  内部类 */
typedef NS_ENUM(NSInteger, CouponType){
    CouponTypeDefault = 0,
    
    /** 电费 */
    CouponTypeElectricityFee,
    
    /** 水费 */
    CouponTypeWaterFee,
    
    /** 燃气费 */
    CouponTypeGasFee
};

@interface CouponViewController ()

@end

@implementation CouponViewController

-(void)setDelegate:(id<ModuleDelegate>)delegate{
    _delegate = delegate;
    
    NSLog(@"delegate::%@", delegate);
}

-(void)setCouponFilter:(NSDictionary *)couponFilter{
    NSLog(@"上个页面带来的参数:%@", couponFilter);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"选择优惠券" style:(UIBarButtonItemStylePlain) target:self action:@selector(chooseCoupon)];
    
    
//    NSLog(@"==信息==：%@", self.couponFilter);
    // Do any additional setup after loading the view.
}

-(void)chooseCoupon{
    if (self.delegate && [self.delegate respondsToSelector:@selector(module:info:)]) {
        [self.delegate module:self.class.description info:@{@"type":@"super coupon", @"desc": @"可狠了", @"fee":@50}];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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
