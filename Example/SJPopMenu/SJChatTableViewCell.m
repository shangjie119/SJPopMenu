//
//  SJChatTableViewCell.m
//  SJPopMenu
//
//  Created by sj on 2022/7/4.
//

#import "SJChatTableViewCell.h"
#import "SJCustomSelectTextView.h"
#import "SJPopMenu.h"

@implementation SJChatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    __weak typeof(self) weakSelf = self;
    self.textView.showTextMenu = ^(CGRect startRect, CGRect endRect, NSRange selectRange, BOOL isSelectAll) {
        [weakSelf showMenuWithStartRect:startRect endRect:endRect isAll:isSelectAll];
    };
}

- (void)showMenuWithStartRect:(CGRect)startRect endRect:(CGRect)endRect isAll:(BOOL)isAll
{
    // 显示菜单栏
    SJPopMenuItem *copy = [SJPopMenuItem itemWithType:SJPopMenuItemCopy];
    SJPopMenuItem *recall = [SJPopMenuItem itemWithType:SJPopMenuItemWithdraw];
    SJPopMenuItem *delete = [SJPopMenuItem itemWithType:SJPopMenuItemDelete];
    SJPopMenuItem *forward = [SJPopMenuItem itemWithType:SJPopMenuItemForwarding];
    SJPopMenuItem *translate = [SJPopMenuItem itemWithType:SJPopMenuItemTranslate];
    SJPopMenuItem *quote = [SJPopMenuItem itemWithType:SJPopMenuItemQuote];
    SJPopMenuItem *multipleChoice = [SJPopMenuItem itemWithType:SJPopMenuItemMultipleChoice];
    SJPopMenuItem *selectAll = [SJPopMenuItem itemWithType:SJPopMenuItemSelectAll];

    NSMutableArray *items = [NSMutableArray array];
    if (isAll) {
        [items addObject:copy];
        [items addObject:forward];
        [items addObject:recall];
        [items addObject:delete];
        [items addObject:multipleChoice];
        [items addObject:quote];
        [items addObject:translate];
    } else {
        [items addObject:copy];
        [items addObject:selectAll];
        [items addObject:forward];
    }
    if (items.count > 0) {
        SJPopMenu *menu = [SJPopMenu menu];
        if (isAll) {
            [menu showBy:self.textView withItems:items];
        } else {
            [menu showBy:self.textView startRect:startRect endRect:endRect withItems:items];
        }
        __weak typeof(self) weakSelf = self;
        menu.itemActions = ^(SJPopMenuItemType type, NSString *title) {
            switch (type) {
                case SJPopMenuItemCopy:
                    [weakSelf coppy];
                    break;
                case SJPopMenuItemWithdraw:
                    [weakSelf recall];
                    break;
                case SJPopMenuItemDelete:
                    [weakSelf remove];
                    break;
                case SJPopMenuItemForwarding:
                    [weakSelf forward];
                    break;
                case SJPopMenuItemTranslate:
                    [weakSelf translate];
                    break;
                case SJPopMenuItemQuote:
                    [weakSelf quote];
                    break;
                case SJPopMenuItemMultipleChoice:
                    [weakSelf multipleChoice];
                    break;
                case SJPopMenuItemSelectAll:
                    [weakSelf selectAllText];
                    break;
                default:
                    break;
            }
        };
    }
}

- (void)coppy
{
    NSLog(@"%s", __func__);
}

- (void)recall
{
    NSLog(@"%s", __func__);
}

- (void)remove
{
    NSLog(@"%s", __func__);
}

- (void)forward
{
    NSLog(@"%s", __func__);
}

- (void)translate
{
    NSLog(@"%s", __func__);
}

- (void)quote
{
    NSLog(@"%s", __func__);
}

- (void)multipleChoice
{
    NSLog(@"%s", __func__);
}

- (void)selectAllText
{
    NSLog(@"%s", __func__);
    self.textView.selectedRange = NSMakeRange(0, self.textView.text.length);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
