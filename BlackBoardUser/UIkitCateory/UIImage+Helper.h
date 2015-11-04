//
//  UIImage+Helper.h
//  KDFuDao
//
//  Created by bing.hao on 14-6-19.
//  Copyright (c) 2014年 bing.hao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Helper)

+ (id)imageWithColor:(UIColor *)color frame:(CGRect)frame;
- (UIImage *)imageZoomWithSize:(CGSize)size;

@end
