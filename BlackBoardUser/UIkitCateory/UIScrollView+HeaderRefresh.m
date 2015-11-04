//
//  UIScrollView+Refresh.m
//  Test
//
//  Created by bing.hao on 14-2-13.
//  Copyright (c) 2014年 bing.hao. All rights reserved.
//

#import "UIScrollView+HeaderRefresh.h"

@implementation HeaderRefreshView

- (id)initWithScrollView:(UIScrollView *)scrollView
{
    self = [super init];
    if (self) {
        
        self.activityIndicatorView = [[UIActivityIndicatorView alloc] init];
        self.arrowImageView        = [[UIImageView alloc] initWithFrame:CGRectMake(20, 6, 22, 48)];
        self.titleLabel            = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 20)];

        self.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        
        self.arrowImageView.image           = [self arrowImage];
        self.arrowImageView.backgroundColor = [UIColor clearColor];
        
        
//        self.titleLabel.text            = @"Pull to refresh...";
        self.titleLabel.text            = @"下拉刷新...";
        self.titleLabel.font            = [UIFont boldSystemFontOfSize:14];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor       = [UIColor darkGrayColor];
        self.titleLabel.textAlignment   = NSTextAlignmentCenter;
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.activityIndicatorView];
        [self addSubview:self.arrowImageView];
        
        self.activityIndicatorView.center = self.arrowImageView.center;
        
        _state = HeaderRefreshStateHidden;
        
        self.scrollView = scrollView;
        self.originalScrollViewContentInset = self.scrollView.contentInset;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

- (void)layoutSubviews
{
//    CGFloat remainingWidth = self.superview.bounds.size.width-200;
//    float position = 0.50;
//    
//    CGRect titleFrame = self.titleLabel.frame;
//    titleFrame.origin.x = ceil(remainingWidth*position+44);
//    self.titleLabel.frame = titleFrame;
//    
//    CGRect dateFrame = self.dateLabel.frame;
//    dateFrame.origin.x = titleFrame.origin.x;
//    self.dateLabel.frame = dateFrame;
//    
//    CGRect arrowFrame = self.arrowImageView.frame;
//    arrowFrame.origin.x = ceil(remainingWidth*position);
//    self.arrowImageView.frame = arrowFrame;
//    
//    self.activityIndicatorView.center = self.arrowImageView.center;
}

- (UIImage *)arrowImage {
    CGRect rect = CGRectMake(0, 0, 22, 48);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor clearColor] set];
    
    CGContextFillRect(context, rect);
    
    [[UIColor grayColor] set];
    
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextClipToMask(context, rect, [[UIImage imageNamed:@"HeaderRefresh.bundle/arrow"] CGImage]);
    CGContextFillRect(context, rect);
    
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return output;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"] && _state != HeaderRefreshStateLoading) {
        
        CGPoint currPoint = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
        
//        NSLog(@"%@", NSStringFromCGPoint(currPoint));
//        NSLog(@"%@", object);
        [self scrollViewDidScroll:currPoint];
    }
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset {
    
    CGFloat scrollOffsetThreshold = self.frame.origin.y-self.originalScrollViewContentInset.top;

    if(!self.scrollView.isDragging && self.state == HeaderRefreshStateTriggered)
        self.state = HeaderRefreshStateLoading;
    else if(contentOffset.y > scrollOffsetThreshold && contentOffset.y < -self.originalScrollViewContentInset.top && self.scrollView.isDragging && self.state != HeaderRefreshStateLoading)
        self.state = HeaderRefreshStateVisible;
    else if(contentOffset.y < scrollOffsetThreshold && self.scrollView.isDragging && self.state == HeaderRefreshStateVisible)
        self.state = HeaderRefreshStateTriggered;
    else if(contentOffset.y >= -self.originalScrollViewContentInset.top && self.state != HeaderRefreshStateHidden)
        self.state = HeaderRefreshStateHidden;
}

