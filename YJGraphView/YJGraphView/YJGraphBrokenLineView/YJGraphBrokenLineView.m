//
//  YJGraphBrokenLineView.m
//  YJGraphView
//
//  Created by Yang on 2018/12/5.
//  Copyright © 2018 YangJing. All rights reserved.
//

#import "YJGraphBrokenLineView.h"

@implementation YJGraphBrokenLineView {
    NSArray <NSString *> *_xAxisItems;
    BOOL _xAxisAutoFitWidth;
    
    CGFloat _yAxisMaxItemVaule;
    CGFloat _yAxisMinItemVaule;
    NSInteger _yAxisItemsCount;
    
    UIScrollView *_xAxisView;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBStrokeColor(context, 255, 255, 255, 1);
    CGContextSetLineWidth(context, 1);
    
    CGContextMoveToPoint(context, 60, 30);
    CGContextAddLineToPoint(context, 60, CGRectGetHeight(self.bounds)-60);
    
    CGContextStrokePath(context);
}

//绘制横轴刻度尺
- (void)setXAxisItems:(NSArray <NSString *> *)xAxisItems autoFitWidth:(BOOL)autoFitWidth {
    _xAxisItems = xAxisItems;
    _xAxisAutoFitWidth = autoFitWidth;
    
    CGFloat viewHeight = CGRectGetHeight(self.bounds);
    CGFloat viewWidth = CGRectGetWidth(self.bounds);
    
    _xAxisView = ({
        UIScrollView *view = [[UIScrollView alloc] init];
        view.backgroundColor = self.backgroundColor;
        view.showsHorizontalScrollIndicator = NO;
        view.bounces = NO;
        view;
    });
    [self addSubview:_xAxisView];
    _xAxisView.frame = CGRectMake(61, 30, viewWidth-60*2, viewHeight-30);
    
    CGFloat xAxisItemWidth;
    
    if (!autoFitWidth) {
        _xAxisView.contentSize = CGSizeMake(30*xAxisItems.count, 0);
        xAxisItemWidth = 30;
        
    } else {
        _xAxisView.contentSize = CGSizeMake(viewWidth-60*2, 0);
        xAxisItemWidth = (viewWidth-60*2)/xAxisItems.count;
        
    }
    
    CGFloat contentHeight = CGRectGetHeight(_xAxisView.bounds)-60;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, contentHeight)];
    [path addLineToPoint:CGPointMake(_xAxisView.contentSize.width, contentHeight)];
    
    CAShapeLayer *lineLayer = [[CAShapeLayer alloc] init];
    lineLayer.lineWidth = 1;
    lineLayer.strokeColor = [UIColor whiteColor].CGColor;
    lineLayer.path = path.CGPath;
    [_xAxisView.layer addSublayer:lineLayer];
    
    for (NSInteger i = 0, count = xAxisItems.count; i<count; i++) {
        
        CGFloat xAxisItemPositionX = xAxisItemWidth*i;
        
        if (i > 0) {
            UIBezierPath *subPath = [UIBezierPath bezierPath];
            [subPath moveToPoint:CGPointMake(xAxisItemPositionX, contentHeight)];
            [subPath addLineToPoint:CGPointMake(xAxisItemPositionX, contentHeight-3)];
            
            CAShapeLayer *subLineLayer = [[CAShapeLayer alloc] init];
            subLineLayer.lineWidth = 1;
            subLineLayer.strokeColor = [UIColor whiteColor].CGColor;
            subLineLayer.path = subPath.CGPath;
            [_xAxisView.layer addSublayer:subLineLayer];
        }
        
        UILabel *xAxisItemLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:10];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentRight;
            label.text = xAxisItems[i];
            label;
        });
        [_xAxisView addSubview:xAxisItemLabel];
        
        CGFloat textWidth = [xAxisItems[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, [UIFont systemFontOfSize:10].lineHeight) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size.width;
        
        xAxisItemLabel.frame = CGRectMake(xAxisItemPositionX, contentHeight+textWidth/2, textWidth, [UIFont systemFontOfSize:10].lineHeight);
        
        xAxisItemLabel.transform = CGAffineTransformMakeRotation(M_PI/4.0);
    }
}

