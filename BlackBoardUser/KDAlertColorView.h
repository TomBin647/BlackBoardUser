//
//  KDAlertColorView.h
//  BlackBoardUser
//
//  Created by 高彬 on 15/11/3.
//  Copyright © 2015年 高彬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "KDBTools.h"

@protocol KDAlertColorViewDelegate <NSObject>

- (void)alertColorView:(id)view selectColor:(UIColor *)color;
- (void)alertColorView:(id)view selectWidth:(CGFloat)width;

@end


@interface KDAlertColorView : UIView

@property (nonatomic, weak) id<KDAlertColorViewDelegate> delegate;

@end
