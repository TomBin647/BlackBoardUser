//
//  KDAlertElemntView.m
//  BlackBoardUser
//
//  Created by 高彬 on 15/11/1.
//  Copyright © 2015年 高彬. All rights reserved.
//

#import "KDAlertElemntView.h"
#import "Common.h"

@implementation KDAlertElemntView

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
        self.frame = CGRectMake(0, 0, 134, 236-90);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 6.0f;
        
        UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_Add"]];
        
        [self addSubview:imageView];
        
        UIButton * button0 = [[UIButton alloc] initWithFrame:CGRectMake(12, 15, 100, 40)];
        
        [button0 setImage:[UIImage imageNamed:@"btn_fpho.png"] forState:UIControlStateNormal];
        [button0 setImage:[UIImage imageNamed:@"st_btn_fpho.png"] forState:UIControlStateHighlighted];
        [button0 setTitle:@"辅导图片" forState:UIControlStateNormal];
        [button0 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button0 setTitleColor:rgba(44, 209, 202, 1) forState:UIControlStateHighlighted];
        [button0.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [button0 setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [button0 addTarget:self action:@selector(buttonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button0];
        
        
        UIButton * button1 = [[UIButton alloc] initWithFrame:CGRectMake(12, 56, 100, 40)];
        
        [button1 setImage:[UIImage imageNamed:@"btn_-Add-photos"] forState:UIControlStateNormal];
        [button1 setImage:[UIImage imageNamed:@"st_btn_-Add-photos"] forState:UIControlStateHighlighted];
        [button1 setTitle:@"添加照片" forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button1 setTitleColor:rgba(44, 209, 202, 1) forState:UIControlStateHighlighted];
        [button1.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [button1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [button1 addTarget:self action:@selector(buttonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button1];
        
        UIButton * button2 = [[UIButton alloc] initWithFrame:CGRectMake(12, 100, 100, 40)];
        
        [button2 setImage:[UIImage imageNamed:@"btn_camera"] forState:UIControlStateNormal];
        [button2 setImage:[UIImage imageNamed:@"st_btn_camera"] forState:UIControlStateHighlighted];
        [button2 setTitle:@"相机拍摄" forState:UIControlStateNormal];
        [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button2 setTitleColor:rgba(44, 209, 202, 1) forState:UIControlStateHighlighted];
        [button2.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [button2 setTitleEdgeInsets:UIEdgeInsetsMake(5, 5, 0, 0)];
        [button2 addTarget:self action:@selector(buttonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button2];
        
        
        self.addImgButton    = button0;
        self.addPicButton    = button1;
        self.addCameraButton = button2;
        
    }
    return self;

}

-(void)buttonClickHandler:(id)sender {
    NSInteger index = -1;
    if ([sender isEqual:self.addImgButton]) {
        index = 0;
    }
    if ([sender isEqual:self.addPicButton]) {
        index = 1;
    }
    
    if ([self isEqual:self.addCameraButton]) {
        index = 2;
    }
    if ([self isEqual:self.addPrevButton]) {
        index = 3;
    }
    if ([self isEqual:self.addNextButton]) {
        index = 4;
    }
    
    [self.delegate alertElementView:self atIndex:index];
}


@end
