//
//  KDBlackBoardPageView.h
//  BlackBoardUser
//  //画图视图
//  Created by 高彬 on 15/11/2.
//  Copyright © 2015年 高彬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "ACEDrawingView.h"
#import "KDBTools.h"
#import "KDEditImageView.h"


@interface KDBlackBoardPageView : UIScrollView <UIScrollViewDelegate, UIGestureRecognizerDelegate>
{
    KDEditImageView * _currIV;
}

@property (nonatomic, strong, readonly) UIView         * mainView;
@property (nonatomic, strong, readonly) ACEDrawingView * drawingView;
@property (nonatomic, strong, readonly) UIView         * pictureView;



@property (nonatomic, assign) BOOL zoomState;
@property (nonatomic, assign) BOOL editState;//是否可画图
@property (nonatomic, assign) BOOL drawingState;//编写状态


-(void)addPictrueWithImage:(UIImage *)image;

- (void)addPictrueWithNetworkAddress:(NSString *)address size:(CGSize)size;
- (void)removeSelectImage;

- (BOOL)findPictrueWithPoint:(CGPoint)p;


@end
