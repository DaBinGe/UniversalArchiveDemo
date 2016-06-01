//
//  ViewController.m
//  UniversalArchiveDemo
//
//  Created by DaDa on 16/6/1.
//  Copyright © 2016年 Da. All rights reserved.
//

#import "ViewController.h"
#import "JavaModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self archiveJavaModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self unarchiveJavaModel];//手指从屏幕放开时查看解档结果
}

#pragma mark Archive & Unarchive
- (void)archiveJavaModel {//归档一个java model
    JavaModel *model = [[JavaModel alloc]init];
    model.version = @"1.0.1";
    model.libraryStatic = @[@"java.lang"];
    BOOL succeed = [NSKeyedArchiver archiveRootObject:model toFile:[self javaModelArchiveFilePath]];
    NSLog((succeed ? @"归档成功" : @"归档失败"));
    
}

- (void)unarchiveJavaModel {//解档一个java model
    id obj = [NSKeyedUnarchiver unarchiveObjectWithFile:[self javaModelArchiveFilePath]];
    if (obj && [obj isKindOfClass:[JavaModel class]]) {
        JavaModel *model = obj;
        NSLog(@"decode result:\nversion = %@,\n libraryStatic = %@,\n IDE name = %@",
              model.version,model.libraryStatic,[model ideName]);
    }
}

#pragma mark FilePaths
- (NSString*)javaModelArchiveFilePath {//归档java model的文件路径
    return [self filePathWithDocumentLastPathComponent:kArchiveJavaModelLastPathComponent];
}

- (NSString*)filePathWithDocumentLastPathComponent:(NSString *)lastPathComponent {//拼接完整的文件路径
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:lastPathComponent];
}


@end
