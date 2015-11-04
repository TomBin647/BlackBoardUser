//
//  KDMagnifierView.h
//  BlackBoardUser
//
//  Created by 高彬 on 15/11/2.
//  Copyright © 2015年 高彬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

#define kENLARGE_HEIGHT 142.0f
#define kENLARGE_WIDTH  310.0f
#define kMAGNIFIER_MULTIPLE1 4
#define kMAGNIFIER_MULTIPLE2 2
#define kMAGNIFIER_MIN_HEIGHT kENLARGE_HEIGHT / kMAGNIFIER_MULTIPLE1
#define kMAGNIFIER_MIN_WIDTH  kENLARGE_WIDTH / kMAGNIFIER_MULTIPLE1
#define kMAGNIFIER_MAX_HEIGHT kENLARGE_HEIGHT / kMAGNIFIER_MULTIPLE2
#define kMAGNIFIER_MAX_WIDTH  kENLARGE_WIDTH / kMAGNIFIER_MULTIPLE2

@protocol KDMagnifierViewDelegate <NSObject>

- (void)magnifierView:(id)view scal:(float)scal;
- (void)magnifierView:(id)view atMove:(CGPoint)point;

@end

@interface KDMagnifierView : UIView
{
    CGPoint _startPoint;
    CGPoint _currPoint;
}

@property (nonatomic,assign) float scal;
@property (nonatomic,weak) UIButton * button;
@property (nonatomic,weak) id<KDMagnifierViewDelegate>delgate;
@end
