//
//  LHZCollectionView_HorizontalLayout.m
//  LHZCollectionViewLayout
//
//  Created by 684lhz on 17/2/15.
//  Copyright © 2017年 684lhz. All rights reserved.
//

#import "LHZCollectionView_HorizontalLayout.h"

@interface UICollectionViewLayoutAttributes (Horizontal)

/** 修改每个section每行第一个attribute的fram*/
- (void)HorizontalFrameWithSectionInset:(UIEdgeInsets)sectionInset sectionWidth:(CGFloat) width sectionIndex:(NSInteger) index;

@end

@implementation UICollectionViewLayoutAttributes (Horizontal)

/**
 修改每个section每行第一个attribute的fram

 @param sectionInset section的边距
 @param width section的width
 @param index section的index
 */
- (void)HorizontalFrameWithSectionInset:(UIEdgeInsets)sectionInset sectionWidth:(CGFloat) width sectionIndex:(NSInteger) index {
    CGRect frame = self.frame;
    frame.origin.x = sectionInset.left + width * index;
    frame.origin.y = sectionInset.top;
    self.frame = frame;
}

@end


@interface LHZCollectionView_HorizontalLayout ()


@end

@implementation LHZCollectionView_HorizontalLayout

- (instancetype)init {
    if (self = [super init]) {
        self.numberOfLineInSection = 4;
    }
    return self;
}

/**
 获取范围内的attributes
 @param rect collecionView当前显示的范围
 @return 范围内所有的attributte
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {

    NSMutableArray *allShowAttributes = [NSMutableArray array];
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    for(NSInteger section = 0; section < numberOfSections; section++) {
        NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger row = 0; row < numberOfItemsInSection; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:indexPath];
//            判断attribute的fram是否在rect内
            if(CGRectIntersectsRect(rect, attribute.frame))
            {
                [allShowAttributes addObject:attribute];
            }
        }
    }
    return allShowAttributes;
}

/**
 计算当前indexPath的cell的Attributes
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {

    UICollectionViewLayoutAttributes *currentItemAttributes = [[super layoutAttributesForItemAtIndexPath:indexPath] copy];
//    section的边距
    UIEdgeInsets sectionInset = [self evaluatedSectionInsetForItemAtIndex:indexPath.section];
//    行距
    CGFloat linesSpacing  = [self evaluatedMinimumLinesSpacingForSectionAtIndex:indexPath.section];
//    cell的间距
    CGFloat itemsSpacing = [self evaluatedMinimumInteritemSpacingForSectionAtIndex:indexPath.section];
//    计算第一个section的大小
    CGSize sectionSize = CGSizeMake(0, 0);
    if (indexPath.section > 0) {
        CGSize cellSize = [self evaluatedSizeForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        CGFloat width = cellSize.width * self.numberOfLineInSection + itemsSpacing * (self.numberOfLineInSection - 1) + sectionInset.left + sectionInset.right;
//        每个section的cell个数
        NSInteger numberOfItemInSection = [self.collectionView numberOfItemsInSection:0];
//        每个section有多少个
        NSInteger lineCount = numberOfItemInSection / self.numberOfLineInSection;
        if ( numberOfItemInSection % self.numberOfLineInSection > 0) {
            lineCount ++;
        }
//        section的高度
        CGFloat Height = cellSize.height * lineCount + linesSpacing * (lineCount - 1) + sectionInset.top +sectionInset.bottom;
        sectionSize = CGSizeMake(width, Height);
    }
//    section的第一个cell
    BOOL isFirstItemInSection = indexPath.row == 0;
    if (isFirstItemInSection) {
        [currentItemAttributes HorizontalFrameWithSectionInset:sectionInset sectionWidth:sectionSize.width sectionIndex:indexPath.section];
        return currentItemAttributes;
    }
    //前一个cell的Attributes
    NSIndexPath* previousIndexPath = [NSIndexPath indexPathForItem:indexPath.item-1 inSection:indexPath.section];
    CGRect previousFrame = [self layoutAttributesForItemAtIndexPath:previousIndexPath].frame;
//    前一个cell的最右边的X
    CGFloat previousXRightPoint = previousFrame.origin.x + previousFrame.size.width;
//    前一个cell的最下边的Y
    CGFloat previousYBottomPoint = previousFrame.origin.y + previousFrame.size.height;
    
    //每行第一个cell
    BOOL isFirstItemInLine = indexPath.row % self.numberOfLineInSection == 0;
    if (isFirstItemInLine) {
        [currentItemAttributes HorizontalFrameWithSectionInset:sectionInset sectionWidth:sectionSize.width sectionIndex:indexPath.section];
        CGRect currentItemFrame = currentItemAttributes.frame;
        currentItemFrame.origin.y = previousYBottomPoint + linesSpacing;
        currentItemAttributes.frame = currentItemFrame;
        return currentItemAttributes;
    }
    // 其余cell
    CGRect currentFrame = currentItemAttributes.frame;
    currentFrame.origin.x = previousXRightPoint + itemsSpacing;
    currentFrame.origin.y = previousFrame.origin.y;
    currentItemAttributes.frame = currentFrame;
    
    return currentItemAttributes;
}


/**
 计算collectionView的ContentSize
 
 @return collectionView的内容范围
 */
