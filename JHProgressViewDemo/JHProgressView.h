//
//  JHProgressView.h
//  TTTest
//
//  Created by xingjiehai on 16/8/16.
//  Copyright © 2016年 xingjiehai. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface JHProgressView : UIView

@property (nonatomic) IBInspectable CGFloat barWidth;
@property (nonatomic) IBInspectable CGFloat margin;
@property (nonatomic) IBInspectable UIColor *progressColor;
@property (nonatomic) IBInspectable UIColor *trackColor;
@property (nonatomic) IBInspectable CGFloat startAngle;

@property (nonatomic, readonly) IBInspectable CGFloat progress;
@property (nonatomic, readonly) BOOL isAnimating;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated duration:(CGFloat)duration;

- (void)stopAnimation;
@end
