//
//  KDBlackBoardViewController.h
//  BlackBoardUser
//
//  Created by 高彬 on 15/11/1.
//  Copyright © 2015年 高彬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDAlertElemntView.h"
#import "KDBlackBoardPageView.h"
#import "KDMagnifierView.h"
#import "KDEnlargeView.h"
#import "KDAlertColorView.h"
#import "KDXUtil.h"
#import "KDXScreenCapture.h"
#import "KDXRecordAudio.h"

#define kTAG_ALERTELEMENT 9001
#define kTAG_ALERTCOLOR   9002
#define kTAG_ALERTRECORD  9003
#define kTAG_ALERTEDIT    9004


@protocol KDDemoViewDelegate <NSObject>

- (void)demoViewTheEnd:(id)sender;

@end

@interface KDDemoView : UIView

@property (nonatomic, weak) id<KDDemoViewDelegate> delegate;

@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) NSArray * dataSources;
@property (nonatomic, assign) NSInteger currentIndex;

@end


@interface KDBlackBoardViewController : UIViewController <UIScrollViewDelegate,KDAlertElemntViewDelegate,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    ACEDrawingViewDelegate,
    KDMagnifierViewDelegate,
    KDAlertColorViewDelegate,
    XScreenCaptureDelegate>


@property (nonatomic, weak) KDEnlargeView   * enlargeView;
@property (nonatomic, weak) KDMagnifierView * magnifierView;

@property (nonatomic,strong) IBOutlet UIButton * addButton;
@property (nonatomic,strong) IBOutlet UILabel  * timeLabel;
@property (nonatomic,strong) IBOutlet UIButton * recordButton;
@property (nonatomic,strong) IBOutlet UIButton * eraseButton;
@property (nonatomic,strong) IBOutlet UIButton * penButton;
@property (nonatomic,strong) IBOutlet UIButton * zoomButton;
@property (nonatomic,strong) IBOutlet UIButton * successButton;
@property (nonatomic,strong) IBOutlet UIScrollView * scrollerView;
@property (nonatomic,strong) IBOutlet UIView * toolbar;
@property (nonatomic,strong) IBOutlet UIView * recordView;
@property (nonatomic,strong) IBOutlet UIButton * helperButton;

- (IBAction)helperButtonClick:(id)sender;


@end

