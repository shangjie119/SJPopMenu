//
//  SJPopMenu.m
//  SJPopMenu
//
//  Created by sj on 2022/7/4.
//

#import "SJPopMenu.h"

#import "SJPopMenuArrow.h"
#import "SJPopMenuCollectionViewCell.h"
#import "UIColor+Hex.h"
#import "SJKeyboardManager.h"

static CGFloat const SJPopItemWidth = 56.f;
static CGFloat const SJPopItemHeight = 67.f;
static CGFloat const SJPopLeftRightMargin = 10;
static CGFloat const SJPopTopBottommargin = 8;

#define kStatusbarHeight CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame])
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define PopScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define PopScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define PopArrowSize CGSizeMake(14.0, 7.0)

@interface SJPopMenu ()<UICollectionViewDataSource, UICollectionViewDelegate>

{
    CGRect _tempStartRect; /// 选中开始区域在屏幕位置
    CGRect _tempEndRect; /// 选中结束区域在屏幕位置
    CGFloat _topSelectWidth; /// 选中区域第一行宽度
    CGFloat _bottomSelectWidth; /// 选中区域最后一行宽度
    CGFloat _contentLeftMargin; /// 文本文字左边距
    CGFloat _contentRightMargin; /// 文本文字右边距
}

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) SJPopMenuArrow *popArrow;

@property (nonatomic, strong) UIView *popView;

@property (nonatomic, strong) UIView *targetView;

/// 选中部分文字区间
@property (nonatomic, assign) CGRect startRect;
@property (nonatomic, assign) CGRect endRect;
@property (nonatomic, assign) CGFloat visibleHeight;
@property (nonatomic, assign) CGRect targetViewFrame;

@property (nonatomic, strong) NSArray<SJPopMenuItem *> *items;

@end

@implementation SJPopMenu

@synthesize menuSize = _menuSize;

static SJPopMenu *menu = nil;
+ (instancetype)menu
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        menu = [[self alloc] init];
        menu.frame = [UIScreen mainScreen].bounds;
        menu.backColor = [UIColor sj_colorWithHex:0x333333];
        menu.backgroundColor = [UIColor clearColor];
        [[NSNotificationCenter defaultCenter] addObserver:menu selector:@selector(keyboardChangeShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:menu selector:@selector(keyboardChangeShow:) name:UIKeyboardWillHideNotification object:nil];
        /// 输入文字时发通知，隐藏掉menu
        [[NSNotificationCenter defaultCenter] addObserver:menu selector:@selector(hideMenu) name:@"SJPopMenuHidden" object:nil];
    });
    return menu;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    NSLog(@"%s", __func__);
    if (CGRectContainsPoint(self.targetViewFrame, point)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SJClickPopMenuInTextView object:nil];
    }
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self) {
        [self hideMenuPoint:point];
        return self.superview;
    }
    return hitView;
}

- (void)keyboardChangeShow:(NSNotification *)not
{
    [self hideMenu];
}

#pragma mark MenuShow
- (void)showBy:(UIView *)target withItems:(NSArray<SJPopMenuItem *> *)items
{
    [self showBy:target startRect:CGRectZero endRect:CGRectZero withItems:items keyboardHeight:[SJKeyboardManager sharedManager].keyboardHeight];
}

- (void)showBy:(UIView *)target startRect:(CGRect)startRect endRect:(CGRect)endRect withItems:(NSArray <SJPopMenuItem *>*)items
{
    [self showBy:target startRect:startRect endRect:endRect withItems:items keyboardHeight:[SJKeyboardManager sharedManager].keyboardHeight];
}

- (void)showBy:(UIView *)target withItems:(NSArray<SJPopMenuItem *> *)items keyboardHeight:(CGFloat)keyboardHeight
{
    [self showBy:target startRect:CGRectZero endRect:CGRectZero withItems:items keyboardHeight:keyboardHeight];
}

- (void)showBy:(UIView *)target startRect:(CGRect)startRect endRect:(CGRect)endRect withItems:(NSArray <SJPopMenuItem *>*)items keyboardHeight:(CGFloat)keyboardHeight
{
    [self clearAllData];
    self.startRect = startRect;
    self.endRect = endRect;
    self.visibleHeight = PopScreenHeight - keyboardHeight;
    self.targetView = target;
    if ([self targetViewOutValidFrame]) {
        return;
    }
    if (![target isKindOfClass:[UIView class]]) {
        return;
    }
    self.items = items;
    [self updateSubviewsLayout];
    UIViewController *targetVc = [SJPopMenu vcForShowView:self.targetView];
    if (targetVc.navigationController) {
        [targetVc.navigationController.view addSubview:self];
    } else {
        [targetVc.view addSubview:self];
    }
}

