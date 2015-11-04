//
//  KDBlackBoardViewController.m
//  BlackBoardUser
//
//  Created by 高彬 on 15/11/1.
//  Copyright © 2015年 高彬. All rights reserved.
//

#import "KDBlackBoardViewController.h"


@implementation KDDemoView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataSources = @[@(1), @(2), @(3), @(4), @(5), @(6)];
        self.frame = kMainScreenFrame;
        self.backgroundColor = rgba(44, 210, 202, 1);
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        self.imageView.userInteractionEnabled = YES;
        [self addSubview:self.imageView];
        [self addSetupViewWithIndex:0];
        
        self.userInteractionEnabled = YES;
        self.imageView.userInteractionEnabled = YES;
    }
    return self;
}

- (void)addSetupViewWithIndex:(NSInteger)index
{
    NSInteger val = [[self.dataSources objectAtIndex:index] integerValue];
    NSString * imageName = __IOS7_OR_LATER ? [NSString stringWithFormat:@"b_%d.PNG", (int)val] :
    [NSString stringWithFormat:@"a_%d.PNG", (int)val];
    
    self.imageView.image = [UIImage imageNamed:imageName];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (++self.currentIndex >= self.dataSources.count) {
        [self.delegate demoViewTheEnd:self];
    } else {
        [self addSetupViewWithIndex:self.currentIndex];
    }
}


@end


@interface KDBlackBoardViewController ()<KDDemoViewDelegate> {
    NSInteger        _pageIndex;//代表当前显示的 页数
    NSMutableArray * _pageList;//所有的 页数的数组
    
    UIButton * _upButton;
    UIButton * _downButton;
    
    KDXScreenCapture  * _videoRecord;
    KDXRecordAudio    * _audioRecord;
    
    BOOL _isRecordPermission;
}

@end

@implementation KDBlackBoardViewController


//初始化
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _pageIndex = -1;
        _pageList = [NSMutableArray new];
        [[KDBTools shared] setLineColor:kBB_PEN_COLOR_RED];
        [[KDBTools shared] setLineWidth:kBB_PEN_WIDTH_FINE];
        [[KDBTools shared] setDty:ACEDrawingToolTypePen];
    }
    return self;
}

//IOS7隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!(__IOS7_OR_LATER)) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (!(__IOS7_OR_LATER)) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
    
}
- (void)demoViewTheEnd:(id)sender
{
    [sender removeFromSuperview];
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化界面
    [self initView];
    
    
    
    //加载视频录制
    [[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryRecord error:nil];
    [[AVAudioSession sharedInstance]setActive:YES error:nil];
    UInt32 audioRoute = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRoute), &audioRoute);
    
    
    self.navigationController.navigationBarHidden    = YES;
    self.scrollerView.pagingEnabled                  = YES;
    self.scrollerView.delegate                       = self;
    self.scrollerView.contentSize                    = CGSizeMake(330, kMainScreenHeight);
    self.scrollerView.backgroundColor                = rgba(239, 237, 238, 1);
    self.scrollerView.showsHorizontalScrollIndicator = NO;
    self.scrollerView.showsVerticalScrollIndicator   = NO;
    self.scrollerView.scrollEnabled                  = NO;
    
    //遮挡层
    UIView * blockView = [[UIView alloc]init];
    blockView.frame = CGRectMake(0, 320 + 44, 320, kMainScreenHeight);
    blockView.backgroundColor = [UIColor blackColor];
    blockView.alpha = 0.5f;
    [self.view addSubview:blockView];
    
    [self addNext];
    
    UIView * view = [UIView new];
    view.frame = CGRectMake(0, self.penButton.frame.size.height - 13, self.penButton.frame.size.width, 3);
    /////////////
    view.backgroundColor = [KDBTools shared].lineColor;
    view.tag = 90;
    [self.penButton addSubview:view];
    
    //对画笔 颜色 宽度 属性 进行监听
    [[KDBTools shared] addObserver:self forKeyPath:@"lineWidth" options:NSKeyValueObservingOptionNew context:nil];
    [[KDBTools shared] addObserver:self forKeyPath:@"lineColor" options:NSKeyValueObservingOptionNew context:nil];
    [[KDBTools shared] addObserver:self forKeyPath:@"dty" options:NSKeyValueObservingOptionNew context:nil];
    
    
    [KDXUtil createCacheDirectory];
    
    _audioRecord = [KDXRecordAudio new];
    _videoRecord = [KDXScreenCapture new];
    
    _videoRecord.delegate    = self;
    _videoRecord.captureView = self.recordView;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self openZoomButtonClickHander:self.zoomButton];
    });
    
    _upButton   = [[UIButton alloc] initWithFrame:CGRectMake(320 - 45, MIN(kMainScreenHeight - 188, 44 + 320) - 90, 40, 40)];
    _downButton = [[UIButton alloc] initWithFrame:CGRectMake(320 - 45, MIN(kMainScreenHeight - 188, 44 + 320) - 45, 40, 40)];
    
    [_upButton setHidden:YES];
    [_upButton setImage:[UIImage imageNamed:@"btn-upY.png"] forState:UIControlStateNormal];
    [_upButton setImage:[UIImage imageNamed:@"st-btn-upY.png"] forState:UIControlStateNormal];
    [_upButton addTarget:self action:@selector(upButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    [_downButton setHidden:YES];
    [_downButton setImage:[UIImage imageNamed:@"btn-downY.png"] forState:UIControlStateNormal];
    [_downButton setImage:[UIImage imageNamed:@"st-btn-downY.png"] forState:UIControlStateNormal];
    [_downButton addTarget:self action:@selector(downButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_upButton];
    [self.view addSubview:_downButton];
    
    [self.helperButton setImage:[UIImage imageNamed:@"help2"] forState:UIControlStateHighlighted];
    
    //判断是否打开了麦克风
    _isRecordPermission = YES;
    
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if (!granted) {
                _isRecordPermission = NO;
            }
        }];
    }
}