- (void)setYAxisMaxItem:(CGFloat)maxItem minItem:(CGFloat)minItem itemCount:(NSInteger)itemCount {
    _yAxisMaxItemVaule = maxItem;
    _yAxisMinItemVaule = minItem;
    _yAxisItemsCount = itemCount;
    
    if (minItem < 0) {
        NSLog(@"yangjing_%@: minItem < 0", NSStringFromClass([self class]));
        return;
    }
    
    CGFloat contentHeight = CGRectGetHeight(_xAxisView.bounds)-60;
    CGFloat yAxisItemHeight = contentHeight/(itemCount+1);

    for (NSInteger i = 0; i < itemCount; i++) {
        CGFloat yAxisItemPositionY = contentHeight - yAxisItemHeight*(i+1);
        
        UIBezierPath *subPath = [UIBezierPath bezierPath];
        [subPath moveToPoint:CGPointMake(60, yAxisItemPositionY+30)];
        [subPath addLineToPoint:CGPointMake(57, yAxisItemPositionY+30)];
        
        CAShapeLayer *subLineLayer = [[CAShapeLayer alloc] init];
        subLineLayer.lineWidth = 1;
        subLineLayer.strokeColor = [UIColor whiteColor].CGColor;
        subLineLayer.path = subPath.CGPath;
        [self.layer addSublayer:subLineLayer];

        CGFloat yAxisItem = (maxItem-minItem)/(itemCount-1)*i+minItem;
        
        UILabel *yAxisItemLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:10];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentRight;
            label.text = [NSString stringWithFormat:@"%.2f", yAxisItem];
            label;
        });
        [self addSubview:yAxisItemLabel];
        
        yAxisItemLabel.frame = CGRectMake(0, yAxisItemPositionY+30-[UIFont systemFontOfSize:10].lineHeight/2, 55, [UIFont systemFontOfSize:10].lineHeight);
        
        UIBezierPath *subPath2 = [UIBezierPath bezierPath];
        [subPath2 moveToPoint:CGPointMake(0, yAxisItemPositionY)];
        [subPath2 addLineToPoint:CGPointMake(_xAxisView.contentSize.width, yAxisItemPositionY)];
        
        CAShapeLayer *subLineLayer2 = [[CAShapeLayer alloc] init];
        subLineLayer2.lineWidth = 0.5;
        subLineLayer2.strokeColor = [UIColor whiteColor].CGColor;
        subLineLayer2.path = subPath2.CGPath;
        [subLineLayer2 setLineDashPattern:@[[NSNumber numberWithInteger:5]]];
        [_xAxisView.layer addSublayer:subLineLayer2];
    }
}

- (void)setDataArray:(NSArray<NSNumber *> *)dataArray lineColor:(UIColor *)lineColor {
    _dataArray = dataArray;
    
    CGFloat viewHeight = CGRectGetHeight(self.bounds);
    CGFloat viewWidth = CGRectGetWidth(self.bounds);
    CGFloat yAxisItemHeight = (viewHeight-60*2)/(_yAxisItemsCount+1);
    CGFloat yAxisItemOffset = (_yAxisMaxItemVaule-_yAxisMinItemVaule)/(_yAxisItemsCount-1);

    CGFloat xAxisItemWidth;
    if (!_xAxisAutoFitWidth) {
        xAxisItemWidth = 30;
        
    } else {
        xAxisItemWidth = (viewWidth-60*2)/_xAxisItems.count;
        
    }
    CGFloat contentHeight = CGRectGetHeight(_xAxisView.bounds)-60;

    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.lineWidth = 0.5;
    shapeLayer.strokeColor = lineColor.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPath];

    for (NSInteger i = 0, count = dataArray.count; i<count; i++) {
        CGFloat itemPositionX = xAxisItemWidth*i;
        
        CGFloat item = [dataArray[i] floatValue];
        CGFloat itemPositionY;
        if (item < _yAxisMinItemVaule) {
            itemPositionY = contentHeight - yAxisItemHeight*(item/_yAxisMinItemVaule);
            
        } else if (item > _yAxisMaxItemVaule) {
            itemPositionY = 30 - 30*((item-_yAxisMaxItemVaule)/yAxisItemOffset);

        } else {
            itemPositionY = contentHeight - (yAxisItemHeight + item/_yAxisMaxItemVaule*(contentHeight-30-yAxisItemHeight));
        }
        
        if (i == 0) {
            [path moveToPoint:CGPointMake(itemPositionX, itemPositionY)];
            
        } else {
            [path addLineToPoint:CGPointMake(itemPositionX, itemPositionY)];
        }
        
        UIView *pointView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = lineColor;
            view.layer.cornerRadius = 1.5;
            view;
        });
        [_xAxisView addSubview:pointView];
        pointView.frame = CGRectMake(0, 0, 3, 3);
        pointView.center = CGPointMake(itemPositionX, itemPositionY);
        
        UILabel *itemLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:6];
            label.textAlignment = NSTextAlignmentRight;
            label.text = [NSString stringWithFormat:@"%.2f", item];
            label;
        });
        [_xAxisView addSubview:itemLabel];
        itemLabel.frame = CGRectMake(0, 0, xAxisItemWidth, [UIFont systemFontOfSize:6].lineHeight);
        
        if (i == 0) {
            itemLabel.center = CGPointMake(itemPositionX+xAxisItemWidth/2, itemPositionY+[UIFont systemFontOfSize:6].lineHeight);
        } else {
            itemLabel.center = CGPointMake(itemPositionX, itemPositionY+[UIFont systemFontOfSize:6].lineHeight);

        }
    }
    
    shapeLayer.path = path.CGPath;
    [_xAxisView.layer addSublayer:shapeLayer];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 3;
    pathAnimation.repeatCount = 1;
    pathAnimation.removedOnCompletion = YES;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [shapeLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
}

@end