/// 在有效区域外部（即屏幕外） 什么都不做
- (BOOL)targetViewOutValidFrame
{
    CGRect targetFrame;
    CGRect targetRect = [self.targetView bounds];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    targetFrame = [self.targetView convertRect:targetRect toView:window];
    if (targetFrame.origin.y > kScreenHeight || targetFrame.origin.y + targetFrame.size.height < 0) {
        return YES;
    }
    return NO;
}

- (void)updateSubviewsLayout
{
    [self updateMenuSize];
    if (!CGRectEqualToRect(self.startRect, CGRectZero)) {
        [self updateSelectSizeData];
    }
    [self updateTargetViewFrame];
    self.popView.frame = [self getPopFrame];
    self.popArrow.frame = [self getArrowFrame];
    if ((self.popArrow.frame.origin.y > self.popView.frame.origin.y)) {
        self.popArrow.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);
    } else {
        self.popArrow.transform = CGAffineTransformIdentity;
    }
    [self.collectionView reloadData];
}

/// 设置选中区域位置
- (void)updateSelectSizeData
{
    _contentLeftMargin = ((UITextView *)self.targetView).textContainerInset.left;
    _contentRightMargin = ((UITextView *)self.targetView).textContainerInset.right;
    _topSelectWidth = self.targetView.frame.size.width - self.startRect.origin.x - _contentRightMargin;
    _bottomSelectWidth = self.endRect.origin.x - _contentLeftMargin;
    if (self.startRect.origin.y == self.endRect.origin.y) {
        _topSelectWidth = _bottomSelectWidth = self.endRect.origin.x - self.startRect.origin.x;
    }
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    _tempStartRect = [self.targetView convertRect:self.startRect toView:window];
    _tempEndRect = [self.targetView convertRect:self.endRect toView:window];
    /// 文本特别长，menu显示在文本正中间
    if (CGRectGetMinY(_tempStartRect) - kStatusbarHeight < self.menuSize.height + PopArrowSize.height && self.visibleHeight - (CGRectGetMaxY(_tempEndRect) - CGRectGetMinY(_tempStartRect)) - 10 < self.menuSize.height + PopArrowSize.height) {
        CGRect targetRect = [self.targetView bounds];
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        CGRect targetFrame = [self.targetView convertRect:targetRect toView:window];
        _tempStartRect.origin.x = targetFrame.origin.x + _contentLeftMargin;
        _tempStartRect.origin.y = self.visibleHeight / 2.0;
        _topSelectWidth = self.targetView.frame.size.width - _contentLeftMargin - _contentRightMargin;
    }

}

- (void)updateMenuSize
{
    NSInteger line = (self.items.count + 4) / 5;
    CGFloat width = MIN(self.items.count, 5) * (SJPopItemWidth) + SJPopLeftRightMargin * 2;
    CGFloat height = line * SJPopItemHeight + SJPopTopBottommargin * 2;
    self.menuSize = CGSizeMake(width, height);
    self.collectionView.frame = CGRectMake(0, 0, self.menuSize.width, self.menuSize.height);
}

#pragma mark MenuHide
- (void)hideMenu
{
    [self removeFromSuperview];
    if (self.menuHideDone) {
        self.menuHideDone();
    }
    
    /**
     * 如果不是直接拖动UITextSelectionView修改选中范围，把textView的选中取消
     */
    UIView *textView = [self getSubTextView:self.targetView];
    if (textView && ![textView isFirstResponder]) {
        ((UITextView *)textView).selectedRange = NSMakeRange(0, 0);
    }
}

- (void)hideMenuPoint:(CGPoint)point
{
    [self hideMenu];
    CGRect targetFrame;
    CGRect targetRect = [self.targetView bounds];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    targetFrame = [self.targetView convertRect:targetRect toView:window];
    if (!CGRectContainsPoint(targetFrame, point)) {
        [self clearTextViewSelection:self.targetView];
    }
}

- (UIView *)getSubTextView:(UIView *)view
{
    if ([view isKindOfClass:[UITextView class]]) {
        return view;
    } else {
        for (UIView *sub in view.subviews) {
            UIView *res = [self getSubTextView:sub];
            if (res) {
                return res;
            }
        }
    }
    return nil;
}

- (void)clearTextViewSelection:(UIView *)view
{
    if ([view isKindOfClass:[UITextView class]]) {
        ((UITextView *)view).selectedRange = NSMakeRange(0, 0);
    } else {
        for (UIView *sub in view.subviews) {
            [self clearTextViewSelection:sub];
        }
    }
}

