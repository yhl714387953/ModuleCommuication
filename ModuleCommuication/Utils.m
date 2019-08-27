//
//  Utils.m
//  ModuleCommuication
//
//  Created by L's on 2017/2/7.
//  Copyright © 2017年 zuiye. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+(NSDictionary *)formatInfo:(NSDictionary *)info{
    if (![info isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    for (id key in info) {
        dic[key] = [NSString stringWithFormat:@"zuiye_%@", info[key]];
    }
    
    return dic;
}

@end
