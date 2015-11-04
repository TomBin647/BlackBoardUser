//
//  XRecordAudio.h
//  KDFuDao
//
//  Created by bing.hao on 14-6-11.
//  Copyright (c) 2014年 bing.hao. All rights reserved.
//

#import "Common.h"
@interface KDXRecordAudio : NSObject
{
    AVAudioRecorder * _record;
    
    NSString * _cacheAudioPath;
}

- (void)start:(NSTimeInterval)timeInterval;
- (void)pause;
- (void)finishedRecord;

@end
