//
//  KDEnlargeView.m
//  BlackBoardUser
//
//  Created by 高彬 on 15/11/2.
//  Copyright © 2015年 高彬. All rights reserved.
//

#import "KDEnlargeView.h"

@implementation KDEnlargeView

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
        self.frame = CGRectMake(0, 0, 320, 188);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 1;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 3;
        
        [self addColorButtonWithTag:700 point:CGPointMake(10, 0) bgColor:kBB_PEN_COLOR_RED nImage:@"icon-Cpen1.png" hImage:@"st-icon-Cpen1.png"];
        [self addColorButtonWithTag:701 point:CGPointMake(47, 0) bgColor:kBB_PEN_COLOR_BLUE nImage:@"icon-Cpen2.png" hImage:@"st-icon-Cpen2.png"];
        [self addColorButtonWithTag:702 point:CGPointMake(84, 0) bgColor:kBB_PEN_COLOR_BLACK nImage:@"icon-Cpen3.png" hImage:@"st-icon-Cpen3.png"];
        
        UIButton * button1 = [[UIButton alloc] initWithFrame:CGRectMake(121, 0, 30, 40)];
        
        [button1 setImage:[UIImage imageNamed:@"btn_Rubber.png"] forState:UIControlStateNormal];
        [button1 setImage:[UIImage imageNamed:@"st_btn_Rubber.png"] forState:UIControlStateHighlighted];
        [button1 setImage:[UIImage imageNamed:@"st_btn_Rubber.png"] forState:UIControlStateSelected];
        [button1 addTarget:self action:@selector(rubberButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button1];
        
        UIButton * button5 = [[UIButton alloc] initWithFrame:CGRectMake(280, 0, 40, 40)];
        
        [button5 setImage:[UIImage imageNamed:@"icon-right.png"] forState:UIControlStateNormal];
        [button5 setImage:[UIImage imageNamed:@"icon-right.png"] forState:UIControlStateHighlighted];
        
        [self addSubview:button5];
        
        self.eraseButton = button1;
        self.rightMoveButton = button5;
        
        [[KDBTools shared] addObserver:self forKeyPath:@"lineColor" options:NSKeyValueObservingOptionNew context:nil];
        [[KDBTools shared] addObserver:self forKeyPath:@"lineWidth" options:NSKeyValueObservingOptionNew context:nil];
        [[KDBTools shared] addObserver:self forKeyPath:@"dty" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return self;
}

-(void)dealloc {
    [[KDBTools shared]removeObserver:self forKeyPath:@"lineColor"];
    [[KDBTools shared]removeObserver:self forKeyPath:@"lineWidth"];
    [[KDBTools shared]removeObserver:self forKeyPath:@"dty"];
}

//同步画板
-(void)setInView:(KDBlackBoardPageView *)syncPageView {
    //被同步的画板
    _inView = syncPageView;
    if (self.bgView) {
        [self.bgView removeFromSuperview];
        [self setBgView:nil];
    }
    
    KDBlackBoardPageView * tmp = [KDBlackBoardPageView new];
    tmp.layer.borderColor = rgba(188, 186, 186, 1).CGColor;
    tmp.layer.borderWidth = 1;
    tmp.layer.masksToBounds = YES;
    tmp.x = 5;
    tmp.y = 41;
    tmp.width = 310;
    tmp.height = 142;
    tmp.scrollEnabled = NO;
    tmp.drawingView.lineWidth = [KDBTools shared].lineWidth;
    tmp.drawingView.lineColor = [KDBTools shared].lineColor;
    tmp.zoomState             = YES;
    tmp.zoomScale             = 4.0f;
    tmp.contentOffset         = CGPointZero;
    tmp.drawingView.delegate  = self;
    tmp.pinchGestureRecognizer.enabled = NO;
    tmp.panGestureRecognizer.enabled = NO;
    
    [self addSubview:tmp];
    [self setBgView:tmp];

}
- (void)drawingView:(ACEDrawingView *)view willBeginDrawUsingTool:(id<ACEDrawingTool>)tool
{
    if ([self.inView editState]) {
        //        [view setEditState:NO];
        [self inView].editState    = NO;
        [self refreshBlackboardImageViews];
    }
}

- (void)drawingView:(ACEDrawingView *)view didEndDrawUsingTool:(id<ACEDrawingTool>)tool
{
    id paths = [self.bgView.drawingView valueForKey:@"pathArray"];
    
    [self.inView.drawingView setValue:paths forKey:@"pathArray"];
    [self.inView.drawingView updateLastPathChacheImage];
    [self.inView.drawingView setNeedsDisplay];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"lineWidth"]) {
        //判断如果不是橡皮
        if ([KDBTools shared].dty != ACEDrawingToolTypeErase) {
            [self bgView].drawingView.lineWidth = [KDBTools shared].lineWidth;
        }
    }
    
    if ([keyPath isEqualToString:@"lineColor"]) {
        [self bgView].drawingView.lineColor = [KDBTools shared].lineColor;
        
        for (int i = 700; i<703; i++) {
            UIButton * button = (UIButton *)[self viewWithTag:i];
            button.selected = NO;
        }
        
        UIButton * button = nil;
        
        if ([[KDBTools shared].lineColor isEqual:kBB_PEN_COLOR_RED]) {
            button = (UIButton *)[self viewWithTag:700];
        } else if ([[KDBTools shared].lineColor isEqual:kBB_PEN_COLOR_BLUE]) {
            button = (UIButton *)[self viewWithTag:701];
        } else if ([[KDBTools shared].lineColor isEqual:kBB_PEN_COLOR_BLACK]) {
            button = (UIButton *)[self viewWithTag:702];
        }
        
        if (button) {
            button.selected = YES;
        }
    }
    
    if ([keyPath isEqualToString:@"dty"]) {
        ACEDrawingToolType dty = [KDBTools shared].dty;
        if (dty == ACEDrawingToolTypeErase) {
            self.eraseButton.selected = YES;
            for (int i = 700; i < 703; i++) {
                UIButton * button = (UIButton *)[self viewWithTag:i];
                button.selected = NO;
            }
        } else {
            self.eraseButton.selected = NO;
            
            UIButton * button = nil;
            
            if ([[KDBTools shared].lineColor isEqual:kBB_PEN_COLOR_RED]) {
                button = (UIButton *)[self viewWithTag:700];
            } else if ([[KDBTools shared].lineColor isEqual:kBB_PEN_COLOR_BLUE]) {
                button = (UIButton *)[self viewWithTag:701];
            } else if ([[KDBTools shared].lineColor isEqual:kBB_PEN_COLOR_BLACK]) {
                button = (UIButton *)[self viewWithTag:702];
            }
            
            if (button) {
                button.selected = YES;
            }

        }
        
        if ([KDBTools shared].dty == ACEDrawingToolTypePen) {
            [self bgView].drawingView.drawTool  = [KDBTools shared].dty;
            [self bgView].drawingView.lineWidth = [KDBTools shared].lineWidth;
        }
        if ([KDBTools shared].dty == ACEDrawingToolTypeErase) {
            [self bgView].drawingView.drawTool  = [KDBTools shared].dty;
            [self bgView].drawingView.lineWidth = [KDBTools shared].lineWidth2;
        }

        
    }
}

