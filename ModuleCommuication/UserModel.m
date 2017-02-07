//
//  UserModel.m
//  ModuleCommuication
//
//  Created by L's on 2017/2/7.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

-(NSDictionary*)getUserInfo{
    NSDictionary* info = @{@"userId": @"8888", @"name": @"张三", @"age": @18};
    
    return info;
}

@end