-(void)initView {
    
}



-(void)dealloc {
    if (self.magnifierView) {
        [self.magnifierView removeObserver:self forKeyPath:@"y"];
        [self.magnifierView removeFromSuperview];
        
        self.magnifierView = nil;
    }
    
    [[KDBTools shared] removeObserver:self forKeyPath:@"lineWidth"];
    [[KDBTools shared] removeObserver:self forKeyPath:@"lineColor"];
    [[KDBTools shared] removeObserver:self forKeyPath:@"dty"];
    [[self currPageView] removeObserver:self forKeyPath:@"contentOffset"];
}

//添加画板
-(void) addNext {
    
    [[self currPageView] removeObserver:self forKeyPath:@"contentOffset"];
    
    long index = _pageIndex + 1;
    KDBlackBoardPageView * newView = [KDBlackBoardPageView new];
    newView.drawingView.lineColor = [KDBTools shared].lineColor;
    newView.drawingView.lineWidth = [KDBTools shared].lineWidth;
    newView.drawingView.drawTool  = [KDBTools shared].dty;
    newView.drawingView.delegate = self;
    [_pageList insertObject:newView atIndex:index];
    [self.scrollerView addSubview:newView];
    
    [self sortPages];
    if (index != 0) {
        CGRect frame = self.scrollerView.frame;
        frame.origin.x = index * frame.size.width;
        [self.scrollerView scrollRectToVisible:frame animated:YES];
    }
    _pageIndex = index;
    
    
    [[self currPageView]addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    if (_enlargeView) {
        _enlargeView.inView = [self currPageView];
        CGPoint p = _enlargeView.inView.contentOffset;
        CGPoint newPoint = CGPointMake((_magnifierView.x + p.x) * _magnifierView.scal, (_magnifierView.y + p.y - 44) * _magnifierView.scal);
        _enlargeView.bgView.zoomScale = _magnifierView.scal;
        _enlargeView.bgView.contentOffset = newPoint;
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"] && [object isEqual:[self currPageView]]) {
        CGPoint p = [change[@"new"]CGPointValue];
        CGPoint newPoint = CGPointMake((_magnifierView.x + p.x) * _magnifierView.scal, (_magnifierView.y + p.y - 44) * _magnifierView.scal);
        _enlargeView.bgView.zoomScale = _magnifierView.scal;
        _enlargeView.bgView.contentOffset = newPoint;
        if (_magnifierView) {
            
            //判断是否显示  向下 或者向上的按钮
            
            if (_magnifierView.y + [self currPageView].contentOffset.y > ((kMainScreenHeight) > 480.0f ? (44 + 320 - _magnifierView.height) : (_enlargeView.y - 44))) {
                _downButton.hidden = NO;
            } else {
                _downButton.hidden = YES;
            }
            if ([self currPageView].contentOffset.y > 0) {
                _upButton.hidden = NO;
            } else {
                _upButton.hidden = YES;
            }
        }
        return;
    }
    
    if (_magnifierView && [object isEqual:_magnifierView] && [keyPath isEqualToString:@"y"]) {
        
        CGFloat y = [change[@"new"] floatValue];
        
        if (y + [self currPageView].contentOffset.y >= ((kMainScreenHeight) > 480.0f ? (44 + 320 - _magnifierView.height) : (_enlargeView.y - 44))) {
            _downButton.hidden = NO;
        } else {
            _downButton.hidden = YES;
        }
        if ([self currPageView].contentOffset.y > 0) {
            _upButton.hidden = NO;
        } else {
            _upButton.hidden = YES;
        }
        
        return;
    }
    
    if ([keyPath isEqualToString:@"lineWidth"]) {
        
        if ([KDBTools shared].dty != ACEDrawingToolTypeErase) {
            [self currPageView].drawingView.lineWidth = [KDBTools shared].lineWidth;
        }
        
        return;
    }
    
    if ([keyPath isEqualToString:@"lineColor"]) {
        
        [self currPageView].drawingView.lineColor = [KDBTools shared].lineColor;
        
        [[self.penButton viewWithTag:90] setBackgroundColor:(__bridge CGColorRef _Nullable)([KDBTools shared].lineColor)];
        
        return;
    }
    
    if ([keyPath isEqualToString:@"dty"]) {
        
        ACEDrawingToolType dty = [KDBTools shared].dty;
        
        if (dty == ACEDrawingToolTypeErase) {
            self.eraseButton.selected = YES;
            self.penButton.selected   = NO;
            
            if (_enlargeView) {
                [self currPageView].drawingState = YES;
            }
        } else {
            self.eraseButton.selected = NO;
            self.penButton.selected = YES;
            
            if (_enlargeView) {
                [self currPageView].drawingState = NO;
            }
        }
        
        if ([KDBTools shared].dty == ACEDrawingToolTypePen) {
            [self currPageView].drawingView.drawTool  = [KDBTools shared].dty;
            [self currPageView].drawingView.lineWidth = [KDBTools shared].lineWidth;
        }
        if ([KDBTools shared].dty == ACEDrawingToolTypeErase) {
            [self currPageView].drawingView.drawTool  = [KDBTools shared].dty;
            [self currPageView].drawingView.lineWidth = [KDBTools shared].lineWidth2;
        }
        return;
    }
    
    
    
}

-(void)sortPages {
    [_pageList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView * view = (UIView *)obj;
        view.frame = CGRectMake(idx * 330, 0, 330, kMainScreenHeight);
    }];
    [self.scrollerView setContentSize:CGSizeMake([_pageList count] * 330, kMainScreenHeight)];
    
}

