//
//  SJPopMenuCollectionViewCell.h
//  SJPopMenu
//
//  Created by sj on 2022/7/4.
//

#import <UIKit/UIKit.h>

@class SJPopMenuItem;

NS_ASSUME_NONNULL_BEGIN

@interface SJPopMenuCollectionViewCell : UICollectionViewCell

- (void)updateCellWithItem:(SJPopMenuItem *)item;

@end

NS_ASSUME_NONNULL_END
