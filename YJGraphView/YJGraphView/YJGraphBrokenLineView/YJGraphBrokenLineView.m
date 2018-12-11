//
//  YJGraphBrokenLineView.m
//  YJGraphView
//
//  Created by Yang on 2018/12/5.
//  Copyright © 2018 YangJing. All rights reserved.
//

#import "YJGraphBrokenLineView.h"

@implementation YJGraphBrokenLineView {
    NSArray <NSString *> *_xAxisItems;  //横轴坐标项
    BOOL _xAxisAutoFitWidth;            //横轴坐标单位长度是否根据横轴坐标项数量适应；
    
    CGFloat _yAxisMaxItemVaule;         //纵轴坐标项最大值
    CGFloat _yAxisMinItemVaule;         //纵轴坐标项最小值
    NSInteger _yAxisItemsCount;         //纵轴坐标项等分数
    
    UIScrollView *_xAxisView;           //滚动视图，实现横轴滚动效果
    
    UIColor *_themeColor;               //主题颜色
}

- (void)drawRect:(CGRect)rect {
    
    //画一条竖线作为纵轴；（如果不需要横轴滚动，这里就可以把横纵轴一起画了，需要滚动则得把横纵放在scrollView上）
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (_themeType == YJGraphThemeTypeLight) {
        CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);

    } else if (_themeType == YJGraphThemeTypeDark) {
        CGContextSetRGBStrokeColor(context, 255, 255, 255, 1);

    } else {
        CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);

    }
    CGContextSetLineWidth(context, 1);
    CGContextMoveToPoint(context, 60, 30);
    CGContextAddLineToPoint(context, 60, CGRectGetHeight(self.bounds)-60);
    CGContextStrokePath(context);
}

//设置主题色
- (void)setThemeType:(YJGraphThemeType)themeType {
    _themeType = themeType;
    
    if (_themeType == YJGraphThemeTypeLight) {
        _themeColor = [UIColor blackColor];
        
    } else if (_themeType == YJGraphThemeTypeDark) {
        _themeColor = [UIColor whiteColor];

    } else {
        _themeColor = [UIColor blackColor];

    }
}

//绘制横轴坐标
- (void)setXAxisItems:(NSArray <NSString *> *)xAxisItems autoFitWidth:(BOOL)autoFitWidth {
    _xAxisItems = xAxisItems;
    _xAxisAutoFitWidth = autoFitWidth;
    
    CGFloat viewHeight = CGRectGetHeight(self.bounds);
    CGFloat viewWidth = CGRectGetWidth(self.bounds);
    
    //设置滚动视图
    _xAxisView = ({
        UIScrollView *view = [[UIScrollView alloc] init];
        view.backgroundColor = self.backgroundColor;
        view.showsHorizontalScrollIndicator = NO;
        view.bounces = NO;
        view;
    });
    [self addSubview:_xAxisView];
    _xAxisView.frame = CGRectMake(61, 30, viewWidth-60*2, viewHeight-30);
    
    //横轴单位长度
    CGFloat xAxisItemWidth;
    if (!autoFitWidth) {
        _xAxisView.contentSize = CGSizeMake(30*xAxisItems.count, 0);
        xAxisItemWidth = 30;
        
    } else {
        _xAxisView.contentSize = CGSizeMake(viewWidth-60*2, 0);
        xAxisItemWidth = (viewWidth-60*2)/xAxisItems.count;
        
    }
    
    //在滚动视图上画一条横线作为统计图横轴
    CGFloat contentHeight = CGRectGetHeight(_xAxisView.bounds)-60;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, contentHeight)];
    [path addLineToPoint:CGPointMake(_xAxisView.contentSize.width, contentHeight)];
    
    //设置横轴坐标
    for (NSInteger i = 0, count = xAxisItems.count; i<count; i++) {
        
        CGFloat xAxisItemPositionX = xAxisItemWidth*i;
        
        //画刻度线（横轴从0开始，0位置不需要刻度）
        if (i > 0) {
            [path moveToPoint:CGPointMake(xAxisItemPositionX, contentHeight)];
            [path addLineToPoint:CGPointMake(xAxisItemPositionX, contentHeight-3)];
        }
        
        UILabel *xAxisItemLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:10];
            label.textColor = _themeColor;
            label.textAlignment = NSTextAlignmentRight;
            label.text = xAxisItems[i];
            label;
        });
        [_xAxisView addSubview:xAxisItemLabel];
        
        CGFloat textWidth = [xAxisItems[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, [UIFont systemFontOfSize:10].lineHeight) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size.width;
        
        xAxisItemLabel.frame = CGRectMake(xAxisItemPositionX, contentHeight+textWidth/2, textWidth, [UIFont systemFontOfSize:10].lineHeight);
        
        //防止横轴标识显示不下，这里旋转45度
        xAxisItemLabel.transform = CGAffineTransformMakeRotation(M_PI/4.0);
    }
    
    CAShapeLayer *lineLayer = [[CAShapeLayer alloc] init];
    lineLayer.lineWidth = 1;
    lineLayer.strokeColor = _themeColor.CGColor;
    lineLayer.path = path.CGPath;
    [_xAxisView.layer addSublayer:lineLayer];
}

