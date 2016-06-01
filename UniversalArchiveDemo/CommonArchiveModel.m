//
//  CommonArchiveModel.m
//  CommonArchiveDemo
//
//  Created by DaDa on 16/6/1.
//  Copyright © 2016年 Dada. All rights reserved.
//  通用归档模型，可直接用于其它工程

#import "CommonArchiveModel.h"
@import ObjectiveC.runtime;

@interface CommonArchiveModel ()<NSCoding>

@end

@implementation CommonArchiveModel

/** 通过“属性列表”进行取值赋值 
 
 只归档@property声明的属性，
 在@interface和@interface-extension声明的属性都将被归档
 
 **/


/*
- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (int i=0; i<outCount; i++) {
        objc_property_t property = properties[i];
        const char *char_f = property_getName(property);
        //propertyName包含下划线，对些功能并无影响
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:propertyName];
        if (!propertyName || !propertyValue) {
            continue;
        }
        [aCoder encodeObject:propertyValue forKey:propertyName];
    }
    free(properties);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        unsigned int outCount;
        objc_property_t *properties = class_copyPropertyList([self class], &outCount);
        for (int i=0; i<outCount; i++) {
            objc_property_t property = properties[i];
            const char *char_f = property_getName(property);
            NSString *propertyName = [NSString stringWithUTF8String:char_f];
            id propertyValue = [aDecoder decodeObjectForKey:propertyName];
            if (!propertyName || !propertyValue) {
                continue;
            }
            [self setValue:propertyValue forKey:propertyName];//此外可扩展，写个接口传进一个字典，把key/value映射到self
        }
        free(properties);
    }
    return self;
}
*/



/** 通过“变量列表”进行取值赋值 
 归档属性及实例变量，包括@interface和@interface-extension的属性和实例变量
 
 **/
- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int outCount, index;
    Ivar *ivars = class_copyIvarList([self class], &outCount);
    
    for (index = 0; index < outCount; index++) {
        Ivar varName = ivars[index];
        NSString *varKey = [NSString stringWithCString:ivar_getName(varName) encoding:NSUTF8StringEncoding];
        NSLog(@"encode varKey = %@",varKey);
        
        id varValue = [self valueForKey:varKey];//从当前对象取值
        if (!varKey || !varValue || [[self ignoreVarKeys] containsObject:varKey]) {
            continue;
        }
        [aCoder encodeObject:varValue forKey:varKey];//归档
    }
    free(ivars);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        unsigned int outCount,index;
        Ivar *ivars = class_copyIvarList([self class], &outCount);
        for (index=0; index<outCount; index++) {
            Ivar varName = ivars[index];
            const char *char_f = ivar_getName(varName);
            NSString *varKey = [NSString stringWithUTF8String:char_f];
            
            id varValue = [aDecoder decodeObjectForKey:varKey];//解档
            if (!varKey || ! varValue  || [[self ignoreVarKeys] containsObject:varKey]) {
                continue;
            }
            NSLog(@"decode varKey = %@",varKey);
            [self setValue:varValue forKey:varKey];//给当前对象赋值
        }
        free(ivars);
    }
    return self;
}

//  override by subclass,return the variables that don't need to
//  archive or unarchive
- (NSArray*)ignoreVarKeys {//子类重写此方法，返回不需要归解档的变量集
    return nil;
}

@end
