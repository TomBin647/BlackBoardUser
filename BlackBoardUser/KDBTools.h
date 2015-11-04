//
//  KDBTools.h
//  BlackBoardUser
//
//  Created by 高彬 on 15/11/2.
//  Copyright © 2015年 高彬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACEDrawingView.h"
#import "Common.h"


#define kBB_CHANGE_LINE_WIDTH        @"kBB_CHANGE_LINE_WIDTH"
#define kBB_CHANGE_LINE_COLOR        @"kBB_CHANGE_LINE_COLOR"
#define kBB_CHANGE_DRAWING_TOOL_TYPE @"kBB_CHANGE_DRAWING_TOOL_TYPE"


#define kBB_PEN_COLOR_RED        rgba(252, 68, 30, 1)
#define kBB_PEN_COLOR_BLUE       rgba(22, 127, 251, 1)
#define kBB_PEN_COLOR_BLACK      rgba(49, 49, 49, 1)
#define kBB_PEN_COLOR_GREEN      rgba(34, 146, 23, 1)
#define kBB_PEN_COLOR_LIGHTBLUE  rgba(42, 239, 253, 1)
#define kBB_PEN_COLOR_LIGHTGREEN rgba(120, 253, 75, 1)
#define kBB_PEN_COLOR_PINK       rgba(252, 40, 252, 1)
#define kBB_PEN_COLOR_YELLOW     rgba(255, 253, 57, 1)

#define kBB_PEN_WIDTH_FINE  1
#define kBB_PEN_WIDTH_THICK 3

@interface KDBTools : NSObject

@property (nonatomic, assign) CGFloat   lineWidth;
@property (nonatomic, assign) CGFloat   lineWidth2;
@property (nonatomic, strong) UIColor * lineColor;
@property (nonatomic, assign) ACEDrawingToolType dty;


+ (KDBTools *)shared;

@end