-(void)upButtonHandler:(UIButton *) sender {
    KDBlackBoardPageView * bpv = [self currPageView];
    //设置界面上移
    if (bpv.contentOffset.y != 0) {
        [UIView animateWithDuration:0.3f animations:^{
            bpv.contentOffset = CGPointMake(0, MAX(0, bpv.contentOffset.y - 100));
        }];
        //并设置 当前的 向上 或者 向下的箭头显示
        if (_magnifierView.y + bpv.contentOffset.y > 44 + 320/2) {
            _downButton.hidden = NO;
        } else {
            _downButton.hidden = YES;
        }
        if (bpv.contentOffset.y > 0) {
            _upButton.hidden = NO;
        } else {
            _upButton.hidden = YES;
        }
    }
}
-(void)downButtonHandler:(UIButton *)sender {
    KDBlackBoardPageView * bpv = [self currPageView];
    [UIView animateWithDuration:0.3f animations:^{
        bpv.contentOffset = CGPointMake(0, MIN(bpv.contentSize.height - bpv.height, bpv.contentOffset.y + 100));
    }];
    
}
/**
 *  帮助
 */
- (IBAction)helperButtonClick:(id)sender {
    
    KDDemoView * dv = [KDDemoView new];
    
    dv.delegate = self;
    
    [self.view addSubview:dv];
}
//返回按钮的点击事件
- (IBAction)backButtonClickHander:(id)sender {
    
}
//加号按钮的点击事件
- (IBAction)addElementButtonClickHander:(UIButton *)sender {
    if ((sender.selected = !sender.selected)) {
        //恢复按钮状态
        [self restButtonDefaultStateWithExclude:sender];
        KDAlertElemntView * view = [KDAlertElemntView new];
        view.delegate = self;
        view.x = 5;
        view.y = 45;
        view.tag = kTAG_ALERTELEMENT;
        [self.view addSubview:view];
    } else {
        [self removeViewWithTag:kTAG_ALERTELEMENT];
    }
}
//弹出菜单的代理事件
-(void)alertElementView:(id)view atIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            //KDImagesViewController * ivc = [KDImagesViewController new];
            //KDNavigationViewController * nav = [[KDNavigationViewController alloc]
        //initWithRootViewController:ivc];
            //
            //ivc.roomId = self.roomId;
            //
            //[self presentViewController:nav animated:YES completion:nil];
            //
            //break;
        }
        case 1:
        case 2:
        {
            UIImagePickerController * controller = [UIImagePickerController new];
            
            if (index == 1) {
                controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            } else {
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            }
            
            controller.delegate      = self;
            
            [self presentViewController:controller animated:YES completion:nil];
            
            break;
        }
        case 3: //[self prevButtonHandler:nil];
            break;
        case 4: //[self nextButtonHandler:nil];
            break;
        default:
            break;
    }
    
    [self removeViewWithTag:kTAG_ALERTELEMENT];
}