- (void)clearAllData
{
    self.items = nil;
    self.menuSize = CGSizeZero;
    self.startRect = CGRectZero;
    self.endRect = CGRectZero;
    self.visibleHeight = 0;
    self.targetViewFrame = CGRectZero;
    _tempStartRect = CGRectZero;
    _tempEndRect = CGRectZero;
    _topSelectWidth = 0;
    _bottomSelectWidth = 0;
    _contentLeftMargin = 0;
    _contentRightMargin = 0;
    [self removeFromSuperview];
}


- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(SJPopItemWidth, SJPopItemHeight);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.menuSize.width, self.menuSize.height) collectionViewLayout:layout];
        _collectionView.contentInset = UIEdgeInsetsMake(SJPopTopBottommargin, SJPopLeftRightMargin, SJPopTopBottommargin, SJPopLeftRightMargin);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1];
        _collectionView.bounces = NO;
        _collectionView.layer.cornerRadius = 8;
        _collectionView.layer.masksToBounds = YES;
        if (@available(iOS 11, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_collectionView registerNib:[UINib nibWithNibName:@"SJPopMenuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SJPopMenuCollectionViewCell"];
    }
    return _collectionView;
}

- (UIView *)popView
{
    if (!_popView) {
        _popView = [[UIView alloc] initWithFrame:CGRectZero];
        _popView.layer.cornerRadius = 8;
        _popView.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.12].CGColor;
        _popView.layer.shadowOffset = CGSizeMake(0, 4);
        _popView.layer.shadowOpacity = 1;
        _popView.layer.shadowRadius = 10;
        [_popView addSubview:self.collectionView];
        [self addSubview:_popView];
    }
    return _popView;
}

- (SJPopMenuArrow *)popArrow
{
    if (!_popArrow) {
        _popArrow = [[SJPopMenuArrow alloc] initWithFrame:CGRectMake(0, 0, PopArrowSize.width, PopArrowSize.height) color:[UIColor colorWithRed:73 / 255.0 green:73/255.0 blue:73/255.0 alpha:1]];
        [self addSubview:_popArrow];
    }
    return _popArrow;
}

#pragma mark - Calculate Frame

- (void)updateTargetViewFrame
{
    CGRect targetFrame;
    CGRect targetRect = [self.targetView bounds];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    targetFrame = [self.targetView convertRect:targetRect toView:window];
    if (!CGRectEqualToRect(self.startRect, CGRectZero)) {
        targetFrame.origin.y += self.startRect.origin.y;
        targetFrame.size.height = self.endRect.origin.y - self.startRect.origin.y + self.endRect.size.height;
    }
    if (targetFrame.origin.y < 0) {
        targetFrame.size.height = MIN(self.visibleHeight, targetFrame.origin.y + targetFrame.size.height);
        targetFrame.origin.y = 0;
    } else {
        targetFrame.size.height = MIN(self.visibleHeight - targetFrame.origin.y, targetFrame.size.height);
    }
    CGFloat menuHeight = self.menuSize.height + kStatusbarHeight;
    if (targetFrame.origin.y < menuHeight) {
        /// 文本特别长，menu显示在文本正中间
        if (self.visibleHeight - targetFrame.origin.y - targetFrame.size.height < menuHeight) {
            targetFrame.origin.y = (targetFrame.origin.y + targetFrame.size.height) / 2.0;
        }
    } else {
        targetFrame.size.height = self.visibleHeight - targetFrame.origin.y;
    }
    targetFrame.origin.y = ceil(targetFrame.origin.y);
    self.targetViewFrame = targetFrame;
}

- (CGPoint)targetViewCenter
{
    CGRect targetFrame = self.targetViewFrame;
    CGFloat centerX = targetFrame.origin.x + targetFrame.size.width/2.0;
    CGFloat centerY = targetFrame.origin.y + targetFrame.size.height/2.0;
    return CGPointMake(centerX, centerY);
}

