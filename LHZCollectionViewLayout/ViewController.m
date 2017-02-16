//
//  ViewController.m
//  LHZCollectionViewLayout
//
//  Created by 684lhz on 17/2/15.
//  Copyright © 2017年 684lhz. All rights reserved.
//

#import "ViewController.h"
#import "LHZCollectionView_HorizontalLayout.h"
#import "LHZCollectionViewCell.h"

@interface ViewController ()
<UICollectionViewDelegate,
UICollectionViewDataSource,
LHZCollectionView_HorizontalLayoutDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/** 横向排列*/
@property (nonatomic, strong) LHZCollectionView_HorizontalLayout *collectionViewHorizontalLayout;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionViewHorizontalLayout = [[LHZCollectionView_HorizontalLayout alloc]init];
    self.collectionViewHorizontalLayout.numberOfLineInSection = 4;
    self.collectionView.collectionViewLayout = self.collectionViewHorizontalLayout;
    
//    self.collectionView.collectionViewLayout = [[UICollectionViewFlowLayout alloc]init];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"LHZCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"item"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.section == 1 && indexPath.row == 3) {
        
    }
    LHZCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor grayColor];
    cell.label.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 3) {
        
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (self.collectionView.frame.size.width - 20 - (self.collectionViewHorizontalLayout.numberOfLineInSection - 1) * 10) / self.collectionViewHorizontalLayout.numberOfLineInSection;
    return CGSizeMake(width, 80);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

@end
