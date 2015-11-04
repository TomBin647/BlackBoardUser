//
//  UIImage+Helper.m
//  KDFuDao
//
//  Created by bing.hao on 14-6-19.
//  Copyright (c) 2014年 bing.hao. All rights reserved.
//

#import "UIImage+Helper.h"

@implementation UIImage (Helper)

+ (id)imageWithColor:(UIColor *)color frame:(CGRect)frame
{
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, frame);

    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (UIImage *)imageZoomWithSize:(CGSize)size
{
    CGSize newSize = self.size;
    CGFloat areaWidth  = self.size.width >= self.size.height ? size.width : size.height;
    CGFloat areaheight = self.size.width >= self.size.height ? size.height : size.width;
    
    if (newSize.width > areaWidth) {
        
        CGFloat w = areaWidth;
        CGFloat h = (self.size.height) / (self.size.width / areaWidth);

        newSize = CGSizeMake(w, h);
    } else if (self.size.height > areaheight) {

        CGFloat h = areaheight;
        CGFloat w = (self.size.width) / (self.size.height / areaheight);

        newSize = CGSizeMake(w, h);
    }

    if (CGSizeEqualToSize(newSize, self.size)) {
        return self;
    }
    
    UIGraphicsBeginImageContext(newSize);

    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];

    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();

    return newImage;
}

@end