- (CGRect)getPopFrame {
    CGRect targetFrame = self.targetViewFrame;
    CGPoint targetCenter = self.targetViewCenter;
    
    CGFloat menuWidth = self.menuSize.width;
    CGFloat menuHeight = self.menuSize.height;
    CGFloat spac = 10.f;
    
    CGRect popFrame = CGRectMake(targetCenter.x-menuWidth/2.0, 0, menuWidth, menuHeight);
    
    BOOL left = targetCenter.x / PopScreenWidth < 0.5;
    /// top: YES  上文字 下menu
    BOOL top = CGRectGetMinY(targetFrame) < menuHeight + PopArrowSize.height + kStatusbarHeight;
    if (!CGRectEqualToRect(self.startRect, CGRectZero)) {
        top = CGRectGetMinY(targetFrame) < menuHeight + PopArrowSize.height + kStatusbarHeight;
    }
    
    if (top) {  // 上下间距控制
        if (!CGRectEqualToRect(self.startRect, CGRectZero)) {
            if (CGRectGetMaxY(_tempEndRect) + menuHeight + PopArrowSize.height > self.visibleHeight) {
                popFrame.origin.y = self.visibleHeight - menuHeight - spac;
            } else {
                popFrame.origin.y = MAX(CGRectGetMaxY(_tempEndRect), spac) + PopArrowSize.height;
            }
            popFrame.origin.x = CGRectGetMaxX(_tempEndRect) - _bottomSelectWidth / 2.0 - menuWidth / 2.0;
        } else {
            if (CGRectGetMaxY(targetFrame) + menuHeight + PopArrowSize.height > self.visibleHeight) {
                popFrame.origin.y = self.visibleHeight - menuHeight - spac;
            } else {
                popFrame.origin.y = targetFrame.origin.y + targetFrame.size.height + PopArrowSize.height;
            }
        }
    } else {
        if (!CGRectEqualToRect(self.startRect, CGRectZero)) {
            popFrame.origin.y = MIN(CGRectGetMinY(_tempStartRect) - menuHeight, self.visibleHeight-spac) - PopArrowSize.height;
            popFrame.origin.x = CGRectGetMinX(_tempStartRect) + _topSelectWidth / 2.0 - menuWidth / 2.0;
        } else {
            popFrame.origin.y = MIN(CGRectGetMinY(targetFrame) - menuHeight, self.visibleHeight-spac) - PopArrowSize.height;
        }
    }
    if (left) { // 左右边距控制
        popFrame.origin.x = MAX(popFrame.origin.x, spac);
    } else {
        popFrame.origin.x = MIN(popFrame.origin.x, PopScreenWidth-spac-menuWidth);
    }
    popFrame.origin.y = ceil(popFrame.origin.y);
    return popFrame;
}

- (CGRect)getArrowFrame
{
    CGRect targetFrame = self.targetViewFrame;
    CGFloat menuHeight = self.menuSize.height;
    BOOL top = CGRectGetMinY(targetFrame) < menuHeight + PopArrowSize.height + kStatusbarHeight;
    
    if (!CGRectEqualToRect(self.startRect, CGRectZero)) {
        top = CGRectGetMinY(targetFrame) < menuHeight + PopArrowSize.height + kStatusbarHeight;
    }
    
    CGRect arrowFrame = CGRectMake(0, 0, PopArrowSize.width, PopArrowSize.height);
    arrowFrame.origin.x = targetFrame.origin.x + targetFrame.size.width / 2.0 - arrowFrame.size.width / 2.0;
    
    
    if (top) {
        if (!CGRectEqualToRect(self.startRect, CGRectZero)) {
            if (CGRectGetMaxY(_tempEndRect) + menuHeight + PopArrowSize.height > self.visibleHeight) {
                arrowFrame.origin.y = self.visibleHeight - menuHeight - 10;
            } else {
                arrowFrame.origin.y = CGRectGetMaxY(_tempEndRect);
            }
            arrowFrame.origin.x = CGRectGetMaxX(_tempEndRect) - _bottomSelectWidth / 2.0 - arrowFrame.size.width / 2.0;
        } else {
            if (CGRectGetMaxY(targetFrame) + menuHeight + PopArrowSize.height > self.visibleHeight) {
                arrowFrame.origin.y = self.visibleHeight - menuHeight - PopArrowSize.height - 10;
            } else {
                arrowFrame.origin.y = targetFrame.origin.y + targetFrame.size.height;
            }
        }
    } else {
        if (!CGRectEqualToRect(self.startRect, CGRectZero)) {
            arrowFrame.origin.y = MIN(CGRectGetMinY(_tempStartRect), self.visibleHeight) - PopArrowSize.height;
            arrowFrame.origin.x = _tempStartRect.origin.x + _topSelectWidth / 2.0 - arrowFrame.size.width / 2.0;
        } else {
            arrowFrame.origin.y = targetFrame.origin.y - PopArrowSize.height;
        }
    }
    arrowFrame.origin.y = ceil(arrowFrame.origin.y);
    return arrowFrame;
}

