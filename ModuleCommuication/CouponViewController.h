//
//  CouponViewController.h
//  ModuleCommuication
//
//  Created by L's on 2017/1/23.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModuleProtocol.h"

@interface CouponViewController : UIViewController

/** 优惠券过滤器  过滤优惠券使用 */
/*
 {
    type:1
    amount:100.50(元)
 }
 
 */

@property (nonatomic, strong)NSDictionary* couponFilter;

@property (nonatomic, weak) id<ModuleDelegate> delegate;

@end