//设置纵轴坐标
- (void)setYAxisMaxItem:(CGFloat)maxItem minItem:(CGFloat)minItem itemCount:(NSInteger)itemCount {
    _yAxisMaxItemVaule = maxItem;
    _yAxisMinItemVaule = minItem;
    _yAxisItemsCount = itemCount;
    
    //暂时不支持负数（可以按需求变动）
    if (minItem < 0) {
        NSLog(@"yangjing_%@: minItem < 0", NSStringFromClass([self class]));
        return;
    }
    
    CGFloat contentHeight = CGRectGetHeight(_xAxisView.bounds)-60;

    //按从0开始（如：0，100，200，300），从1开始（如：0，1000，1100，1200）区分处理
    if (minItem == 0) {
        //纵轴单位高度, 从0开始
        CGFloat yAxisItemHeight = (contentHeight-30)/(itemCount-1);
        
        for (NSInteger i = 0; i < itemCount; i++) {
            //纵轴刻度位置
            CGFloat yAxisItemPositionY = contentHeight - yAxisItemHeight*i;
            
            //从0开始，0不需要画刻度线和水平虚线
            if (i > 0) {
                //画纵轴刻度
                UIBezierPath *subPath = [UIBezierPath bezierPath];
                [subPath moveToPoint:CGPointMake(60, yAxisItemPositionY+30)];
                [subPath addLineToPoint:CGPointMake(57, yAxisItemPositionY+30)];
                
                CAShapeLayer *subLineLayer = [[CAShapeLayer alloc] init];
                subLineLayer.lineWidth = 1;
                subLineLayer.strokeColor = _themeColor.CGColor;
                subLineLayer.path = subPath.CGPath;
                [self.layer addSublayer:subLineLayer];
                
                //以每个刻度为起点画画一条平行于横轴的虚线
                UIBezierPath *subPath2 = [UIBezierPath bezierPath];
                [subPath2 moveToPoint:CGPointMake(0, yAxisItemPositionY)];
                [subPath2 addLineToPoint:CGPointMake(_xAxisView.contentSize.width, yAxisItemPositionY)];
                
                CAShapeLayer *subLineLayer2 = [[CAShapeLayer alloc] init];
                subLineLayer2.lineWidth = 0.5;
                subLineLayer2.strokeColor = _themeColor.CGColor;
                subLineLayer2.path = subPath2.CGPath;
                [subLineLayer2 setLineDashPattern:@[[NSNumber numberWithInteger:5]]];
                [_xAxisView.layer addSublayer:subLineLayer2];
            }
            
            CGFloat yAxisItem = maxItem/(itemCount-1)*i;
            
            UILabel *yAxisItemLabel = ({
                UILabel *label = [[UILabel alloc] init];
                label.font = [UIFont systemFontOfSize:10];
                label.textColor = _themeColor;
                label.textAlignment = NSTextAlignmentRight;
                label.text = [NSString stringWithFormat:@"%.2f", yAxisItem];
                label;
            });
            [self addSubview:yAxisItemLabel];
            
            yAxisItemLabel.frame = CGRectMake(0, yAxisItemPositionY+30-[UIFont systemFontOfSize:10].lineHeight/2, 55, [UIFont systemFontOfSize:10].lineHeight);
            
        }
    } else {
        
        //纵轴单位高度, 从1开始
        CGFloat yAxisItemHeight = contentHeight/(itemCount+1);
        
        for (NSInteger i = 0; i < itemCount; i++) {
            //纵轴刻度位置
            CGFloat yAxisItemPositionY = contentHeight - yAxisItemHeight*(i+1);
            
            //画纵轴刻度
            UIBezierPath *subPath = [UIBezierPath bezierPath];
            [subPath moveToPoint:CGPointMake(60, yAxisItemPositionY+30)];
            [subPath addLineToPoint:CGPointMake(57, yAxisItemPositionY+30)];
            
            CAShapeLayer *subLineLayer = [[CAShapeLayer alloc] init];
            subLineLayer.lineWidth = 1;
            subLineLayer.strokeColor = _themeColor.CGColor;
            subLineLayer.path = subPath.CGPath;
            [self.layer addSublayer:subLineLayer];
            
            CGFloat yAxisItem = (maxItem-minItem)/(itemCount-1)*i+minItem;
            
            UILabel *yAxisItemLabel = ({
                UILabel *label = [[UILabel alloc] init];
                label.font = [UIFont systemFontOfSize:10];
                label.textColor = _themeColor;
                label.textAlignment = NSTextAlignmentRight;
                label.text = [NSString stringWithFormat:@"%.2f", yAxisItem];
                label;
            });
            [self addSubview:yAxisItemLabel];
            
            yAxisItemLabel.frame = CGRectMake(0, yAxisItemPositionY+30-[UIFont systemFontOfSize:10].lineHeight/2, 55, [UIFont systemFontOfSize:10].lineHeight);
            
            //以每个刻度为起点画画一条平行于横轴的虚线
            UIBezierPath *subPath2 = [UIBezierPath bezierPath];
            [subPath2 moveToPoint:CGPointMake(0, yAxisItemPositionY)];
            [subPath2 addLineToPoint:CGPointMake(_xAxisView.contentSize.width, yAxisItemPositionY)];
            
            CAShapeLayer *subLineLayer2 = [[CAShapeLayer alloc] init];
            subLineLayer2.lineWidth = 0.5;
            subLineLayer2.strokeColor = _themeColor.CGColor;
            subLineLayer2.path = subPath2.CGPath;
            [subLineLayer2 setLineDashPattern:@[[NSNumber numberWithInteger:5]]];
            [_xAxisView.layer addSublayer:subLineLayer2];
        }
    }
   
}

