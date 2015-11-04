//
//  UIView+Helper.m
//  ArtsEye
//
//  Created by bing.hao on 14-5-6.
//  Copyright (c) 2014年 bing.hao. All rights reserved.
//

#import "UIView+Helper.h"
#define ObjectRelease(_v) _v = nil;


@implementation UIView (Helper)

- (CGFloat)width
{
    return CGRectGetWidth(self.frame);
}

- (void)setWidth:(CGFloat)width
{
    CGRect newfrmae = self.frame;
    
    newfrmae.size.width = width;
    
    self.frame = newfrmae;
}

- (CGFloat)height
{
    return CGRectGetHeight(self.frame);
}

- (void)setHeight:(CGFloat)height
{
    CGRect newframe = self.frame;
    
    newframe.size.height = height;
    
    self.frame = newframe;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left
{
    CGRect newframe = self.frame;
    
    newframe.origin.x = left;
    
    self.frame = newframe;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right
{
    CGRect newframe = self.frame;
    
    newframe.origin.x = right - self.frame.size.width;
    
    self.frame = newframe;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top
{
    CGRect newframe = self.frame;
    
    newframe.origin.y = top;
    
    self.frame = newframe;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect newframe = self.frame;
    
    newframe.origin.y = bottom - self.frame.size.height;
    
    self.frame = newframe;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x
{
    CGRect newFrame = self.frame;
    
    newFrame.origin.x = x;
    
    self.frame = newFrame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y
{
    CGRect newframe = self.frame;
    
    newframe.origin.y = y;
    
    self.frame = newframe;
}

- (void)movieWithPoint:(CGPoint)point animated:(BOOL)animated
{
    CGPoint moviePoint = CGPointMake(point.x + self.width / 2, point.y + self.height / 2);
    
    if (animated) {
        [UIView animateWithDuration:0.3f animations:^{
            self.center = moviePoint;
        }];
    } else {
        self.center = moviePoint;
    }
}

+ (void)fillBackgroundWithTarget:(UIView *)target withName:(NSString *)name
{
    UIImage * bgImage = [UIImage imageNamed:name];
    
    if([target viewWithTag:INT32_MAX]) {
        
        [(UIImageView *)[target viewWithTag:INT32_MAX] setImage:bgImage];
    } else {
        
        UIImageView * imageView = [[UIImageView alloc] initWithImage:bgImage];
        
//        imageView.frame            = target.bounds;
        imageView.tag              = INT32_MAX;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [target insertSubview:imageView atIndex:0];
    }
}

+ (void)fillBackgroundWithTarget:(UIView *)target withName:(NSString *)name withSize:(CGSize)size
{
    UIImage * bgImage = [UIImage imageNamed:name];
    
    if([target viewWithTag:INT32_MAX]) {
        
        [(UIImageView *)[target viewWithTag:INT32_MAX] setImage:bgImage];
    } else {
        
        UIImageView * imageView = [[UIImageView alloc] initWithImage:bgImage];
        
        //        imageView.frame            = target.bounds;
        imageView.tag              = INT32_MAX;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.frame            = CGRectMake(0, 0, size.width, size.height);
        
        [target insertSubview:imageView atIndex:0];
    }
}


- (void)removeAllSubviews
{
    while ([self.subviews count] > 0) {
        
        UIView * view = [self.subviews lastObject];
        
        [view removeFromSuperview];
        
        ObjectRelease(view);
    }
}

#pragma --mark
#pragma --mark drak

- (void)drak:(UIView *)view direction:(KSVIEW_DRAK_DIRECTION)direction point:(CGPoint)point
{
    switch (direction) {
        case KSVIEW_DRAK_DIRECTION_LEFT:
        {
            self.x = view.x - point.x - self.width;
            self.y = view.y + point.y;
            break;
        }
        case KSVIEW_DRAK_DIRECTION_RIGHT:
        {
            self.x = view.x + view.width + point.x;
            self.y = view.y + point.y;
            break;
        }
        case KSVIEW_DRAK_DIRECTION_TOP:
        {
            self.x = view.x + point.x;
            self.y = view.y - point.y - self.height;
            break;
        }
        case KSVIEW_DRAK_DIRECTION_BOTTOM:
        {
            self.x = view.x + point.x;
            self.y = view.y + view.height + point.y;
            break;
        }
    }
}

@end
