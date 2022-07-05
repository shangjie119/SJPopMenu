//
//  SJKeyboardManager.h
//  SJPopMenu
//
//  Created by sj on 2022/7/4.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SJKeyboardManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, assign) CGFloat keyboardHeight;

@end

NS_ASSUME_NONNULL_END
