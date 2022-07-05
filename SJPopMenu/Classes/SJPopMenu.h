//
//  SJPopMenu.h
//  SJPopMenu
//
//  Created by sj on 2022/7/4.
//

#import <UIKit/UIKit.h>

@class SJPopMenuItem;

/// 滚动时发送通知
static NSString * _Nullable const SJChangePopMenuIfNeeded = @"SJChangePopMenuIfNeeded";
/// 滚动结束发送通知
static NSString * _Nullable const SJShowPopMenuIfNeeded = @"SJShowPopMenuIfNeeded";
/// 点击到textView时发送通知
static NSString * _Nullable const SJClickPopMenuInTextView = @"SJClickPopMenuInTextView";

typedef NS_ENUM(NSUInteger, SJPopMenuItemType) {
    SJPopMenuItemCopy, /// 复制
    SJPopMenuItemSelectAll, ///全选
    SJPopMenuItemWithdraw, /// 撤回
    SJPopMenuItemDelete, /// 删除
    SJPopMenuItemForwarding, /// 转发
    SJPopMenuItemTranslate, /// 翻译
    SJPopMenuItemQuote, /// 引用
    SJPopMenuItemMultipleChoice, /// 多选
    SJPopMenuItemSave, /// 保存
    SJPopMenuItemDownload, /// 下载
    SJPopMenuItemPackUp, /// 收起
    SJPopMenuItemRetranslation, /// 重译
    SJPopMenuItemMutePlay, /// 静音播放
    SJPopMenuItemRemind, /// 提醒
};

NS_ASSUME_NONNULL_BEGIN

@interface SJPopMenu : UIView

+ (instancetype)menu;

- (void)hideMenu;

- (void)showBy:(UIView *)target withItems:(NSArray <SJPopMenuItem *>*)items;

- (void)showBy:(UIView *)target startRect:(CGRect)startRect endRect:(CGRect)endRect withItems:(NSArray <SJPopMenuItem *>*)items;

- (void)showBy:(UIView *)target withItems:(NSArray <SJPopMenuItem *>*)items keyboardHeight:(CGFloat)keyboardHeight;

- (void)showBy:(UIView *)target startRect:(CGRect)startRect endRect:(CGRect)endRect withItems:(NSArray <SJPopMenuItem *>*)items keyboardHeight:(CGFloat)keyboardHeight;

/// 点击功能可以用type，也可以用name判断
@property (nonatomic, copy) void (^itemActions)(SJPopMenuItemType type, NSString *title);

@property (nonatomic, copy) void (^menuHideDone)(void);

@property (nonatomic, assign) CGSize menuSize;

/// 长按显示颜色， 默认#333333
@property (nonatomic, strong) UIColor *backColor;

@end

@interface SJPopMenuItem : NSObject

+ (instancetype)itemWithType:(SJPopMenuItemType)type;

+ (instancetype)itemWithType:(SJPopMenuItemType)type title:(NSString *)title image:(NSString *)image;

+ (instancetype)itemWithTitle:(NSString *)title image:(NSString *)image;

@property (nonatomic, assign) SJPopMenuItemType itemType;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *image;

@end

NS_ASSUME_NONNULL_END
