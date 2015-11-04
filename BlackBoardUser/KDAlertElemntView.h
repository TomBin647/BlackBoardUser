//
//  KDAlertElemntView.h
//  BlackBoardUser
//
//  Created by 高彬 on 15/11/1.
//  Copyright © 2015年 高彬. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KDAlertElemntViewDelegate <NSObject>

-(void)alertElementView:(id)view atIndex:(NSInteger)index;

@end



@interface KDAlertElemntView : UIView

@property (nonatomic, weak) UIButton * addImgButton;
@property (nonatomic, weak) UIButton * addPicButton;
@property (nonatomic, weak) UIButton * addCameraButton;
@property (nonatomic, weak) UIButton * addPrevButton;
@property (nonatomic, weak) UIButton * addNextButton;

@property (nonatomic, weak) id<KDAlertElemntViewDelegate> delegate;

@end
