//
//  KDMagnifierView.m
//  BlackBoardUser
//
//  Created by 高彬 on 15/11/2.
//  Copyright © 2015年 高彬. All rights reserved.
//

#import "KDMagnifierView.h"

@implementation KDMagnifierView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id) init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kMAGNIFIER_MIN_WIDTH, kMAGNIFIER_MIN_HEIGHT);
        self.layer.borderColor = rgba(70, 208, 201, 1).CGColor;
        self.layer.borderWidth = 2;
        self.layer.masksToBounds = YES;
        
        UIButton * button = [[UIButton alloc]init];
        [button setFrame:CGRectMake(self.width - 20, self.height -20, 20, 20)];
        [button setImage:[UIImage imageNamed:@"btn_Drag"] forState:UIControlStateNormal];
        [button setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin];
        
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panHandler:)];
        [button addGestureRecognizer:pan];
        [self addSubview:button];
        
        self.button = button;
        self.scal = (kENLARGE_WIDTH + kENLARGE_HEIGHT) / (self.width + self.height);
    }
    return  self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch * touche = [touches anyObject];
    _startPoint = [touche locationInView:self];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch * touche = [touches anyObject];
    _currPoint = [touche locationInView:self.superview];
    CGPoint p = CGPointMake(_currPoint.x - _startPoint.x, _currPoint.y - _startPoint.y);
    
    self.x = MIN(320 - self.width, MAX(0, p.x));
    self.y = MIN(320 + 44 - self.height, MAX(44, p.y));
    [self.delgate magnifierView:self atMove:CGPointMake(self.x, self.y-44)];
}

- (void)panHandler:(UIPanGestureRecognizer *)recognizer
{
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
        {
            CGPoint p = [recognizer locationInView:self.superview];
            
            self.width  = MIN(MAX(p.x - self.x, kMAGNIFIER_MIN_WIDTH), kMAGNIFIER_MAX_WIDTH);
            self.height = MIN(MAX(p.y - self.y, kMAGNIFIER_MIN_HEIGHT), kMAGNIFIER_MAX_HEIGHT);
            self.scal   = (kENLARGE_WIDTH + kENLARGE_HEIGHT) / (self.width + self.height);
            
            [self.delgate magnifierView:self scal:self.scal];
            
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            break;
        }
        default:
            break;
    }
    
}


@end
