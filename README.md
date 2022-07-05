# SJPopMenu

[![CI Status](https://img.shields.io/travis/sj/SJPopMenu.svg?style=flat)](https://travis-ci.org/sj/SJPopMenu)
[![Version](https://img.shields.io/cocoapods/v/SJPopMenu.svg?style=flat)](https://cocoapods.org/pods/SJPopMenu)
[![License](https://img.shields.io/cocoapods/l/SJPopMenu.svg?style=flat)](https://cocoapods.org/pods/SJPopMenu)
[![Platform](https://img.shields.io/cocoapods/p/SJPopMenu.svg?style=flat)](https://cocoapods.org/pods/SJPopMenu)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

SJPopMenu is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SJPopMenu'
```

## SJPopMenu使用方法：
1. 显示： [[SJPopMenu menu] showBy:xxxxxx]
2. 需实现 SJCustomSelectTextView 里面方法，如果是自定义textView，只需将 SJCustomSelectTextView 的父类改为项目使用的textView即可
3. controller中需实现3个方法并且发送通知，使滚动时正确显示menu
```
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SJChangePopMenuIfNeeded" object:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SJShowPopMenuIfNeeded" object:nil];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SJShowPopMenuIfNeeded" object:nil];
    }
}
```
4. 点击menu action回调使用 menu.itemActions 

## Author

sj, shangjie@dogesoft.cn

## License

SJPopMenu is available under the MIT license. See the LICENSE file for more info.
