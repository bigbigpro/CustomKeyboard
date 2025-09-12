//
//  CustomKeyboardView.h
//  CustomKeyboard
//
//  Created by ext.jiangxielin1 on 09/10/2025.
//  Copyright (c) 2025 ext.jiangxielin1. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@protocol CustomKeyboardDelegate <NSObject>

@optional
- (void)customKeyboardDidTapKey:(NSString *)key;
- (void)customKeyboardDidTapBackspace;
- (void)customKeyboardDidTapSpace;
- (void)customKeyboardDidTapDone;
- (void)customKeyboardDidSwitchToNumbers;
- (void)customKeyboardDidSwitchToSymbols;
- (void)customKeyboardDidToggleCapsLock;

@end

@interface CustomKeyboardView : UIView

@property (nonatomic, weak) id<CustomKeyboardDelegate> delegate;
@property (nonatomic, assign) BOOL showTitle; // 是否显示"安全键盘"标题
@property (nonatomic, assign) BOOL hapticFeedbackEnabled; // 是否启用震动反馈
@property (nonatomic, assign) BOOL randomKeysEnabled; // 是否启用随机按键
@property (nonatomic, assign) NSInteger currentKeyboardType; // 当前键盘类型
@property (nonatomic, assign) BOOL screenshotProtectionEnabled; // 是否启用截屏保护

+ (instancetype)sharedInstance;
- (instancetype)initWithTitle:(NSString *)title;
- (void)switchToKeyboardType:(NSInteger)keyboardType;
- (void)regenerateRandomKeys; // 重新生成随机按键

@end

NS_ASSUME_NONNULL_END