- (void)setTargetView:(id)targetView {
    if (_targetView != targetView) {
        if ([targetView isKindOfClass:[UIView class]]) {
            _targetView = targetView;
        } else if ([targetView isKindOfClass:[UIBarButtonItem class]]) {
            if ([targetView customView]) {
                _targetView = [targetView customView];
            } else {
                NSAssert(1, @"Unsupport Type:Is not a View");
            }
        }
    }
}

+ (UIViewController *)vcForShowView:(id)view
{
    if ([view isKindOfClass:[UIView class]]) {
        for (UIView *next = [view superview]; next; next = next.superview) {
            UIResponder *nextResponder = next.nextResponder;
            if ([nextResponder isKindOfClass:[UIViewController class]]) {
                return (UIViewController *)nextResponder;
            }
        }
    } else if ([view isKindOfClass:[UIBarButtonItem class]]) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (window.windowLevel != UIWindowLevelNormal) {
            NSArray *windows = [UIApplication sharedApplication].windows;
            for (UIWindow *tempWin in windows) {
                if (tempWin.windowLevel == UIWindowLevelNormal) {
                    window = tempWin;
                    break;
                }
            }
        }
        UIView *frontView = [[window subviews] objectAtIndex:0];
        id nextResponder = [frontView nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        } else {
            return window.rootViewController;
        }
    }
    return nil;
}

#pragma mark - UICollectionView Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SJPopMenuItem * item = self.items[indexPath.row];
    item.index = indexPath.row;
    SJPopMenuCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SJPopMenuCollectionViewCell" forIndexPath:indexPath];
    [cell updateCellWithItem:item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.itemActions) {
        SJPopMenuItem *item = self.items[indexPath.row];
        self.itemActions(item.itemType, item.title);
        if (item.itemType != SJPopMenuItemSelectAll) {
            [self clearTextViewSelection:self.targetView];
            [self hideMenu];
        }
    }
}

@end

@implementation SJPopMenuItem

+ (instancetype)itemWithType:(SJPopMenuItemType)type title:(NSString *)title image:(NSString *)image
{
    SJPopMenuItem *item = [[SJPopMenuItem alloc] init];
    item.itemType = type;
    item.title = title;
    item.image = image;
    return item;
}

+ (instancetype)itemWithType:(SJPopMenuItemType)type
{
    SJPopMenuItem *item = [[SJPopMenuItem alloc] init];
    item.itemType = type;
    switch (type) {
        case SJPopMenuItemMutePlay: {
            item.title = @"静音播放";
            item.image = @"popmenu_mutePlay";
            break;
        }
        case SJPopMenuItemCopy: {
            item.title = @"复制";
            item.image = @"popmenu_copy";
            break;
        }
        case SJPopMenuItemWithdraw: {
            item.title = @"撤回";
            item.image = @"popmenu_withdraw";
            break;
        }
        case SJPopMenuItemDelete: {
            item.title = @"删除";
            item.image = @"popmenu_delete";
            break;
        }
        case SJPopMenuItemForwarding: {
            item.title = @"转发";
            item.image = @"popmenu_forwarding";
            break;
        }
        case SJPopMenuItemTranslate: {
            item.title = @"翻译";
            item.image = @"popmenu_translate";
            break;
        }
        case SJPopMenuItemQuote: {
            item.title = @"引用";
            item.image = @"popmenu_quote";
            break;
        }
        case SJPopMenuItemSave: {
            item.title = @"保存";
            item.image = @"popmenu_save";
            break;
        }
        case SJPopMenuItemDownload: {
            item.title = @"下载";
            item.image = @"popmenu_download";
            break;
        }
        case SJPopMenuItemMultipleChoice: {
            item.title = @"多选";
            item.image = @"popmenu_multipleChoice";
            break;
        }
        case SJPopMenuItemPackUp: {
            item.title = @"收起";
            item.image = @"popmenu_packUp";
            break;
        }
        case SJPopMenuItemRetranslation: {
            item.title = @"重译";
            item.image = @"popmenu_retranslation";
            break;
        }
        case SJPopMenuItemSelectAll: {
            item.title = @"全选";
            item.image = @"popmenu_selectAll";
            break;
        }
        case SJPopMenuItemRemind : {
            item.title = @"提醒";
            item.image = @"popmenu_remind";
            break;
        }
    }
    return item;
}

+ (instancetype)itemWithTitle:(NSString *)title image:(NSString *)image
{
    SJPopMenuItem *item = [[SJPopMenuItem alloc] init];
    item.title = title;
    item.image = image;
    return item;
}


@end