//点击放大写字板的按钮点击事件
- (IBAction)openZoomButtonClickHander:(UIButton *)sender {
    if ((sender.selected = !sender.selected)) {
        
        //恢复按钮状态
        [self restButtonDefaultStateWithExclude:sender];
        
        KDMagnifierView * mv = [[KDMagnifierView alloc] init];
        
        mv.y = self.toolbar.height;
        mv.delgate = self;
        
        [self.view addSubview:mv];
        
        _magnifierView = mv;
        
        [_magnifierView addObserver:self forKeyPath:@"y" options:
                                NSKeyValueObservingOptionNew
                                context:nil];
        
        KDEnlargeView * tmp = [KDEnlargeView new];
        
        [tmp setInView:[self currPageView]];  //设置同步画板
        [tmp setY:self.view.height];
//        [tmp.closeButton addTarget:self action:@selector(colseButtonHandler:)
//                  forControlEvents:UIControlEventTouchUpInside];
//        [tmp.prevButton addTarget:self action:@selector(prevButtonHandler:)
//                 forControlEvents:UIControlEventTouchUpInside];
//        [tmp.nextButton addTarget:self action:@selector(nextButtonHandler:)
//                 forControlEvents:UIControlEventTouchUpInside];
        [tmp.rightMoveButton addTarget:self action:@selector(rightMoveButtonHandler:)
                      forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:tmp];
        
        CGFloat scal = tmp.bgView.zoomScale;
        CGPoint p = [self currPageView].contentOffset;
        CGPoint newPoint = CGPointMake((mv.x + p.x) * scal, (mv.y + p.y - 44) * scal);
        
        tmp.bgView.contentOffset = newPoint;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            tmp.y = self.view.height - tmp.height;
        }];
        
        self.enlargeView = tmp;
        
    } else {
        
        [self.magnifierView removeObserver:self forKeyPath:@"y"];
        [self.magnifierView removeFromSuperview];
        
        [self setMagnifierView:nil];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.enlargeView.y = self.view.height;
        } completion:^(BOOL finished) {
            
            [self.enlargeView removeFromSuperview];
            [self setEnlargeView:nil];
        }];
    }
    
    [self currPageView].drawingState = !self.zoomButton.selected;
}

-(void)rightMoveButtonHandler:(UIButton *) sender {
    id view = [self currPageView];
    if ([view editState]) {
        [self currPageView].editState = NO;
        if (_enlargeView) {
            [_enlargeView refreshBlackboardImageViews];
        }
    }
    
    if (self.magnifierView.width + self.magnifierView.x < 320.0f) {
        
        CGFloat m = self.magnifierView.width * 0.8;
        
        CGFloat x = MIN(self.magnifierView.x + m, 320.0f - self.magnifierView.width);
        
        [UIView animateWithDuration:0.3f animations:^{
            self.magnifierView.x = x;
            
            [self magnifierView:nil atMove:CGPointMake(self.magnifierView.x,
                                                       self.magnifierView.y - 44)];
        } completion:^(BOOL finished) {
            
        }];
    }
    
    
}


