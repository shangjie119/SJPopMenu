//
//  SJKeyboardManager.m
//  SJPopMenu
//
//  Created by sj on 2022/7/4.
//

#import "SJKeyboardManager.h"

@implementation SJKeyboardManager

+ (void)load
{
    [self sharedManager];
}

+ (instancetype)sharedManager {
    static SJKeyboardManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:sharedManager selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:sharedManager selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:sharedManager selector:@selector(keyBoardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    });
    return sharedManager;
}


- (void)keyBoardWillShow:(NSNotification *)noti
{
    CGRect kbFrame = [[noti userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboardHeight = kbFrame.size.height;
}

- (void)keyBoardWillHide:(NSNotification *)noti
{
    self.keyboardHeight = 0;
}

- (void)keyBoardWillChangeFrame:(NSNotification *)noti
{
    CGRect kbFrame = [[noti userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboardHeight = kbFrame.size.height;
}


@end
