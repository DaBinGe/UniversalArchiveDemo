//
//  JavaModel.h
//  CommonArchiveDemo
//
//  Created by DaDa on 16/6/1.
//  Copyright © 2016年 Dada. All rights reserved.
//

#import "CommonArchiveModel.h"

static NSString *const kArchiveJavaModelLastPathComponent = @"ArchiveJavaModel";//当前模型归档最后部分路径


/**
 继承 CommonArchiveModel 可直接使用其归解档功能，
 为方便添加一个类的属性和实例变量，不直接使用父类
 **/

@interface JavaModel : CommonArchiveModel

//@property声明的属性通过“属性列表”和变量列表都能进行归解档
@property (nonatomic, copy)   NSString *grammar;//语法
@property (nonatomic, copy)   NSArray *systemFramework;//系统框架
@property (nonatomic, strong) id customSDK;//自定义工具包
@property (nonatomic, copy)   NSString *version;//版本号
@property (nonatomic, copy)   NSArray *libraryStatic;//静态库

- (NSString*)ideName;

@end
