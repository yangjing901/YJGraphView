//
//  YJGraphPieView.m
//  YJGraphView
//
//  Created by Yang on 2018/12/6.
//  Copyright © 2018 YangJing. All rights reserved.
//

#import "YJGraphPieView.h"

@implementation YJGraphPieView

- (void)setDataArray:(NSMutableArray<NSNumber *> *)dataArray {
    
    //check data
    CGFloat totalPersent = 0;

    //将数组按从小到大顺序排序,顺带检测数据，饼状图数据总和不应该超过1
    for (NSInteger i = 0, count = dataArray.count-1; i < count; i++) {
//        CGFloat persent0 = [dataArray[i] floatValue];
//        totalPersent += persent0;
//        if (totalPersent > 1) {
//            NSLog(@"yangjing_%@: totalPersent > 1", NSStringFromClass([self class]));
//            return;
//        }
//
        for (NSInteger j = 0, count = dataArray.count - 1 - i; j < count; j++) {
            CGFloat persent1 = [dataArray[j] floatValue];
            CGFloat persent2 = [dataArray[j+1] floatValue];
            if (persent2 < persent1) {
                [dataArray exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
        }
    }
    
    //饼状图数据总和不足1的时候，补上不足的部位
    if (totalPersent < 1) {
//        [dataArray addObject:[NSNumber numberWithFloat:1-totalPersent]];
    }
    
    CGFloat viewWidth = CGRectGetWidth(self.bounds);
    CGFloat viewHeight = CGRectGetHeight(self.bounds);

    //饼图半径
    CGFloat radius = (viewWidth-120)/2;
    //饼图中心
    CGPoint center = CGPointMake(viewWidth/2, viewWidth/2);
    //饼图起始角度
    CGFloat currentAngle = -M_PI/2.0;
    //画图
    for (NSInteger i = 0, count = dataArray.count; i < count; i++) {
        
        CGFloat persent = [dataArray[i] floatValue];
        CGFloat startAngle = currentAngle;
        CGFloat endAngle = currentAngle + 2*M_PI*persent;
        currentAngle = endAngle;
        
        //随机颜色
        UIColor *fillColor = [UIColor colorWithRed:(float)(arc4random()%100)/100 green:(float)(arc4random()%100)/100 blue:(float)(arc4random()%100)/100 alpha:1];
        
        //画扇形
        UIBezierPath *sectorPath = [UIBezierPath bezierPath];
        [sectorPath moveToPoint:center];
        [sectorPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];

        CAShapeLayer *sectorLayer = [CAShapeLayer new];
        sectorLayer.strokeColor = [UIColor whiteColor].CGColor;
        sectorLayer.fillColor = fillColor.CGColor;
        sectorLayer.path = sectorPath.CGPath;
        [self.layer addSublayer:sectorLayer];
        
        //标注
        UILabel *itemLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:10];
            label.textColor = fillColor;
            label.adjustsFontSizeToFitWidth = YES;
            label.text = [NSString stringWithFormat:@"%.0f%%", persent*100];
            label;
        });
        [self addSubview:itemLabel];
        
        if (totalPersent < 1 && i == dataArray.count-1) {
            itemLabel.text = [NSString stringWithFormat:@"Other %.0f%%", persent*100];
        }
        
        //计算标注的位置，画标注线
        //找出扇形圆弧的中点
        CGFloat centerAngle = (endAngle-startAngle)/2+startAngle;
        CGFloat targetPointX = fabs(sqrt((radius*radius)/(1+tan(centerAngle)*tan(centerAngle))));
        CGFloat targetPointY = fabs(tan(centerAngle)*targetPointX);
        
        //标注线的起始点
        UIView *pointView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = fillColor;
            view.layer.cornerRadius = 2;
            view;
        });
        [self addSubview:pointView];
        pointView.frame = CGRectMake(0, 0, 4, 4);
        
        //画标注线
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        
        CGFloat descHeight = [UIFont systemFontOfSize:10].lineHeight+10;
        
        //ps:数学不太好，这里很麻烦的把坐标系分成四个象限区分处理，应该能有更好的方法
        if (centerAngle > -M_PI/2.0 && centerAngle <= 0) {
            //标注线的起始点设在对应扇形圆弧中点离圆弧5px的位置
            targetPointX = center.x + (targetPointX + 5);
            targetPointY = center.y - (targetPointY + 5);
            pointView.center = CGPointMake(targetPointX, targetPointY);

            //画标注线，标注线为一条从起始点到
            CGFloat linePointY = descHeight*(i+1);
            [linePath moveToPoint:CGPointMake(targetPointX, targetPointY)];
            [linePath addLineToPoint:CGPointMake(viewWidth-40, linePointY)];
            [linePath addLineToPoint:CGPointMake(viewWidth, linePointY)];

            itemLabel.textAlignment = NSTextAlignmentRight;
            itemLabel.frame = CGRectMake(viewWidth-60, linePointY-[UIFont systemFontOfSize:6].lineHeight-3, 60, [UIFont systemFontOfSize:6].lineHeight);

        } else if (centerAngle > 0 && centerAngle <= M_PI/2.0) {
            targetPointX = center.x + (targetPointX + 5);
            targetPointY = center.y + (targetPointY + 5);
            pointView.center = CGPointMake(targetPointX, targetPointY);

            CGFloat linePointY = descHeight*(i+1)+center.y;
            [linePath moveToPoint:CGPointMake(targetPointX, targetPointY)];
            [linePath addLineToPoint:CGPointMake(viewWidth-40, linePointY)];
            [linePath addLineToPoint:CGPointMake(viewWidth, linePointY)];
            
            itemLabel.textAlignment = NSTextAlignmentRight;
            itemLabel.frame = CGRectMake(viewWidth-60, linePointY-[UIFont systemFontOfSize:6].lineHeight-3, 60, [UIFont systemFontOfSize:6].lineHeight);
            
        } else if (centerAngle > M_PI/2.0 && centerAngle <= M_PI) {
            targetPointX = center.x - (targetPointX + 5);
            targetPointY = center.y + (targetPointY + 5);
            pointView.center = CGPointMake(targetPointX, targetPointY);

            CGFloat linePointY = descHeight*(i+1)+center.y;
            [linePath moveToPoint:CGPointMake(targetPointX, targetPointY)];
            [linePath addLineToPoint:CGPointMake(40, linePointY)];
            [linePath addLineToPoint:CGPointMake(0, linePointY)];
            
            itemLabel.textAlignment = NSTextAlignmentLeft;
            itemLabel.frame = CGRectMake(0, linePointY-[UIFont systemFontOfSize:6].lineHeight-3, 60, [UIFont systemFontOfSize:6].lineHeight);
            
        } else {
            targetPointX = center.x - (targetPointX + 5);
            targetPointY = center.y - (targetPointY + 5);
            pointView.center = CGPointMake(targetPointX, targetPointY);

            CGFloat linePointY = descHeight*(i+1);
            [linePath moveToPoint:CGPointMake(targetPointX, targetPointY)];
            [linePath addLineToPoint:CGPointMake(40, linePointY)];
            [linePath addLineToPoint:CGPointMake(0, linePointY)];
            
            itemLabel.textAlignment = NSTextAlignmentLeft;
            itemLabel.frame = CGRectMake(0, linePointY-[UIFont systemFontOfSize:6].lineHeight-3, 60, [UIFont systemFontOfSize:6].lineHeight);
        }
        
        CAShapeLayer *shapeLayer2 = [CAShapeLayer new];
        shapeLayer2.strokeColor = fillColor.CGColor;
        shapeLayer2.fillColor = [UIColor clearColor].CGColor;
        shapeLayer2.path = linePath.CGPath;
        shapeLayer2.lineWidth = 1;
        [self.layer addSublayer:shapeLayer2];
        
    }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:viewWidth/2 startAngle:-M_PI/2.0 endAngle:2*M_PI-M_PI/2.0 clockwise:YES];

    //画圆
    CAShapeLayer *shapeLayer = [CAShapeLayer new];
    shapeLayer.strokeColor = self.backgroundColor.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = viewWidth;
    shapeLayer.path = path.CGPath;
    self.layer.mask = shapeLayer;

    //设置动画
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 3;
    pathAnimation.repeatCount = 1;
    pathAnimation.removedOnCompletion = YES;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [shapeLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
}

@end
