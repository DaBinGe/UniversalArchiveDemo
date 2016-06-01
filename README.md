# UniversalArchiveDemo
This demo describes two ways to archive or unarchive all of the NSObject objects and its    
subclass objects.One way uses Ivar and another uses objc_property_t.    
本例子通过objc/runtime，分别使用Ivar和objc_property_t两种方式，实现id对象类型的归解档。

IDE:  Mac OS EI Capitan 10.11.4,Xcode 7.3.1 (7D1014)

# Abstract
Getting the object's variable names by runtime,and getting variable value by Key-Value-Coding,    
to encode or decode in loop.    
通过运行时，循环取出当前对象的变量名，以及KVC通过变量名进行取值赋值，再通过得到的键和值进行归档解档。

# Usage
相关的Objc运行时模块： @import ObjectiveC.runtime;    
或头文件： #import <objc/runtime.h>    
    
Please copy or move the files CommonArchiveModel.h and CommonArchiveModel.m to your project,    
then you can use it directly.    
使用时，直接引入通用归解档基类CommonArchiveModel到相应工程中即可。

## Archive
Create a new Cocoa Class ,which is subclass of CommonArchiveModel,and add properties    
and variables to it.Then use the method archiveRootObject:toFile: of NSKeyedArchiver to    
archive the model to designated path.    
新建CommonArchiveModel子类，在该子类添加相关的属性或实例变量；    
把需要归档的子类对象用[NSKeyedArchiver archiveRootObject:toFile:]归档到指定目录下。    

### objc_property_t Archive Codes

```
- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (int i=0; i<outCount; i++) {
        objc_property_t property = properties[i];
        const char *char_f = property_getName(property);
        //propertyName包含下划线，对此功能并无影响
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:propertyName];
        if (!propertyName || !propertyValue) {
            continue;
        }
        [aCoder encodeObject:propertyValue forKey:propertyName];
    }
    free(properties);
}

```


### Ivar Archive Codes

```
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

```

## Unarchive
Call the class method unarchiveObjectWithFile of NSKeyedUnarchiver to unarchive the object    
which was archived before.And the log its values that is used to compare the values before archive.    
调用[NSKeyedUnarchiver unarchiveObjectWithFile:]解档一个自定义模型，查看基属性的值是否     
和之前归档的一致。

### objc_property_t Unarchive Codes

```
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
```



### Ivar Unarchive Codes

```
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
```
Please look at the project files to know other details.    
其它细节请查看工程的文件。

