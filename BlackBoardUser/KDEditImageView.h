//
//  KDEditImageView.h
//  BlackBoardUser
//
//  Created by 高彬 on 15/11/3.
//  Copyright © 2015年 高彬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KDEditImageView : UIView


@property (nonatomic,strong) UIImageView * imageView;

@property (nonatomic,assign) BOOL edit;

-(id)initWithImage:(UIImage *)image;

- (id)initWithImageUrl:(NSString *)url size:(CGSize)size;

@end
