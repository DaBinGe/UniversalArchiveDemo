//
//  CommonArchiveModel.h
//  CommonArchiveDemo
//
//  Created by DaDa on 16/6/1.
//  Copyright © 2016年 Dada. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 归解档基类（也可把该类写成NSObject的Category，
    即可让所有引用本头文件内的id类型对象使用当前归解档功能）
 不直接使用该类进行归解档，
 其子类可添加任意的属性和实例变量。
 **/
@interface CommonArchiveModel : NSObject

- (NSArray*)ignoreVarKeys;

@end
