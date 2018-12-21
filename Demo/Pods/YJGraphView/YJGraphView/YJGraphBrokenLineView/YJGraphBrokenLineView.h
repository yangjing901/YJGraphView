//
//  YJGraphBrokenLineView.h
//  YJGraphView
//
//  Created by Yang on 2018/12/5.
//  Copyright © 2018 YangJing. All rights reserved.
//

/* 折线统计图 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, YJGraphThemeType) {
    YJGraphThemeTypeLight,
    YJGraphThemeTypeDark
};

@interface YJGraphBrokenLineView : UIView

@property (nonatomic, assign) YJGraphThemeType themeType;

/**
 *  设置横轴坐标
 *  xAxisItems : 横轴坐标项
 *  autoFitWidth :  横轴坐标单位长度是否根据横轴坐标项数量适应；
 *                  YES:横轴坐标单位长度=总长/横轴坐标项数；
 *                  NO:横轴坐标单位长度=30,超出部分左右滑动显示
 */
- (void)setXAxisItems:(NSArray <NSString *> *)xAxisItems autoFitWidth:(BOOL)autoFitWidth;

/**
 *  设置纵轴坐标（纵轴坐标只支持数字，坐标取指定范围内的数字按等分数量递加）
 *  maxItem : 纵轴坐标项最大值
 *  minItem : 纵轴坐标项最小值
 *  itemCount :  纵轴坐标项等分数
 */
- (void)setYAxisMaxItem:(CGFloat)maxItem minItem:(CGFloat)minItem itemCount:(NSInteger)itemCount;

/**
 *  设置数据源 （数据源数量应与横轴坐标数对应）
 *  dataArray : 数据源
 *  lineColor : 折线颜色
 */
- (void)setDataArray:(NSArray<NSNumber *> *)dataArray lineColor:(UIColor *)lineColor;

@end

NS_ASSUME_NONNULL_END
