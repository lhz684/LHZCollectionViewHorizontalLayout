//
//  LHZCollectionView_HorizontalLayout.h
//  LHZCollectionViewLayout
//
//  Created by 684lhz on 17/2/15.
//  Copyright © 2017年 684lhz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHZCollectionView_HorizontalLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) NSInteger numberOfLineInSection;
- (instancetype)init;
@end

@protocol LHZCollectionView_HorizontalLayoutDelegate <UICollectionViewDelegateFlowLayout>

@end
