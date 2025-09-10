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

+ (instancetype)sharedInstance;
- (instancetype)initWithTitle:(NSString *)title;
- (void)switchToKeyboardType:(NSInteger)keyboardType;

@end

NS_ASSUME_NONNULL_END
