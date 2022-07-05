//
//  SJChatTableViewCell.h
//  SJPopMenu
//
//  Created by sj on 2022/7/4.
//

#import <UIKit/UIKit.h>

@class SJCustomSelectTextView;

NS_ASSUME_NONNULL_BEGIN

@interface SJChatTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet SJCustomSelectTextView *textView;

@end

NS_ASSUME_NONNULL_END
