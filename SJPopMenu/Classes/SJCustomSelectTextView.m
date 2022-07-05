//
//  SJCustomSelectTextView.m
//  SJPopMenu
//
//  Created by sj on 2022/7/4.
//

#import "SJCustomSelectTextView.h"
#import "SJPopMenu.h"

@interface SJCustomSelectTextView ()<UITextViewDelegate>

@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
/// 标记拖动时，不清空selectRange
@property (nonatomic, assign) BOOL mark;

@end

@implementation SJCustomSelectTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        [self addLongPress];
        [self addTap];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidePopMenuIfNeeded) name:SJChangePopMenuIfNeeded object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPopMenuIfNeeded) name:SJShowPopMenuIfNeeded object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(markedClickTextView) name:SJClickPopMenuInTextView object:nil];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.delegate = self;
    [self addLongPress];
    [self addTap];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidePopMenuIfNeeded) name:SJChangePopMenuIfNeeded object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPopMenuIfNeeded) name:SJShowPopMenuIfNeeded object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(markedClickTextView) name:SJClickPopMenuInTextView object:nil];
}

/// 标记拖动的是textview  不能清空selectRange
- (void)markedClickTextView
{
    self.mark = YES;
}

- (void)hidePopMenuIfNeeded
{
    if (!self.mark) {
        self.selectedRange = NSMakeRange(0, 0);
    }
}

- (void)showPopMenuIfNeeded
{
    self.mark = NO;
    if (self.selectedRange.length) {
        [self showPopMenuWithTextView:self];
    }
}

- (void)addLongPress
{
    if (!self.longPress) {
        self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress)];
        /// 系统自带长按手势太多，把时间调小防止触发其他手势不能直接全选
        self.longPress.minimumPressDuration = 0.3;
        [self addGestureRecognizer:self.longPress];
    }
}

- (void)addTap
{
    if (!self.tap) {
        self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textViewTaped)];
        [self addGestureRecognizer:self.tap];
    }
}

- (void)onLongPress
{
    self.selectedRange = NSMakeRange(0, 0);
    [self performSelector:@selector(selectAll:) withObject:nil];
}

- (void)textViewTaped
{
    self.selectedRange = NSMakeRange(0, 0);
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return NO;
}

/// 一般不重写 写的话要写becomeFirstResponder 否则默认选中一部分文字
//- (void)selectAll:(id)sender
//{
//    [self becomeFirstResponder];
//    self.selectedRange = NSMakeRange(0, self.text.length);
//}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    /// 未选中会触发此方法 屏蔽掉未选中状态
    if (textView.selectedRange.length == 0) {
        [[SJPopMenu menu] hideMenu];
        return;
    }
    
    [self showPopMenuWithTextView:textView];
}

- (void)showPopMenuWithTextView:(UITextView *)textView
{
    if (textView.selectedRange.location == 0 && textView.selectedRange.length == textView.text.length) {
        /// 选中全部
        if (self.showTextMenu) {
            self.showTextMenu(CGRectZero, CGRectZero, textView.selectedRange, YES);
        }
    } else {
        CGRect startRect = [textView caretRectForPosition:[textView selectedTextRange].start];
        CGRect endRect = [textView caretRectForPosition:[textView selectedTextRange].end];

        if (self.showTextMenu) {
            self.showTextMenu(startRect, endRect, textView.selectedRange, NO);
        }
    }
}

@end
