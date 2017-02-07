//
//  ViewController.m
//  ModuleCommuication
//
//  Created by L's on 2017/1/23.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "ViewController.h"
#import "ModuleProtocol.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getUserInfo:(UIButton *)sender {
    
    Class class = NSClassFromString(@"UserModel");
    SEL selector = NSSelectorFromString(@"getUserInfo");
    
    id target = [[class alloc] init];
    
    if (target && [target respondsToSelector:selector]) {
        id result;
        SuppressPerformSelectorLeakWarning(
            result = [target performSelector:selector]
                                           );
        NSLog(@"用户信息：%@", result);
    }
    
}


- (IBAction)handleObj:(UIButton *)sender {
    NSDictionary* info = @{@"userId": @"8888", @"name": @"张三", @"age": @18};
    
    
    Class class = NSClassFromString(@"Utils");
    SEL selector = NSSelectorFromString(@"formatInfo:");
    
    id target = [[class alloc] init];
    
    if (target && [target respondsToSelector:selector]) {
        id result;
        SuppressPerformSelectorLeakWarning(
            result = [target performSelector:selector withObject:info]
                                           );
        NSLog(@"用户信息追加前缀：%@", result);
    }
    
}




@end