- (CGSize)collectionViewContentSize {
    CGSize cellSize = [self evaluatedSizeForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UIEdgeInsets sectionInset = [self evaluatedSectionInsetForItemAtIndex:0];
    CGFloat linesSpacing  = [self evaluatedMinimumLinesSpacingForSectionAtIndex:0];
    CGFloat itemsSpacing = [self evaluatedMinimumInteritemSpacingForSectionAtIndex:0];
    CGFloat width = cellSize.width * self.numberOfLineInSection + itemsSpacing * (self.numberOfLineInSection - 1) + sectionInset.left + sectionInset.right;
    NSInteger numberOfItemInSection = [self.collectionView numberOfItemsInSection:0];
    NSInteger lineCount = numberOfItemInSection / self.numberOfLineInSection;
    if ( numberOfItemInSection % self.numberOfLineInSection > 0) {
        lineCount ++;
    }
    CGFloat Height = cellSize.height * lineCount + linesSpacing * (lineCount - 1) + sectionInset.top +sectionInset.bottom;
    NSInteger numberOfSection = [self.collectionView numberOfSections];
    return CGSizeMake(width * numberOfSection, Height);
}

/**
 cell的Size
 */
- (CGSize)evaluatedSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        id<LHZCollectionView_HorizontalLayoutDelegate>delegate = (id<LHZCollectionView_HorizontalLayoutDelegate>)self.collectionView.delegate;
        CGSize cellSize = [delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
        return cellSize;
    }else {
        return CGSizeMake(0, 0);
    }
}

/**
 对应section中每行cell的间距
 */
- (CGFloat)evaluatedMinimumLinesSpacingForSectionAtIndex:(NSInteger)sectionIndex {
    if([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]){
        id<LHZCollectionView_HorizontalLayoutDelegate>delegate = (id<LHZCollectionView_HorizontalLayoutDelegate>)self.collectionView.delegate;
        return [delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:sectionIndex];
    }else {
        return self.minimumLineSpacing;
    }
}

/**
 对应section中cell的间距
 */
- (CGFloat)evaluatedMinimumInteritemSpacingForSectionAtIndex:(NSInteger)sectionIndex {
    if([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]){
        id<LHZCollectionView_HorizontalLayoutDelegate>delegate = (id<LHZCollectionView_HorizontalLayoutDelegate>)self.collectionView.delegate;
        return [delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:sectionIndex];
    }else {
        return self.minimumInteritemSpacing;
    }
}

/**
 section的边距
 */
- (UIEdgeInsets)evaluatedSectionInsetForItemAtIndex:(NSInteger)index
{
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        id<LHZCollectionView_HorizontalLayoutDelegate> delegate = (id<LHZCollectionView_HorizontalLayoutDelegate>)self.collectionView.delegate;
        
        return [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:index];
    } else {
        return self.sectionInset;
    }
}
@end