#pragma 拖动框代理事件
//拖动框拖动时候  下面的放大显示框 同步显示
-(void)magnifierView:(id)view atMove:(CGPoint)point {
    if ([[self currPageView]editState]) {
        [self currPageView].editState = NO;
        if (_enlargeView) {
            [_enlargeView refreshBlackboardImageViews];
        }
    }
    CGFloat scal = _enlargeView.bgView.zoomScale;
    CGPoint p = [self currPageView].contentOffset;
    CGPoint newPoint = CGPointMake((point.x + p.x) * scal, (point.y + p.y) * scal);
    
    _enlargeView.bgView.contentOffset = newPoint;
}
//拖动框放大时  下面的放大框 同步缩小
-(void)magnifierView:(id)view scal:(float)scal {
    if ([[self currPageView]editState]) {
        [self currPageView].editState = NO;
        if (_enlargeView) {
            [_enlargeView refreshBlackboardImageViews];
        }
    }
    CGPoint p = [self currPageView].contentOffset;
    CGPoint newPoint = CGPointMake((_magnifierView.x + p.x) * scal,
                                   (_magnifierView.y + p.y - 44) * scal);
    
    _enlargeView.bgView.zoomScale     = scal;
    _enlargeView.bgView.contentOffset = newPoint;
    
}
//橡皮擦的点击事件
- (IBAction)eraseButtonClickhander:(UIButton *)sender {
    
    if ((sender.selected = !sender.selected)) {
        
        //恢复按钮状态
        [self restButtonDefaultStateWithExclude:sender];
        
        [KDBTools shared].dty = ACEDrawingToolTypeErase;
        
    } else {
        
        //恢复按钮状态
        [self restButtonDefaultStateWithExclude:sender];
        
        [KDBTools shared].dty = ACEDrawingToolTypePen;
    }
    
}
//录制按钮的点击事件
- (IBAction)recordButtonClickHander:(UIButton *)sender {
    if (!_isRecordPermission) {
        showMessageBox(@"录音要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风");
        return;
    }
    [self.successButton setTitleColor:rgba(61, 214, 213, 1) forState:
     UIControlStateNormal];
    if ((sender.selected = !sender.selected)) {
        [_audioRecord start:_videoRecord.durationCounter];
        [_videoRecord start];
        [sender setImage:[UIImage imageNamed:@"btn_time3.png"] forState:
         UIControlStateNormal];
    } else {
        [_videoRecord pause];
        [_audioRecord pause];
        [sender setImage:[UIImage imageNamed:@"btn_time2.png"] forState:
         UIControlStateNormal];
    }
}

#pragma 视频录制代理
- (void)xScreenCaptureDidProgress:(float)progress
{
    runDispatchGetMainQueue(^{
        CGFloat time = 300 - (300 * progress);
        
        NSDate * date = [NSDate dateWithTimeIntervalSince1970:time];
        
        self.timeLabel.text = [[date description] substringWithRange:
                               NSMakeRange(15, 4)];
    });
    
}
- (NSString *)tempPathWithLocalId:(NSString *)localId
{
    return [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                  NSUserDomainMask, YES)
              objectAtIndex:0]
             stringByAppendingPathComponent:localId]
            stringByAppendingPathComponent:@"temp"];
}

- (void)xScreenCaptureDidFinsished:(id)sender
{
    [_audioRecord finishedRecord];
    //创建一个路径
    //如果没有路径  将创建失败
    NSString* videoName = @"export2.mp4";
    NSString *exportPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                                 NSUserDomainMask, YES)
                             objectAtIndex:0] stringByAppendingPathComponent:videoName];
    NSString * output =  exportPath;
    NSLog(@"output:%@",output);
    NSString* videoName1 = @"export2.jpg";
    NSString *exportPath1 = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                                  NSUserDomainMask, YES)
                              objectAtIndex:0] stringByAppendingPathComponent:videoName1];
    
    NSString * output2 = exportPath1;
    NSLog(@"output2:%@",output2);
    
    [KDXUtil mergerWithOutputPath:output tbumbnail:output2 sucess:^{
        
        NSLog(@"OK....");
        NSDictionary * data = @{ @"video_path" : output, @"image_path" : output2 };
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"BlackboardSuccess" object:data];
        
        runDispatchGetMainQueue(^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
        
    } failer:^(NSError *error) {
        
        NSLog(@"%@", error);
    }];
}

