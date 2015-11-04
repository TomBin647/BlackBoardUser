//
//  Common.h
//  ArtsEye
//
//  Created by bing.hao on 13-9-9.
//  Copyright (c) 2013年 bing.hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define __IOS7_OR_LATER [[UIDevice currentDevice].systemVersion floatValue] >= 7.0f
#define __IOS8_OR_LATER [[UIDevice currentDevice].systemVersion floatValue] >= 8.0f

#define kMainScreenFrame [[UIScreen mainScreen] bounds]
#define kMainScreenWidth  kMainScreenFrame.size.width
#define kMainScreenHeight kMainScreenFrame.size.height
#define kApplicationFrame [[UIScreen mainScreen] applicationFrame]

/**
 * @brief 解决BLOCK在Controller中引起循环引用而定义宏,将当前SELF转换为一个弱引用在BLOCK中调用
 */
#define KS_BLOCK_WEAK(t, alias) __weak __typeof(t)alias = t
/**
 * @brief 在BLOCK中装弱引用转化为强引用。出BLOCK后会自动释放
 */
#define KS_BLOCK_STRONG(t, alias) __strong __typeof(t)alias = t

/**
 * @brief 释放一个对象
 */
#define ObjectRelease(_v) _v = nil;

/**
 * @brief 为一个对象负值, 并释放原有的值。
 */
#define ObjectAssignment(_v1, _v2) _v1 = nil; _v1 = _v2;

/**
 * @brief 主线程运行block语句块
 */
void runDispatchGetMainQueue(void (^block)(void));

/**
 * @brief 子线程运行block语句块
 */
void runDispatchGetGlobalQueue(void (^block)(void));


NSURL * getThumbnailUrlWithPath(NSString *, CGSize);

/**
 * @brief 现实对话框
 */
void showAlert(NSString *, NSString *);

void showMessageBox(NSString *);

/**
 * @brief 获取Document下文件路径
 */
NSString * pathdwf(NSString *, ...);

/**
 * @brief 获取Cache下文件路径
 */
NSString * pathcwf(NSString *, ...);

/**
 * @brief 获取Temp下文件路径
 */
NSString * pathtwf(NSString *, ...);

/**
 * @brief GUID
 */
NSString * uuid();

/**
 * @brief 以当前时间获得一个文件名
 */
NSString * dfn(NSString *);

/**
 * @brief RGB 颜色
 */
UIColor * rgba(float, float, float, float);

/**
 * @brief 16进制颜色
 */
UIColor * hexColor(int, float);
/**
 * @brief 判断一个字符串是否为空
 */
BOOL isEmptyOrNull(NSString *);

/**
 * @brief 范围随机数
 */
int rrandom(int , int );

/**
 * @brief 半一个字符串转加密为MD5字符串
 */
NSString * md5String(NSString *);

/**
 * @brief 获取拼音首字母
 */
char pfl(unsigned short hanzi);

BOOL testEmail(NSString *);

@interface Console : NSObject

@property (nonatomic, assign) BOOL enabled;

+ (id)share;

- (void)log:(NSObject *)output;
- (void)logWithFormat:(NSString *)format,...;
//- (void)consoleWithError:(NSError *)output;

@end
