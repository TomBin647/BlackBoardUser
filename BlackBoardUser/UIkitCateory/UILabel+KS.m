//
//  UILabel+KS.m
//  KSToolkit
//
//  Created by bing.hao on 14/12/5.
//  Copyright (c) 2014年 bing.hao. All rights reserved.
//

#import "UILabel+KS.h"

@implementation UILabel (KS)

- (void)adjustFrameWithArea:(CGSize)areaSize
{
    CGSize size = CGSizeZero;

    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f) {
        
        CGRect bound = [self.text boundingRectWithSize:areaSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : self.font } context:nil];
        size = bound.size;
    } else {
//        size = [self.text sizeWithFont:self.font constrainedToSize:areaSize lineBreakMode:NSLineBreakByCharWrapping];
        
        
        CGRect bound= [self.text boundingRectWithSize:areaSize
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{ NSFontAttributeName : self.font }
                                                 context:nil];
        size = bound.size;
        
    }
    
    CGRect frame = self.frame;
    
    frame.size.width  = size.width;
    frame.size.height = size.height;
    
    self.frame = frame;
    self.numberOfLines = 0;
    
//    [self sizeToFit];
}

@end