//完成按钮的点击事件
- (IBAction)successButtonClickHander:(id)sender {
    if (_videoRecord.isRecordFile) {
        
        [sender setEnabled:NO];
        [_videoRecord finishedRecord];
    }
    
}
//选择画笔颜色 和 画笔宽度
- (IBAction)penEditButtonClickHandler:(UIButton *)sender {
    if ([self.view viewWithTag:kTAG_ALERTCOLOR]) {
        //移除添加菜单
        if ((self.addButton.selected  = !self.addButton.selected)) {
            [self.addButton setSelected:NO];
            [self removeViewWithTag:kTAG_ALERTELEMENT];
        }
        [self removeViewWithTag:kTAG_ALERTCOLOR];
    } else {
        //恢复按钮状态
        [self restButtonDefaultStateWithExclude:sender];
        KDAlertColorView * view = [KDAlertColorView new];
        view.tag = kTAG_ALERTCOLOR;
        view.x = 55;
        view.y = 45;
        view.delegate = self;
        [self.view addSubview:view];
        
    }
}
#pragma KDAlertColorViewDelegate

- (void)alertColorView:(id)view selectColor:(UIColor *)color {
    [KDBTools shared].lineColor = color;
    [self removeViewWithTag:kTAG_ALERTCOLOR];
}
- (void)alertColorView:(id)view selectWidth:(CGFloat)width{
    [KDBTools shared].lineWidth = width;
    [self removeViewWithTag:kTAG_ALERTCOLOR];
}


#pragma mark -- 工具栏按钮点击事件

- (void)restButtonDefaultStateWithExclude:(id)button
{
    //设置当前页为非编辑状态
    if ([self currPageView].editState) {
        [self currPageView].editState = NO;
        [self removeViewWithTag:kTAG_ALERTEDIT];
    }
    //设置当前橡皮擦处于非按下状态
    if (self.eraseButton.selected && ![self.eraseButton isEqual:button]) {
        [self.eraseButton setSelected:NO];
        [KDBTools shared].dty = ACEDrawingToolTypePen;
    }
    //移除添加菜单
    if (self.addButton.selected && ![self.addButton isEqual:button]) {
        [self.addButton setSelected:NO];
        [self removeViewWithTag:kTAG_ALERTELEMENT];
    }
    //移除颜色菜单
    if (self.penButton.selected && ![self.penButton isEqual:button]) {
        
        [self removeViewWithTag:kTAG_ALERTCOLOR];
    }
    
    if (self.penButton.selected && self.eraseButton.selected) {
        [self.penButton setSelected:NO];
    } else {
        [self.penButton setSelected:YES];
    }
    
}

#pragma 拍照功能的代理
-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage * image1 = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage * image2 = [self getAssetThumbImage:image1];
    
    KDBlackBoardPageView * view = [self currPageView];
    [view addPictrueWithImage:image2];
    [view setEditState:YES];
    [view setEditState:NO];
    if (_enlargeView) {
        [_enlargeView refreshBlackboardImageViews];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    //根据图片位置  放置拖动框的位置
    if ([[view.pictureView subviews] count] == 1) {
        if (image2.size.width >= image2.size.height) {
            self.magnifierView.x = 0;
            self.magnifierView.y = (image2.size.height/2) + 44;
        } else {
            self.magnifierView.x = (image2.size.width/2);
            self.magnifierView.y = 44;
        }
        [self magnifierView:nil atMove:CGPointMake(self.magnifierView.x, self.magnifierView.y - 44)];
    }
    
    
}
//处理照片
-(UIImage *)getAssetThumbImage:(UIImage *)image {
    @autoreleasepool {
        CGSize osize = image.size;
        CGFloat nw = 0.0f;
        CGFloat nh = 0.0f;
        if (osize.width > osize.height) {
            nw = 640 * 0.75;
            nh = osize.height * (nw /osize.width);
        } else {
            nh = 640 * 0.75;
            nw = osize.width * (nh/osize.height);
        }
        
        UIGraphicsBeginImageContext(CGSizeMake(nw, nh));
        [image drawInRect:CGRectMake(0, 0, nw, nh)];
        UIImage * newImage =UIGraphicsGetImageFromCurrentImageContext();
        image = nil;
        return newImage;
    }
}
#pragma mark --

- (void)removeViewWithTag:(NSInteger)tag
{
    id view = [self.view viewWithTag:tag];
    
    if (view) {
        [view removeFromSuperview];
        [self.addButton setSelected:NO];
        ObjectRelease(view);
    }
}

- (KDBlackBoardPageView *)currPageView
{
    if ([_pageList count] == 0) {
        return nil;
    }
    return [_pageList objectAtIndex:_pageIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
