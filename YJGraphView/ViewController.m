//
//  ViewController.m
//  YJGraphView
//
//  Created by Yang on 2018/12/5.
//  Copyright © 2018 YangJing. All rights reserved.
//

#import "ViewController.h"

#import "YJGraphBrokenLineView.h"
#import "YJGraphBarView.h"
#import "YJGraphPieView.h"

@interface ViewController () <UICollectionViewDelegate ,UICollectionViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addSubview];
}

//MARK: - collectionview datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
}


//MARK: - collectionview delegate
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (indexPath.row == 0) {
        YJGraphBrokenLineView *brokenLineView = ({
            YJGraphBrokenLineView *view = [[YJGraphBrokenLineView alloc] init];
            view.themeType = YJGraphThemeTypeDark;
            view.backgroundColor = [UIColor grayColor];
            view;
        });
        [cell.contentView addSubview:brokenLineView];
        brokenLineView.frame = CGRectMake(0, 20, CGRectGetWidth([UIScreen mainScreen].bounds)-40, CGRectGetWidth([UIScreen mainScreen].bounds)-20-40-40);
        [brokenLineView setXAxisItems:@[@"1 月", @"2 月", @"3 月", @"4 月", @"5 月", @"6 月"] autoFitWidth:YES];
        [brokenLineView setYAxisMaxItem:500 minItem:0 itemCount:5];
        [brokenLineView setDataArray:@[@300, @250, @550, @100, @400] lineColor:[UIColor greenColor]];

        UILabel *titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor clearColor];
            label.text = @"折线图";
            label;
        });
        [cell.contentView addSubview:titleLabel];
        titleLabel.frame = CGRectMake(0, CGRectGetWidth([UIScreen mainScreen].bounds)-20-40, CGRectGetWidth([UIScreen mainScreen].bounds)-20-40, 40);

    } else if (indexPath.row == 1) {
        YJGraphBarView *barView = ({
            YJGraphBarView *view = [[YJGraphBarView alloc] init];
            view.backgroundColor = [UIColor grayColor];
            view;
        });
        [cell.contentView addSubview:barView];
        barView.frame = CGRectMake(0, 20, CGRectGetWidth([UIScreen mainScreen].bounds)-40, CGRectGetWidth([UIScreen mainScreen].bounds)-20-80);
        [barView setXAxisItems:@[@"1 月", @"2 月", @"3 月", @"4 月", @"5 月", @"6 月"] autoFitWidth:YES];
        [barView setYAxisMaxItem:1500 minItem:1000 itemCount:5];
        [barView setDataArray:@[@1300, @1250, @1400, @1550, @1100] lineColor:[UIColor greenColor]];
        
        UILabel *titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor clearColor];
            label.text = @"条形图";
            label;
        });
        [cell.contentView addSubview:titleLabel];
        titleLabel.frame = CGRectMake(0, CGRectGetWidth([UIScreen mainScreen].bounds)-20-40, CGRectGetWidth([UIScreen mainScreen].bounds)-20-40, 40);
        
    } else if (indexPath.row == 2) {
        YJGraphPieView *pieView = ({
            YJGraphPieView *view = [[YJGraphPieView alloc] init];
            view.backgroundColor = [UIColor lightGrayColor];
            view;
        });
        [cell.contentView addSubview:pieView];
        
        pieView.frame = CGRectMake(0, 20, CGRectGetWidth([UIScreen mainScreen].bounds)-40, CGRectGetWidth([UIScreen mainScreen].bounds)-20-80);
        
        [pieView setDataArray:[@[@0.02, @0.23,@0.03, @0.01, @0.1, @0.2, @0.07, @0.14, @0.1, @0.1] mutableCopy]];
        
        UILabel *titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor clearColor];
            label.text = @"饼状图";
            label;
        });
        [cell.contentView addSubview:titleLabel];
        titleLabel.frame = CGRectMake(0, CGRectGetWidth([UIScreen mainScreen].bounds)-20-40, CGRectGetWidth([UIScreen mainScreen].bounds)-20-40, 40);
    }
}

- (void)addSubview {
    UICollectionViewFlowLayout *flowLayout = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 40;
        layout.minimumInteritemSpacing = 40;
        layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
        layout.itemSize = CGSizeMake(CGRectGetWidth(self.view.bounds)-40, CGRectGetWidth(self.view.bounds)-20);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout;
    });
    
    UICollectionView *collectionView = ({
        UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetWidth([UIScreen mainScreen].bounds)) collectionViewLayout:flowLayout];
        view.backgroundColor = [UIColor whiteColor];
        view.delegate = self;
        view.dataSource = self;
        view.pagingEnabled = YES;
        [view registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
        view;
    });
    [self.view addSubview:collectionView];
    collectionView.center = CGPointMake(CGRectGetWidth(self.view.bounds)/2.0, CGRectGetHeight(self.view.bounds)/2.0);
}

@end