/* 画折线图 */
- (void)setDataArray:(NSArray<NSNumber *> *)dataArray lineColor:(UIColor *)lineColor {
    
    CGFloat viewHeight = CGRectGetHeight(self.bounds);
    CGFloat viewWidth = CGRectGetWidth(self.bounds);

    CGFloat xAxisItemWidth;
    if (!_xAxisAutoFitWidth) {
        xAxisItemWidth = 30;
        
    } else {
        xAxisItemWidth = (viewWidth-60*2)/_xAxisItems.count;
        
    }
    CGFloat contentHeight = CGRectGetHeight(_xAxisView.bounds)-60;

    //设置折线属性
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.lineWidth = 0.5;
    shapeLayer.strokeColor = lineColor.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    if (_yAxisMinItemVaule == 0) {
        CGFloat yAxisItemOffset = _yAxisMaxItemVaule/(_yAxisItemsCount-1);
        
        for (NSInteger i = 0, count = dataArray.count; i<count; i++) {
            //计算数据点的坐标
            CGFloat itemPositionX = xAxisItemWidth*i;
            
            CGFloat item = [dataArray[i] floatValue];
            CGFloat itemPositionY;
            if (item > _yAxisMaxItemVaule) {
                itemPositionY = 30 - 30*((item-_yAxisMaxItemVaule)/yAxisItemOffset);
                
            } else {
                itemPositionY = contentHeight - (item/_yAxisMaxItemVaule*(contentHeight-30));
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
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = _themeColor;
                label.text = [NSString stringWithFormat:@"%.2f", item];
                label;
            });
            [_xAxisView addSubview:itemLabel];
            itemLabel.frame = CGRectMake(0, 0, xAxisItemWidth, [UIFont systemFontOfSize:6].lineHeight);
            
            //第一个数据显示的位置往右偏，防止超出坐标轴
            if (i == 0) {
                itemLabel.center = CGPointMake(itemPositionX+xAxisItemWidth/2, itemPositionY+[UIFont systemFontOfSize:6].lineHeight);
            } else {
                itemLabel.center = CGPointMake(itemPositionX, itemPositionY+[UIFont systemFontOfSize:6].lineHeight);
                
            }
        }
    } else {
        CGFloat yAxisItemHeight = (contentHeight-30)/(_yAxisItemsCount+1);
        CGFloat yAxisItemOffset = (_yAxisMaxItemVaule-_yAxisMinItemVaule)/(_yAxisItemsCount-1);
        
        for (NSInteger i = 0, count = dataArray.count; i<count; i++) {
            //计算数据点的坐标
            CGFloat itemPositionX = xAxisItemWidth*i;
            
            CGFloat item = [dataArray[i] floatValue];
            CGFloat itemPositionY;
            if (item < _yAxisMinItemVaule) {
                itemPositionY = contentHeight - yAxisItemHeight*(item/_yAxisMinItemVaule);
                
            } else if (item > _yAxisMaxItemVaule) {
                itemPositionY = 30 - 30*((item-_yAxisMaxItemVaule)/yAxisItemOffset);
                
            } else {
                itemPositionY = contentHeight - (yAxisItemHeight + (item-_yAxisMinItemVaule)/(_yAxisMaxItemVaule-_yAxisMinItemVaule)*(contentHeight-30-yAxisItemHeight));
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
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = _themeColor;
                label.text = [NSString stringWithFormat:@"%.2f", item];
                label;
            });
            [_xAxisView addSubview:itemLabel];
            itemLabel.frame = CGRectMake(0, 0, xAxisItemWidth, [UIFont systemFontOfSize:6].lineHeight);
            
            //第一个数据显示的位置往右偏，防止超出坐标轴
            if (i == 0) {
                itemLabel.center = CGPointMake(itemPositionX+xAxisItemWidth/2, itemPositionY+[UIFont systemFontOfSize:6].lineHeight);
            } else {
                itemLabel.center = CGPointMake(itemPositionX, itemPositionY+[UIFont systemFontOfSize:6].lineHeight);
                
            }
        }
    }

    shapeLayer.path = path.CGPath;
    [_xAxisView.layer addSublayer:shapeLayer];
    
    //设置折线绘制动画
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 3;
    pathAnimation.repeatCount = 1;
    pathAnimation.removedOnCompletion = YES;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [shapeLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
}

@end
