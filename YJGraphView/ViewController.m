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
    
    YJGraphPieView *pieView = ({
        YJGraphPieView *view = [[YJGraphPieView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    [self.view addSubview:pieView];
    
    pieView.frame = CGRectMake(20, 20, CGRectGetWidth([UIScreen mainScreen].bounds)-40, CGRectGetWidth([UIScreen mainScreen].bounds)-40);
    
    [pieView setDataArray:[@[@(0.02), @(0.23),@(0.03), @(0.01), @(0.1), @(0.2), @(0.27), @(0.14)] mutableCopy]];
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
    if (indexPath.row == 0) {
        
    } else if (indexPath.row == 1) {
        
    } else if (indexPath.row == 2) {
        
    }
}

@end
