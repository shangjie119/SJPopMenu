//
//  SJCustomSelectTextView.h
//  SJPopMenu
//
//  Created by sj on 2022/7/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SJCustomSelectTextView : UITextView

@property (nonatomic, copy) void (^showTextMenu)(CGRect startRect, CGRect endRect, NSRange selectRange, BOOL isSelectAll);

@end

NS_ASSUME_NONNULL_END
