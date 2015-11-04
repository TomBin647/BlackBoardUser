//
//  KDEnlargeView.h
//  BlackBoardUser
//
//  Created by 高彬 on 15/11/2.
//  Copyright © 2015年 高彬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDBTools.h"
#import "KDBlackBoardPageView.h"
#import "KDMagnifierView.h"

@interface KDEnlargeView : UIView<ACEDrawingViewDelegate>



@property (nonatomic, weak) KDBlackBoardPageView * inView; //要同步的画板
@property (nonatomic, weak) KDBlackBoardPageView * bgView; //被放大的画板
@property (nonatomic, weak) KDMagnifierView * mView;
@property (nonatomic, weak) UIButton * eraseButton;      //橡皮擦按钮
@property (nonatomic, weak) UIButton * closeButton;      //关闭按钮
@property (nonatomic, weak) UIButton * prevButton;
@property (nonatomic, weak) UIButton * nextButton;
@property (nonatomic, weak) UIButton * rightMoveButton;


- (void)refreshBlackboardImageViews;

@end
