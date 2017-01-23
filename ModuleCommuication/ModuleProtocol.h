//
//  ModuleProtocol.h
//  ModuleCommuication
//
//  Created by L's on 2017/1/23.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#ifndef ModuleProtocol_h
#define ModuleProtocol_h


/**
 
 通信方式示例
 
 Class class = NSClassFromString(@"CouponViewController");
 
 UIViewController* couponVC = [[class alloc] init];
 
 //设置delegate
 SEL delegateSEL = NSSelectorFromString(@"setDelegate:");
 if ([couponVC respondsToSelector:delegateSEL]) {
    SuppressPerformSelectorLeakWarning(
        [couponVC performSelector:delegateSEL withObject:self];
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
 
 */

/** 解决编译的时候出错的问题 */
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


/**
    通信协议，所有页面的接口都在这个公共的协议方法里定义
 */
@protocol ModuleDelegate <NSObject>

@optional

/**
 对外提供接口的模块必须实现delegate设置的方法，当然方法叫什么名字无所谓 内部如何写无所谓(你问我为啥叫setDelegate，就写方法的时候少敲几个字母，复用属性的set方法了)，主要是要拿到delegate

 @param delegate 称为其delegate的对象
 */
-(void)setDelegate:(id<ModuleDelegate>)delegate;

/*******************优惠券页面通信协议***********************/

/**
 设置接口参数
 
 给优惠券页面传递参数，方法名字无所谓(你问我为啥叫setCouponFilter，就写方法的时候少敲几个字母，复用属性的set方法了)，重点在obj这个参数上了，模块内部如何处理这里不去管，这里直接实现了属性的set方法
 接口里的属性建议放到.h接口文件中，便于模块内部自己维护

 @param obj 提供给模块的参数
 */
-(void)setCouponFilter:(id)obj;

/**
 优惠券页面回调

 @param obj 预留，传递什么无所谓，目前传递了本身，便于外部查看
 @param info 回调的参数
 */
-(void)module:(id)obj info:(id)info;
/*******************优惠券页面通信协议***********************/


@end



#endif /* ModuleProtocol_h */
