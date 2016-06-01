//
//  JavaModel.m
//  CommonArchiveDemo
//
//  Created by DaDa on 16/6/1.
//  Copyright © 2016年 Dada. All rights reserved.
//

#import "JavaModel.h"

@interface JavaModel ()
{
    //这里的实例变量要通过“变量列表”的方式才能进行归解档
    NSString *integrateDevelopmentEnvironmentName;//集成开发环境名
}

@end

@implementation JavaModel

- (instancetype)init {
    self = [super init];
    if (self) {
        integrateDevelopmentEnvironmentName = @"Java-Spring Tool Suite";
    }
    return self;
}

- (NSString*)ideName {
    return integrateDevelopmentEnvironmentName;
}

- (NSArray*)ignoreVarKeys {
    return @[@"_customSDK"];
}

@end