- (void)setState:(HeaderRefreshState)state
{
    _state = state;
//    NSLog(@"%d", _state);
    
    switch (state) {
        case HeaderRefreshStateHidden:
//            self.titleLabel.text = NSLocalizedString(@"Pull to refresh...",);
            self.titleLabel.text = NSLocalizedString(@"下拉刷新...",);
            [self.activityIndicatorView stopAnimating];
            [self setScrollViewContentInset:self.originalScrollViewContentInset];
            [self rotateArrow:0 hide:NO];
            break;
            
        case HeaderRefreshStateVisible:
//            self.titleLabel.text = NSLocalizedString(@"Pull to refresh...",);
            self.titleLabel.text = NSLocalizedString(@"下拉刷新...",);
            self.arrowImageView.alpha = 1;
            [self.activityIndicatorView stopAnimating];
            [self setScrollViewContentInset:self.originalScrollViewContentInset];
            [self rotateArrow:0 hide:NO];
            break;
            
        case HeaderRefreshStateTriggered:
//            self.titleLabel.text = NSLocalizedString(@"Release to refresh...",);
            self.titleLabel.text = NSLocalizedString(@"松开刷新...",);
            [self rotateArrow:M_PI hide:NO];
            break;
            
        case HeaderRefreshStateLoading:
//            self.titleLabel.text = NSLocalizedString(@"Loading...",);
            self.titleLabel.text = NSLocalizedString(@"加载中...",);
            [self.arrowImageView setAlpha:0];
            [self.activityIndicatorView startAnimating];
            
            UIEdgeInsets ei = self.scrollView.contentInset;
            
            ei.top = self.frame.origin.y*-1+self.originalScrollViewContentInset.top;
            
            [self setScrollViewContentInset:ei];
            [self rotateArrow:0 hide:YES];
//            if(actionHandler)
//                actionHandler();
            
            if ([self.scrollView.headerRefreshDelegate respondsToSelector:@selector(headerRefreshDidChangeState:)]) {
                [self.scrollView.headerRefreshDelegate headerRefreshDidChangeState:self.state];
            }
            
            break;
    }
}

- (void)rotateArrow:(float)degrees hide:(BOOL)hide {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.arrowImageView.layer.transform = CATransform3DMakeRotation(degrees, 0, 0, 1);
        self.arrowImageView.layer.opacity = !hide;
    } completion:NULL];
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.scrollView.contentInset = contentInset;
    } completion:^(BOOL finished) {
        if(self.state == HeaderRefreshStateHidden && contentInset.top == self.originalScrollViewContentInset.top)
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                self.arrowImageView.alpha = 0;
            } completion:NULL];
    }];
}

//- (void)dataLoadFinished {
//    
//    self.state = HeaderRefreshStateHidden;
//}


@end

static void * MyKey1 = (void *)@"HeaderRefreshView";
static void * MyKey2 = (void *)@"HeaderRefreshDelegate";

@implementation UIScrollView (HeaderRefresh)

@dynamic headerRefreshView;
@dynamic headerRefreshDelegate;

- (void)installHeaderRefreshWithDelegate:(id<HeaderRefreshDelegate>)delegate
{
    if ([self viewWithTag:3766]) {
        return;
    }
    
    id headerView = [[HeaderRefreshView alloc] initWithScrollView:self];
    
    [headerView setTag:3766];
    [headerView setFrame:CGRectMake(0, -60, self.frame.size.width, 60)];
    
    [self addSubview:headerView];
    
    self.headerRefreshView     = headerView;
    self.headerRefreshDelegate = delegate;
    
//    self.headerRefreshView = [HeaderRefreshView new];
    
    [self addObserver:self.headerRefreshView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)uninstallHeaderRefres
{
    if ([self viewWithTag:3766]) {
        
        [self removeObserver:self.headerRefreshView forKeyPath:@"contentOffset"];
        [self.headerRefreshView removeFromSuperview];
        
        self.headerRefreshView.scrollView = nil;
        self.headerRefreshView            = nil;
        self.headerRefreshDelegate        = nil;
    }
}

- (void)setHeaderRefreshDelegate:(id<HeaderRefreshDelegate>)headerRefreshDelegate
{
    objc_setAssociatedObject(self, MyKey2, headerRefreshDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id<HeaderRefreshDelegate>)headerRefreshDelegate
{
    return objc_getAssociatedObject(self, MyKey2);
}

- (void)setHeaderRefreshView:(HeaderRefreshView *)headerRefreshView
{
    objc_setAssociatedObject(self, MyKey1, headerRefreshView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HeaderRefreshView *)headerRefreshView
{
    return objc_getAssociatedObject(self, MyKey1);
}





@end
