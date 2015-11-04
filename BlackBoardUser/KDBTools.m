//
//  KDBTools.m
//  BlackBoardUser
//
//  Created by 高彬 on 15/11/2.
//  Copyright © 2015年 高彬. All rights reserved.
//

#import "KDBTools.h"

@implementation KDBTools

- (id)init
{
    self = [super init];
    if (self) {
        
        _lineColor  = kBB_PEN_COLOR_RED;
        _lineWidth  = kBB_PEN_WIDTH_FINE;
        _dty        = ACEDrawingToolTypePen;
        _lineWidth2 = 20.0f;
    }
    return self;
}

+ (KDBTools *)shared
{
    static id _sharedObject = nil;
    
    if (_sharedObject == nil) {
        
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            _sharedObject = [KDBTools new];
        });
    }
    
    return _sharedObject;
}

@end
