//
//  UIView+Helper.h
//  ArtsEye
//
//  Created by bing.hao on 14-5-6.
//  Copyright (c) 2014年 bing.hao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    KSVIEW_DRAK_DIRECTION_LEFT,
    KSVIEW_DRAK_DIRECTION_RIGHT,
    KSVIEW_DRAK_DIRECTION_TOP,
    KSVIEW_DRAK_DIRECTION_BOTTOM
} KSVIEW_DRAK_DIRECTION;

@interface UIView (Helper)

@property CGFloat width;
@property CGFloat height;

@property CGFloat top;
@property CGFloat left;
@property CGFloat right;
@property CGFloat bottom;

@property CGFloat x;
@property CGFloat y;

- (void)movieWithPoint:(CGPoint)point animated:(BOOL)animated;

+ (void)fillBackgroundWithTarget:(UIView *)target withName:(NSString *)name;
+ (void)fillBackgroundWithTarget:(UIView *)target withName:(NSString *)name withSize:(CGSize)size;

- (void)removeAllSubviews;

/**
 * @brief 停靠在某一视图旁边(设置停靠前需要设置好宽高)
 * @param view      要停靠的视图
 * @param direction 停靠方向
 * @param point     坐标
 */
- (void)drak:(UIView *)view direction:(KSVIEW_DRAK_DIRECTION)direction point:(CGPoint)point;

@end
