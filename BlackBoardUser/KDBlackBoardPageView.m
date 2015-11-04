//
//  KDBlackBoardPageView.m
//  BlackBoardUser
//
//  Created by 高彬 on 15/11/2.
//  Copyright © 2015年 高彬. All rights reserved.
//

#import "KDBlackBoardPageView.h"

@implementation KDBlackBoardPageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)init {
    self = [super init];
    if (self) {
        CGFloat height = 0;
        if (__IOS7_OR_LATER) {
            height = (kMainScreenHeight - 320) + 320 * 2;
        } else {
            height = (kMainScreenHeight -44) * 2 +16;
        }
        
        self.frame = CGRectMake(0, 0, 320, kMainScreenHeight -44);
        self.multipleTouchEnabled = NO;
        self.pagingEnabled = NO;
        self.maximumZoomScale = 1.0f;
        self.minimumZoomScale = 1.0f;
        self.zoomScale  = 1.0f;
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.contentSize = CGSizeMake(320, height);
        self.clipsToBounds = YES;
        self.pinchGestureRecognizer.delegate = self;
        
        
        //背景层
        UIImageView * backgroundImageView = [[UIImageView alloc]init];
        backgroundImageView.image = [UIImage imageNamed:@"bpv_bg.png"];
        backgroundImageView.frame = CGRectMake(0, 0, 320, 1280);
        backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        //图片层
        _pictureView = [UIView new];
        self.pictureView.frame = CGRectMake(0, 0, 320, height);
        self.pictureView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        
        _drawingView = [[ACEDrawingView alloc]initWithFrame:CGRectMake(0, 0, 320, 320 * 2)];
        self.drawingView.lineAlpha = 1.0f;
        self.drawingView.lineColor = [KDBTools shared].lineColor;
        self.drawingView.lineWidth = [KDBTools shared].lineWidth;
        self.drawingView.drawTool  = [KDBTools shared].dty;
        
        _mainView = [UIView new];
        _mainView.frame = CGRectMake(0, 0, 320, height);
        [self.mainView addSubview:backgroundImageView];
        [self.mainView addSubview:self.pictureView];
        [self.mainView addSubview:self.drawingView];
        [self addSubview:self.mainView];
        
        [self setScrollViewPanFingersNumber:2];
        
    }
    return self;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
        return NO;
    }
    return YES;
}

- (void)setScrollViewPanFingersNumber:(NSInteger)num
{
    for (UIGestureRecognizer * entry in self.gestureRecognizers) {
        
        if ([entry isKindOfClass:[UIPanGestureRecognizer class]]) {
            UIPanGestureRecognizer *panGR = (UIPanGestureRecognizer *)entry;
            panGR.minimumNumberOfTouches = num;
        }
    }
}
#pragma 添加照片
-(void)addPictrueWithImage:(UIImage *)image {
    KDEditImageView * imageView = [[KDEditImageView alloc]initWithImage:image];
    imageView.x = -20;
    imageView.y = -20;
    _currIV = imageView;
}
//添加网络图片
- (void)addPictrueWithNetworkAddress:(NSString *)address size:(CGSize)size
{
    KDEditImageView * imageView = [[KDEditImageView alloc] initWithImageUrl:address size:size];
    imageView.x = -20;
    imageView.y = -20;
    //    imageView.center = CGPointMake(160, imageView.height / 2 + 20);
    _currIV          = imageView;
}
- (void)removeSelectImage{
    
}

- (BOOL)findPictrueWithPoint:(CGPoint)p {
    return YES;
}


-(void)setEditState:(BOOL)editState {
    if ((_editState = editState)) {
        if (_currIV && _currIV.superview) {
            [_currIV removeFromSuperview];
        }
        //屏蔽画图功能
        self.drawingView.userInteractionEnabled = NO;
        //启动图片的编辑功能
        _currIV.edit = YES;
        [self addSubview:_currIV];
    } else {
        [_currIV removeFromSuperview];
        [_currIV setEdit:NO];
        [self.pictureView addSubview:_currIV];
        if (self.drawingState) {
            [self.drawingView setUserInteractionEnabled:YES];
        }
        
        ObjectRelease(_currIV);
    }
}


-(void)setDrawingState:(BOOL)drawingState {
    _drawingState = drawingState;
    self.drawingView.userInteractionEnabled = _drawingState;
}

-(void)setZoomState:(BOOL)zoomState {
    if ((_zoomState = zoomState)) {
        self.multipleTouchEnabled = YES;
        self.maximumZoomScale = 4.0f;
        self.minimumZoomScale = 2.0f;
    } else {
        self.multipleTouchEnabled = NO;
        self.maximumZoomScale = 1.0f;
        self.minimumZoomScale = 1.0f;
    }
}

#pragma mark -UIScrollViewDelegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.mainView;
}






@end
