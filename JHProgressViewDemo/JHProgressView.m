//
//  JHProgressView.m
//  TTTest
//
//  Created by xingjiehai on 16/8/16.
//  Copyright © 2016年 xingjiehai. All rights reserved.
//

#import "JHProgressView.h"

// Common
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

#define DefaultProgressBarProgressColor [UIColor colorWithRed:0.71 green:0.099 blue:0.099 alpha:0.7]
#define DefaultProgressBarTrackColor [UIColor lightGrayColor]

const CGFloat AnimationChangeTimeDuration = 0.2f;
const CGFloat AnimationChangeTimeStep = 0.01f;
const CGFloat DefaultProgressBarWidth = 5.0f;
const CGFloat DefaultMargin = 0.0f;

@interface JHProgressView ()

- (UIColor*)progressBarProgressColorForDrawing;
- (UIColor*)progressBarTrackColorForDrawing;
- (CGFloat)progressBarWidthForDrawing;
- (CGFloat)progressBarMarginForDrawing;
@end

@implementation JHProgressView{
    NSTimer *_animationTimer;
    CGFloat _currentAnimationProgress;
    CGFloat _startProgress;
    CGFloat _endProgress;
    CGFloat _animationProgressStep;
}


#pragma mark - public methods

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    [self setProgress:progress animated:animated duration:AnimationChangeTimeDuration];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated duration:(CGFloat)duration; {
    progress = [self progressAccordingToBounds:progress];
    if (_progress == progress) {
        return;
    }
    
    [_animationTimer invalidate];
    _animationTimer = nil;
    
    if (animated) {
        [self animateProgressBarChangeFrom:_progress to:progress duration:duration];
    } else {
        _progress = progress;
        [self setNeedsDisplay];
    }
}

- (void)stopAnimation {
    if (!self.isAnimating) {
        return;
    }
    
    [_animationTimer invalidate];
    _animationTimer = nil;
    _progress = _endProgress;
    [self setNeedsDisplay];
}


#pragma mark - life cycle

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGPoint innerCenter = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    CGFloat radius = MIN(innerCenter.x-self.progressBarMarginForDrawing, innerCenter.y-self.progressBarMarginForDrawing);
    CGFloat currentProgressAngle = (_progress * 360) + _startAngle;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    
    [self drawBackground:context];
    
    [self drawProgressBar:context progressAngle:currentProgressAngle center:innerCenter radius:radius];
    CGPoint pos = [self getCurrentPointAtAngle:currentProgressAngle inRect:rect radius:radius-[self progressBarWidthForDrawing]/2.0];
    [self drawPointAt:pos];
}


#pragma mark - private methods

- (void)drawBackground:(CGContextRef)context {
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextFillRect(context, self.bounds);
}


- (void)drawProgressBar:(CGContextRef)context progressAngle:(CGFloat)progressAngle center:(CGPoint)center radius:(CGFloat)radius {
    CGFloat barWidth = self.progressBarWidthForDrawing;
    if (barWidth > radius) {
        barWidth = radius;
    }
    
//    CGContextSetFillColorWithColor(context, self.progressBarProgressColorForDrawing.CGColor);
//    CGContextBeginPath(context);
//    CGContextAddArc(context, center.x, center.y, radius, DEGREES_TO_RADIANS(_startAngle), DEGREES_TO_RADIANS(progressAngle), 0);
//    CGContextAddArc(context, center.x, center.y, radius - barWidth, DEGREES_TO_RADIANS(progressAngle), DEGREES_TO_RADIANS(_startAngle), 1);
//    CGContextClosePath(context);
//    CGContextFillPath(context);
//    
//    CGContextSetFillColorWithColor(context, self.progressBarTrackColorForDrawing.CGColor);
//    CGContextBeginPath(context);
//    CGContextAddArc(context, center.x, center.y, radius, DEGREES_TO_RADIANS(progressAngle), DEGREES_TO_RADIANS(_startAngle + 360), 0);
//    CGContextAddArc(context, center.x, center.y, radius - barWidth, DEGREES_TO_RADIANS(_startAngle + 360), DEGREES_TO_RADIANS(progressAngle), 1);
//    CGContextClosePath(context);
//    CGContextFillPath(context);
    
    
    UIBezierPath *circle = [UIBezierPath bezierPath];
    [circle addArcWithCenter:center
                      radius:radius-barWidth/2.0
                  startAngle:0
                    endAngle:2 * M_PI
                   clockwise:YES];
    circle.lineWidth = barWidth;
    [self.progressBarTrackColorForDrawing setStroke];
    [circle stroke];
    circle = nil;
    
    
    UIBezierPath *progress = [UIBezierPath bezierPath];
    [progress addArcWithCenter:center
                        radius:radius-barWidth/2.0
                    startAngle:DEGREES_TO_RADIANS(_startAngle)
                      endAngle:DEGREES_TO_RADIANS(progressAngle)
                     clockwise:YES];
    progress.lineWidth = barWidth;
    //    [[UIColor redColor] setStroke];
    [self.progressBarProgressColorForDrawing set];
    [progress stroke];
    progress = nil;
}


