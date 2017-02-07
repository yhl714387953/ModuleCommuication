##组件化开发之组件通信

组件化架构、通信方案想必大家都看到很多，[蘑菇街李忠](http://limboy.me/) 、[casatwy](http://casatwy.com/) 这两个博客收益颇多，我先说下开始我的组件通信思路。
****

前期我讲述了，如何用cocoapods模块化一个工程，那么就面临一个问题。**开发工程师除了能看到基础模块和自己写的模块之外，看不到别人写的模块，别人的模块叫什么名字也不知道，如何通信呢**

我们需要解决三个问题

> * 视图展示：比如普通的跳转
> * 参数传递：比如我们到订单页面，至少要给这个页面一个订单号
> * 回调：一说到回调，那就是block、delegate占大多数了

###首先我们解决视图展示问题

```
Class class = NSClassFromString(@"CouponViewController");
UIViewController* couponVC = [[class alloc] init];
[self.navigationController pushViewController:couponVC animated:YES];
```

上面的代码很容易看懂是我要跳转到**CouponViewController**页面

###其次我们解决参数传递问题
一提起delegate，原理就简单的理解为：**比如A跳转到B了，B页面让A页面就调用一个方法并传递参数**，这里我们正向去考虑 **A页面直接让B页面主动调用一个方法并传递参数**这里就以类似delegate的方式实现了参数传递

**回到代码里**

```
performSelector: withObject:
```
大家对上面的方法可能看到的比较多，只要调用perform开头的方法，这个方法就摆在第一位了，今天终于排上用场了。

比如在A页面调整到B页面，第一步我们想办法已经创建了这个B对象了，上面的方法的作用就是让B去调用他自己实现的方法，同时给传递一个参数，原理跟delegate一样

下面是A页面的代码，我们假定有一个按钮，点击后执行如下的方法**跳转到B页面并且传递一个参数**

```
//传递参数
	Class class = NSClassFromString(@"AViewController");
    UIViewController* BVC = [[class alloc] init];
    
    SEL selector = NSSelectorFromString(@"setCouponFilter:");
    if ([BVC respondsToSelector:selector]) {
       [BVC performSelector:selector withObject:@{@"name": @"This is a super order"}];
    }

    [self.navigationController pushViewController: AVC animated:YES];
```

那么我们在B页面实现一下这个方法

```
-(void)setCouponFilter:(NSDictionary *)couponFilter{
    NSLog(@"上个页面带来的参数:%@", couponFilter);
}

```

那么在B页面就会看到输出这个参数了，参数你拿到了，随便怎么处理了

###最后我们解决回调问题

我们假设用delegate去做，可以定义一个协议，同时也要设置一个delegate，我们假定要A页面称为B页面的delegate，那么以前我们会在B页面的接口文件.h中声明一个代理，现在声明也没有用了，因为看不到！那么如何设置呢？delegate也可以当做一个普通的参数传递，比如在**A页面将self，作为参数传递过去**

```
SEL delegateSEL = NSSelectorFromString(@"setDelegate:");
if ([BVC respondsToSelector:delegateSEL]) {
	[BVC performSelector:delegateSEL withObject:self]; 
    }
```

在**B页面**，我们就声明一个delegate属性，把set方法当做我们的传递参数方法

```
-(void)setDelegate:(id<ModuleDelegate>)delegate{
    _delegate = delegate;
    
    NSLog(@"delegate::%@", delegate);
}

```
在跳转到B页面的时候，会看到有delegate输出了，这样delegate也有了，我们就可以像普通的delegate方式去使用了
> * 定义一个协议，大家都能看到的协议
> * 为B页面设置一个delegate，目前就A页面
> * 在A页面中实现协议的方法，其实就是B让A调用的方法


**公共协议部分**

```
@protocol ModuleDelegate <NSObject>

@optional
-(void)module:(id)obj info:(id)info;

```

**B页面某个操作后调用了这个方法**

```
if (self.delegate && [self.delegate respondsToSelector:@selector(module:info:)]) {
        [self.delegate module:self.class.description info:@{@"type":@"super coupon", @"desc": @"可狠了", @"fee":@50}];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
```

**在A页面中**

```
-(void)module:(id)obj info:(id)info{
    NSLog(@"module: %@      info: %@", obj, info);
}
```

这样通信方式的基本原理就完事了。

***
这里的类名、方法名都属于硬编码，参数用的字典，为了去model化，就必须要求去维护一个**Protocol**，这里我定义了一个公共的**Protocol**

```
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


```


####还没完事呢，大家会发现一个问题，就是如果执行下面的方法会有警告啊

```
performSelector: withObject:
```

可以这样解决

```
#pragma clang diagnostic push 
#pragma clang diagnostic ignored "-Warc-performSelector-leaks" 
   [someController performSelector: NSSelectorFromString(@"someMethod")]
#pragma clang diagnostic pop
```

为了解决这个问题我们定义一个宏

```
/** 解决编译的时候出错的问题 */
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)
```

在调用的时候

```
//传递参数
    SEL selector = NSSelectorFromString(@"setCouponFilter:");
    if ([BVC respondsToSelector:selector]) {
        SuppressPerformSelectorLeakWarning(
          [BVC performSelector:selector withObject:@{@"name": @"This is a super order"}];
                                           );
    }
```

###其他处理
这里我们集中在控制器处理上了，现实中夸组件调用各种各样了，比如我要从 **UserModel** 获取用户信息，在**UserModel** 实现中有如下方法

```
-(NSDictionary*)getUserInfo{
    NSDictionary* info = @{@"userId": @"8888", @"name": @"张三", @"age": @18};
    
    return info;
}

```

那么我们在外部调用就可以获取到信息

```
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
```

如果需要调用工具类**Utils**里的方法处理数据，比如工具类**Utils**有个方法是给字典里的字符串追加前缀

```
-(NSDictionary *)formatInfo:(NSDictionary *)info{
    if (![info isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    for (id key in info) {
        dic[key] = [NSString stringWithFormat:@"zuiye_%@", info[key]];
    }
    
    return dic;
}

```

那么实际调用的时候

```
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
    
```

***
总结了下我的方法有点类似于 **Target-Action** + **协议** 的方式，当然这个只是简单的实现，如果复杂的功能，那么还有去封装一下，比如原生、H5切换，我的思路不一定是最好的，如果想看看大神们的通信方案，开篇提供了链接，大家可以去看看。

感谢您阅读完毕，如有疑问，欢迎添加QQ:**714387953**(蜗牛上高速)。
**github**:[https://github.com/yhl714387953/ModuleCommuication](https://github.com/yhl714387953/ModuleCommuication)
如果有错误，欢迎指正，一起切磋，共同进步
如果喜欢可以**Follow、Star、Fork**，都是给我最大的鼓励。
