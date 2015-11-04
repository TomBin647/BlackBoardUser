//
//  UIScrollView+Refresh.h
//  Test
//
//  Created by bing.hao on 14-2-13.
//  Copyright (c) 2014年 bing.hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

enum {
    HeaderRefreshStateHidden = 1,
	HeaderRefreshStateVisible,
    HeaderRefreshStateTriggered,
    HeaderRefreshStateLoading
};

typedef NSUInteger HeaderRefreshState;

@interface HeaderRefreshView : UIView

@property (nonatomic, strong) UILabel                 * titleLabel;
@property (nonatomic, strong) UIImageView             * arrowImageView;
@property (nonatomic, strong) UIActivityIndicatorView * activityIndicatorView;
@property (nonatomic, strong) UILabel                 * dateLabel;
@property (nonatomic, strong) NSDateFormatter         * dateFormatter;
@property (nonatomic, assign) HeaderRefreshState        state;
@property (nonatomic, assign) UIEdgeInsets              originalScrollViewContentInset;
@property (nonatomic, weak)   UIScrollView            * scrollView;

- (id)initWithScrollView:(UIScrollView *)scrollView;

@end

@protocol HeaderRefreshDelegate <NSObject>

- (void)headerRefreshDidChangeState:(HeaderRefreshState)state;

@end

@interface UIScrollView (HeaderRefresh)

@property (nonatomic, strong) HeaderRefreshView * headerRefreshView;
@property (nonatomic, weak) id<HeaderRefreshDelegate> headerRefreshDelegate;

- (void)installHeaderRefreshWithDelegate:(id<HeaderRefreshDelegate>)delegate;
- (void)uninstallHeaderRefres;

@end
