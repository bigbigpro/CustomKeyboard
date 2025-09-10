# CustomKeyboard

[![CI Status](https://img.shields.io/travis/ext.jiangxielin1/CustomKeyboard.svg?style=flat)](https://travis-ci.org/ext.jiangxielin1/CustomKeyboard)
[![Version](https://img.shields.io/cocoapods/v/CustomKeyboard.svg?style=flat)](https://cocoapods.org/pods/CustomKeyboard)
[![License](https://img.shields.io/cocoapods/l/CustomKeyboard.svg?style=flat)](https://cocoapods.org/pods/CustomKeyboard)
[![Platform](https://img.shields.io/cocoapods/p/CustomKeyboard.svg?style=flat)](https://cocoapods.org/pods/CustomKeyboard)

## 简介

CustomKeyboard 是一个功能强大的 iOS 自定义键盘库，提供安全输入支持。支持字母、数字、符号三种键盘模式，具有现代化的 UI 设计和流畅的用户体验。

## 特性

- ✅ 支持字母、数字、符号三种键盘模式
- ✅ 现代化的 iOS 风格 UI 设计
- ✅ 安全键盘标题显示
- ✅ 完整的键盘功能（退格、空格、完成等）
- ✅ 流畅的键盘切换动画
- ✅ 易于集成和使用
- ✅ 支持 iOS 12.0+

## 示例

运行示例项目，请先克隆仓库，然后在 Example 目录下运行 `pod install`。

## 安装

CustomKeyboard 可通过 [CocoaPods](https://cocoapods.org) 安装。在 Podfile 中添加以下行：

```ruby
pod 'CustomKeyboard'
```

## 使用方法

### 基本使用

```objc
#import "CustomKeyboardViewController.h"

// 创建自定义键盘
CustomKeyboardViewController *customKeyboard = [[CustomKeyboardViewController alloc] initWithTitle:@"安全键盘"];
customKeyboard.delegate = self;

// 设置文本框的输入视图
textField.inputView = customKeyboard.view;
```

### 实现代理方法

```objc
#pragma mark - CustomKeyboardDelegate

- (void)customKeyboardDidTapKey:(NSString *)key {
    // 处理按键输入
    self.textField.text = [self.textField.text stringByAppendingString:key];
}

- (void)customKeyboardDidTapBackspace {
    // 处理退格
    if (self.textField.text.length > 0) {
        self.textField.text = [self.textField.text substringToIndex:self.textField.text.length - 1];
    }
}

- (void)customKeyboardDidTapSpace {
    // 处理空格
    self.textField.text = [self.textField.text stringByAppendingString:@" "];
}

- (void)customKeyboardDidTapDone {
    // 处理完成按钮
    [self.textField resignFirstResponder];
}

- (void)customKeyboardDidSwitchToNumbers {
    // 键盘切换到数字模式
    NSLog(@"切换到数字键盘");
}

- (void)customKeyboardDidSwitchToSymbols {
    // 键盘切换到符号模式
    NSLog(@"切换到符号键盘");
}
```

## 键盘布局

键盘采用标准的 QWERTY 布局，包含：

- **第一行**: q, w, e, r, t, y, u, i, o, p
- **第二行**: a, s, d, f, g, h, j, k, l
- **第三行**: 符, z, x, c, v, b, n, m, ⌫
- **功能行**: 123, 空格, 完成

## 作者

ext.jiangxielin1, ext.jiangxielin1@jd.com

## 许可证

CustomKeyboard 基于 MIT 许可证开源。详情请查看 LICENSE 文件。