- (CGPoint)getCurrentPointAtAngle:(CGFloat)angle inRect:(CGRect)rect radius:(CGFloat)radius{
    //三角函数
    CGFloat y = sin(DEGREES_TO_RADIANS(angle)) * radius;
    CGFloat x = cos(DEGREES_TO_RADIANS(angle)) * radius;
    
    CGPoint pos = CGPointMake(rect.size.width / 2, rect.size.height / 2);
    pos.x += x;
    pos.y += y;
    return pos;
}

- (void)drawPointAt:(CGPoint)point {
    
    UIBezierPath *dot = [UIBezierPath bezierPath];
    [dot addArcWithCenter:CGPointMake(point.x, point.y)
                   radius:8
               startAngle:0
                 endAngle:2 * M_PI
                clockwise:YES];
    dot.lineWidth = 1;
    [self.progressBarProgressColorForDrawing setFill];
    [dot fill];
    dot = nil;
    
}

- (void)drawPointAt:(CGPoint)point context:(CGContextRef)context{
    
    CGContextSetFillColorWithColor(context, self.progressBarProgressColorForDrawing.CGColor);
    CGContextBeginPath(context);
    CGContextAddArc(context, point.x, point.y, 8, DEGREES_TO_RADIANS(0), DEGREES_TO_RADIANS(360), 0);
    CGContextFillPath(context);
    
}


- (UIColor*)progressBarProgressColorForDrawing {
    return (_progressColor != nil ? _progressColor : DefaultProgressBarProgressColor);
}

- (UIColor*)progressBarTrackColorForDrawing {
    return (_trackColor != nil ? _trackColor : DefaultProgressBarTrackColor);
}

- (CGFloat)progressBarWidthForDrawing {
    return (_barWidth > 0 ? _barWidth : DefaultProgressBarWidth);
}

- (CGFloat)progressBarMarginForDrawing{
    return (_margin > 0 ? _margin : DefaultMargin);
}

//
- (CGFloat)progressAccordingToBounds:(CGFloat)progress {
    progress = MIN(progress, 1);
    progress = MAX(progress, 0);
    return progress;
}

//
- (void)animateProgressBarChangeFrom:(CGFloat)startProgress to:(CGFloat)endProgress duration:(CGFloat)duration {
    _currentAnimationProgress = _startProgress = startProgress;
    _endProgress = endProgress;
    
    _animationProgressStep = (_endProgress - _startProgress) * AnimationChangeTimeStep / duration;
    
    _animationTimer = [NSTimer scheduledTimerWithTimeInterval:AnimationChangeTimeStep target:self selector:@selector(updateProgressBarForAnimation) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_animationTimer forMode:NSRunLoopCommonModes];
}

//
- (void)updateProgressBarForAnimation {
    _currentAnimationProgress += _animationProgressStep;
    _progress = _currentAnimationProgress;
    if ((_animationProgressStep > 0 && _currentAnimationProgress >= _endProgress) || (_animationProgressStep < 0 && _currentAnimationProgress <= _endProgress)) {
        [_animationTimer invalidate];
        _animationTimer = nil;
        _progress = _endProgress;
    }
    [self setNeedsDisplay];
}


#pragma mark - getter

- (BOOL)isAnimating {
    return _animationTimer != nil;
}


@end