//刷新背景图片
- (void)refreshBlackboardImageViews
{
    NSArray * tmp = self.bgView.pictureView.subviews;
    
    for (int i = 0; i < [tmp count]; i++) {
        
        [[tmp objectAtIndex:i] removeFromSuperview];
    }
    
    ObjectRelease(tmp);
    
    id pics = _inView.pictureView.subviews;
    
    if ([pics count] > 0) {
        
        for (UIImageView * imageView in pics) {
            
            NSData      * data    = [NSKeyedArchiver archivedDataWithRootObject:imageView];
            UIImageView * newView = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            
            [_bgView.pictureView addSubview:newView];
        }
    }
}

- (void)addColorButtonWithTag:(NSInteger)tag point:(CGPoint)p bgColor:(UIColor *)color nImage:(NSString *)nImage hImage:(NSString *)hImage
{
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(p.x, p.y, 30, 40)];
    
    [button setTag:tag];
    [button setImage:[UIImage imageNamed:nImage] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:hImage] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:hImage] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(colorButtonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([color isEqual:[KDBTools shared].lineColor]) {
        
        [button setSelected:YES];
    }
    
    [self addSubview:button];
}

//选择画笔的颜色
-(void)colorButtonClickHandler:(UIButton *) sender {
    if ([self.inView editState]) {
        [self inView].editState = NO;
        [self refreshBlackboardImageViews];
    }
    UIColor * selectColor;
    switch ([sender tag]) {
        case 700:
            selectColor = kBB_PEN_COLOR_RED;
            break;
        case 701:
            selectColor = kBB_PEN_COLOR_BLUE;
            break;
        case 702:
            selectColor = kBB_PEN_COLOR_BLACK;
            break;
        default:
            break;
    }
    
    [KDBTools shared].lineColor = selectColor;
    if (self.eraseButton.selected) {
        self.eraseButton.selected = NO;
        [KDBTools shared].dty = ACEDrawingToolTypePen;
    } else {
        for (int i = 700; i< 703; i++) {
            UIButton * button = (UIButton *)[self viewWithTag:i];
            button.selected = NO;
        }
    }
    [sender setSelected:YES];
}
//点击了橡皮的button
- (void)rubberButtonHandler:(UIButton *)sender
{
    if ((sender.selected = !sender.selected)) {
        [KDBTools shared].dty = ACEDrawingToolTypeErase;
    } else {
        [KDBTools shared].dty = ACEDrawingToolTypePen;
    }
    
    if (sender.selected) {
        for (int i = 700; i < 703; i++) {
            UIButton * button = (UIButton *)[self viewWithTag:i];
            button.selected = NO;
        }
    } else {
        UIButton * button = nil;
        if ([[KDBTools shared].lineColor isEqual:kBB_PEN_COLOR_RED]) {
            button = (UIButton *)[self viewWithTag:700];
        } else if ([[KDBTools shared].lineColor isEqual:kBB_PEN_COLOR_BLUE]) {
            button = (UIButton *)[self viewWithTag:701];
        } else if ([[KDBTools shared].lineColor isEqual:kBB_PEN_COLOR_BLACK]) {
            button = (UIButton *)[self viewWithTag:702];
        }
        if (button) {
            button.selected = YES;
        }
    }
    if ([self.inView editState]) {
        [self inView].editState = NO;
        [self refreshBlackboardImageViews];
    }
}


@end
