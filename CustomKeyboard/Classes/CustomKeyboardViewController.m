//
//  CustomKeyboardViewController.m
//  CustomKeyboard
//
//  Created by ext.jiangxielin1 on 09/10/2025.
//  Copyright (c) 2025 ext.jiangxielin1. All rights reserved.
//

#import "CustomKeyboardViewController.h"

typedef NS_ENUM(NSInteger, KeyboardType) {
    KeyboardTypeLetters,
    KeyboardTypeNumbers,
    KeyboardTypeSymbols
};

typedef NS_ENUM(NSInteger, CapsLockState) {
    CapsLockStateOff,
    CapsLockStateOn,
    CapsLockStateCaps
};

@interface CustomKeyboardViewController ()

@property (nonatomic, strong) UIView *keyboardView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *keyboardContainer;
@property (nonatomic, assign) KeyboardType currentKeyboardType;
@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *letterKeys;
@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *numberKeys;
@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *symbolKeys;
@property (nonatomic, assign) CapsLockState capsLockState;
@property (nonatomic, strong) UIButton *capsLockButton;

@end

@implementation CustomKeyboardViewController

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        _showTitle = title.length > 0;
        [self setupKeyboardData];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupKeyboardData {
    // 字母键盘布局（小写）
    self.letterKeys = @[
        @[@"q", @"w", @"e", @"r", @"t", @"y", @"u", @"i", @"o", @"p"],
        @[@"a", @"s", @"d", @"f", @"g", @"h", @"j", @"k", @"l"],
        @[@"z", @"x", @"c", @"v", @"b", @"n", @"m"]
    ];
    
    // 数字键盘布局 - 根据效果图更新为3x4网格
    self.numberKeys = @[
        @[@"1", @"2", @"3"],
        @[@"4", @"5", @"6"],
        @[@"7", @"8", @"9"],
        @[@"符", @"ABC", @"0", @"⌫"]
    ];
    
    // 符号键盘布局 - 根据效果图更新
    self.symbolKeys = @[
        @[@"[", @"]", @"{", @"}", @"#", @"%", @"^", @"*", @"+", @"="],
        @[@"_", @"-", @"\\", @"|", @"~", @"«", @"»", @"¥", @"&", @"•"],
        @[@"123", @"...", @",", @"@", @"?", @"!", @"'", @".", @"⌫"]
    ];
    
    self.currentKeyboardType = KeyboardTypeLetters;
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.97 alpha:1.0];
    
    // 创建键盘容器
    self.keyboardView = [[UIView alloc] init];
    self.keyboardView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.97 alpha:1.0];
    [self.view addSubview:self.keyboardView];
    
    // 设置约束
    self.keyboardView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.keyboardView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.keyboardView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.keyboardView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.keyboardView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    // 添加标题
    if (self.showTitle) {
        [self setupTitleLabel];
    }
    
    // 创建键盘容器
    [self setupKeyboardContainer];
    
    // 创建键盘
    [self createKeyboard];
}

- (void)setupTitleLabel {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"安全键盘";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.titleLabel.textColor = [UIColor blackColor];
    [self.keyboardView addSubview:self.titleLabel];
    
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.keyboardView.topAnchor constant:10],
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.keyboardView.leadingAnchor],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.keyboardView.trailingAnchor],
        [self.titleLabel.heightAnchor constraintEqualToConstant:30]
    ]];
}

- (void)setupKeyboardContainer {
    self.keyboardContainer = [[UIView alloc] init];
    self.keyboardContainer.backgroundColor = [UIColor clearColor];
    [self.keyboardView addSubview:self.keyboardContainer];
    
    self.keyboardContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.keyboardContainer.topAnchor constraintEqualToAnchor:self.showTitle ? self.titleLabel.bottomAnchor : self.keyboardView.topAnchor constant:self.showTitle ? 10 : 20],
        [self.keyboardContainer.leadingAnchor constraintEqualToAnchor:self.keyboardView.leadingAnchor constant:8],
        [self.keyboardContainer.trailingAnchor constraintEqualToAnchor:self.keyboardView.trailingAnchor constant:-8],
        [self.keyboardContainer.bottomAnchor constraintEqualToAnchor:self.keyboardView.safeAreaLayoutGuide.bottomAnchor constant:-10]
    ]];
}

- (void)createKeyboard {
    // 清除现有键盘
    for (UIView *subview in self.keyboardContainer.subviews) {
        [subview removeFromSuperview];
    }
    
    NSArray<NSArray<NSString *> *> *currentKeys = [self getCurrentKeys];
    
    // 创建键盘行
    UIView *previousRow = nil;
    for (NSInteger rowIndex = 0; rowIndex < currentKeys.count; rowIndex++) {
        UIView *rowView = [self createKeyboardRow:currentKeys[rowIndex] rowIndex:rowIndex];
        [self.keyboardContainer addSubview:rowView];
        
        rowView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [rowView.leadingAnchor constraintEqualToAnchor:self.keyboardContainer.leadingAnchor],
            [rowView.trailingAnchor constraintEqualToAnchor:self.keyboardContainer.trailingAnchor],
            [rowView.heightAnchor constraintEqualToConstant:50]
        ]];
        
        if (previousRow) {
            [rowView.topAnchor constraintEqualToAnchor:previousRow.bottomAnchor constant:8].active = YES;
        } else {
            [rowView.topAnchor constraintEqualToAnchor:self.keyboardContainer.topAnchor].active = YES;
        }
        
        previousRow = rowView;
    }
    
    // 创建功能键行（数字键盘不需要）
    if (self.currentKeyboardType != KeyboardTypeNumbers) {
        [self createFunctionKeysRow:previousRow];
    }
}

- (UIView *)createKeyboardRow:(NSArray<NSString *> *)keys rowIndex:(NSInteger)rowIndex {
    UIView *rowView = [[UIView alloc] init];
    rowView.backgroundColor = [UIColor clearColor];
    
    // 特殊处理第三行（字母键盘和符号键盘的最后一行）
    if (self.currentKeyboardType == KeyboardTypeLetters && rowIndex == 2) {
        return [self createLetterKeyboardThirdRow:keys];
    } else if (self.currentKeyboardType == KeyboardTypeSymbols && rowIndex == 2) {
        return [self createSymbolKeyboardThirdRow:keys];
    } else if (self.currentKeyboardType == KeyboardTypeNumbers && rowIndex == 3) {
        return [self createNumberKeyboardFourthRow:keys];
    }
    
    // 计算按键宽度
    CGFloat totalSpacing = (keys.count - 1) * 6; // 按键间距
    CGFloat availableWidth = [UIScreen mainScreen].bounds.size.width - 16 - totalSpacing; // 减去左右边距和间距
    CGFloat keyWidth = availableWidth / keys.count;
    
    UIView *previousKey = nil;
    for (NSInteger keyIndex = 0; keyIndex < keys.count; keyIndex++) {
        NSString *keyText = keys[keyIndex];
        UIButton *keyButton = [self createKeyButton:keyText];
        [rowView addSubview:keyButton];
        
        keyButton.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [keyButton.topAnchor constraintEqualToAnchor:rowView.topAnchor],
            [keyButton.bottomAnchor constraintEqualToAnchor:rowView.bottomAnchor],
            [keyButton.widthAnchor constraintEqualToConstant:keyWidth]
        ]];
        
        if (previousKey) {
            [keyButton.leadingAnchor constraintEqualToAnchor:previousKey.trailingAnchor constant:6].active = YES;
        } else {
            [keyButton.leadingAnchor constraintEqualToAnchor:rowView.leadingAnchor].active = YES;
        }
        
        previousKey = keyButton;
    }
    
    return rowView;
}

- (UIView *)createLetterKeyboardThirdRow:(NSArray<NSString *> *)keys {
    UIView *rowView = [[UIView alloc] init];
    rowView.backgroundColor = [UIColor clearColor];
    
    // 创建大小写切换键 (⇧)
    self.capsLockButton = [self createCapsLockButton];
    [rowView addSubview:self.capsLockButton];
    
    // 创建字母键
    NSMutableArray *letterButtons = [NSMutableArray array];
    for (NSString *keyText in keys) {
        UIButton *keyButton = [self createKeyButton:keyText];
        [rowView addSubview:keyButton];
        [letterButtons addObject:keyButton];
    }
    
    // 创建退格键 (⌫)
    UIButton *backspaceButton = [self createKeyButton:@"⌫"];
    [rowView addSubview:backspaceButton];
    
    // 设置约束 - 根据效果图调整布局
    CGFloat specialKeyWidth = 50; // 特殊键宽度
    CGFloat totalSpacing = (keys.count + 1) * 6; // 按键间距
    CGFloat availableWidth = [UIScreen mainScreen].bounds.size.width - 16 - totalSpacing - specialKeyWidth * 2; // 减去左右边距、间距和特殊键宽度
    CGFloat letterKeyWidth = availableWidth / keys.count;
    
    // 大小写切换键
    self.capsLockButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.capsLockButton.topAnchor constraintEqualToAnchor:rowView.topAnchor],
        [self.capsLockButton.bottomAnchor constraintEqualToAnchor:rowView.bottomAnchor],
        [self.capsLockButton.leadingAnchor constraintEqualToAnchor:rowView.leadingAnchor],
        [self.capsLockButton.widthAnchor constraintEqualToConstant:specialKeyWidth]
    ]];
    
    // 字母键
    UIView *previousKey = self.capsLockButton;
    for (UIButton *keyButton in letterButtons) {
        keyButton.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [keyButton.topAnchor constraintEqualToAnchor:rowView.topAnchor],
            [keyButton.bottomAnchor constraintEqualToAnchor:rowView.bottomAnchor],
            [keyButton.leadingAnchor constraintEqualToAnchor:previousKey.trailingAnchor constant:6],
            [keyButton.widthAnchor constraintEqualToConstant:letterKeyWidth]
        ]];
        previousKey = keyButton;
    }
    
    // 退格键
    backspaceButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [backspaceButton.topAnchor constraintEqualToAnchor:rowView.topAnchor],
        [backspaceButton.bottomAnchor constraintEqualToAnchor:rowView.bottomAnchor],
        [backspaceButton.leadingAnchor constraintEqualToAnchor:previousKey.trailingAnchor constant:6],
        [backspaceButton.trailingAnchor constraintEqualToAnchor:rowView.trailingAnchor],
        [backspaceButton.widthAnchor constraintEqualToConstant:specialKeyWidth]
    ]];
    
    return rowView;
}

- (UIView *)createSymbolKeyboardThirdRow:(NSArray<NSString *> *)keys {
    UIView *rowView = [[UIView alloc] init];
    rowView.backgroundColor = [UIColor clearColor];
    
    // 创建123键
    UIButton *numberButton = [self createKeyButton:@"123"];
    [rowView addSubview:numberButton];
    
    // 创建符号键
    NSMutableArray *symbolButtons = [NSMutableArray array];
    for (NSString *keyText in keys) {
        if (![keyText isEqualToString:@"123"] && ![keyText isEqualToString:@"⌫"]) {
            UIButton *keyButton = [self createKeyButton:keyText];
            [rowView addSubview:keyButton];
            [symbolButtons addObject:keyButton];
        }
    }
    
    // 创建退格键
    UIButton *backspaceButton = [self createKeyButton:@"⌫"];
    [rowView addSubview:backspaceButton];
    
    // 设置约束 - 根据效果图调整布局
    CGFloat specialKeyWidth = 50; // 特殊键宽度
    CGFloat totalSpacing = (symbolButtons.count + 1) * 6; // 按键间距
    CGFloat availableWidth = [UIScreen mainScreen].bounds.size.width - 16 - totalSpacing - specialKeyWidth * 2; // 减去左右边距、间距和特殊键宽度
    CGFloat symbolKeyWidth = availableWidth / symbolButtons.count;
    
    // 123键
    numberButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [numberButton.topAnchor constraintEqualToAnchor:rowView.topAnchor],
        [numberButton.bottomAnchor constraintEqualToAnchor:rowView.bottomAnchor],
        [numberButton.leadingAnchor constraintEqualToAnchor:rowView.leadingAnchor],
        [numberButton.widthAnchor constraintEqualToConstant:specialKeyWidth]
    ]];
    
    // 符号键
    UIView *previousKey = numberButton;
    for (UIButton *keyButton in symbolButtons) {
        keyButton.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [keyButton.topAnchor constraintEqualToAnchor:rowView.topAnchor],
            [keyButton.bottomAnchor constraintEqualToAnchor:rowView.bottomAnchor],
            [keyButton.leadingAnchor constraintEqualToAnchor:previousKey.trailingAnchor constant:6],
            [keyButton.widthAnchor constraintEqualToConstant:symbolKeyWidth]
        ]];
        previousKey = keyButton;
    }
    
    // 退格键
    backspaceButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [backspaceButton.topAnchor constraintEqualToAnchor:rowView.topAnchor],
        [backspaceButton.bottomAnchor constraintEqualToAnchor:rowView.bottomAnchor],
        [backspaceButton.leadingAnchor constraintEqualToAnchor:previousKey.trailingAnchor constant:6],
        [backspaceButton.trailingAnchor constraintEqualToAnchor:rowView.trailingAnchor],
        [backspaceButton.widthAnchor constraintEqualToConstant:specialKeyWidth]
    ]];
    
    return rowView;
}

- (UIView *)createNumberKeyboardFourthRow:(NSArray<NSString *> *)keys {
    UIView *rowView = [[UIView alloc] init];
    rowView.backgroundColor = [UIColor clearColor];
    
    // 创建符键
    UIButton *symbolButton = [self createKeyButton:@"符"];
    [rowView addSubview:symbolButton];
    
    // 创建ABC键
    UIButton *abcButton = [self createKeyButton:@"ABC"];
    [rowView addSubview:abcButton];
    
    // 创建0键
    UIButton *zeroButton = [self createKeyButton:@"0"];
    [rowView addSubview:zeroButton];
    
    // 创建退格键
    UIButton *backspaceButton = [self createKeyButton:@"⌫"];
    [rowView addSubview:backspaceButton];
    
    // 设置约束 - 根据效果图调整布局：符+ABC+0+退格键
    CGFloat specialKeyWidth = 50; // 特殊键宽度
    CGFloat totalSpacing = 3 * 6; // 4个键之间有3个间距
    CGFloat availableWidth = [UIScreen mainScreen].bounds.size.width - 16 - totalSpacing - specialKeyWidth * 3; // 减去左右边距、间距和特殊键宽度
    CGFloat zeroKeyWidth = availableWidth; // 0键占据剩余宽度
    
    // 符键
    symbolButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [symbolButton.topAnchor constraintEqualToAnchor:rowView.topAnchor],
        [symbolButton.bottomAnchor constraintEqualToAnchor:rowView.bottomAnchor],
        [symbolButton.leadingAnchor constraintEqualToAnchor:rowView.leadingAnchor],
        [symbolButton.widthAnchor constraintEqualToConstant:specialKeyWidth]
    ]];
    
    // ABC键
    abcButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [abcButton.topAnchor constraintEqualToAnchor:rowView.topAnchor],
        [abcButton.bottomAnchor constraintEqualToAnchor:rowView.bottomAnchor],
        [abcButton.leadingAnchor constraintEqualToAnchor:symbolButton.trailingAnchor constant:6],
        [abcButton.widthAnchor constraintEqualToConstant:specialKeyWidth]
    ]];
    
    // 0键
    zeroButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [zeroButton.topAnchor constraintEqualToAnchor:rowView.topAnchor],
        [zeroButton.bottomAnchor constraintEqualToAnchor:rowView.bottomAnchor],
        [zeroButton.leadingAnchor constraintEqualToAnchor:abcButton.trailingAnchor constant:6],
        [zeroButton.widthAnchor constraintEqualToConstant:zeroKeyWidth]
    ]];
    
    // 退格键
    backspaceButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [backspaceButton.topAnchor constraintEqualToAnchor:rowView.topAnchor],
        [backspaceButton.bottomAnchor constraintEqualToAnchor:rowView.bottomAnchor],
        [backspaceButton.leadingAnchor constraintEqualToAnchor:zeroButton.trailingAnchor constant:6],
        [backspaceButton.trailingAnchor constraintEqualToAnchor:rowView.trailingAnchor],
        [backspaceButton.widthAnchor constraintEqualToConstant:specialKeyWidth]
    ]];
    
    return rowView;
}

- (UIButton *)createCapsLockButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = 8;
    button.layer.masksToBounds = YES;
    // 使用浅灰色背景，匹配效果图
    button.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
    
    // 设置大小写切换图标
    [self updateCapsLockButtonAppearance];
    
    [button addTarget:self action:@selector(capsLockButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)updateCapsLockButtonAppearance {
    if (!self.capsLockButton) return;
    
    // 根据当前大小写状态设置图标
    switch (self.capsLockState) {
        case CapsLockStateOff:
            // 显示小写图标
            [self.capsLockButton setImage:[self createCapsLockImage:NO] forState:UIControlStateNormal];
            break;
        case CapsLockStateOn:
            // 显示大写图标
            [self.capsLockButton setImage:[self createCapsLockImage:YES] forState:UIControlStateNormal];
            break;
        case CapsLockStateCaps:
            // 显示大写锁定图标
            [self.capsLockButton setImage:[self createCapsLockImage:YES] forState:UIControlStateNormal];
            break;
    }
}

- (UIImage *)createCapsLockImage:(BOOL)isUppercase {
    // 创建大小写切换图标 - 使用 ⇧ 符号
    CGSize size = CGSizeMake(20, 20);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(context, 2.0);
    
    // 绘制 ⇧ 符号
    // 绘制向上的箭头
    CGContextMoveToPoint(context, 10, 16); // 底部中心
    CGContextAddLineToPoint(context, 6, 8); // 左下
    CGContextAddLineToPoint(context, 8, 8); // 左横
    CGContextAddLineToPoint(context, 8, 4); // 左竖
    CGContextAddLineToPoint(context, 12, 4); // 上横
    CGContextAddLineToPoint(context, 12, 8); // 右竖
    CGContextAddLineToPoint(context, 14, 8); // 右横
    CGContextAddLineToPoint(context, 10, 16); // 回到底部中心
    
    CGContextStrokePath(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIButton *)createKeyButton:(NSString *)keyText {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 处理字母键的大小写
    NSString *displayText = keyText;
    if (self.currentKeyboardType == KeyboardTypeLetters && [self isLetter:keyText]) {
        if (self.capsLockState == CapsLockStateOff) {
            displayText = [keyText lowercaseString];
        } else {
            displayText = [keyText uppercaseString];
        }
    }
    
    [button setTitle:displayText forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    button.layer.cornerRadius = 8;
    button.layer.masksToBounds = YES;
    
    // 根据按键类型设置样式 - 匹配效果图
    if ([keyText isEqualToString:@"完成"]) {
        button.backgroundColor = [UIColor systemBlueColor];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else if ([keyText isEqualToString:@"符"] || [keyText isEqualToString:@"123"] || [keyText isEqualToString:@"ABC"] || [keyText isEqualToString:@"#+="]) {
        // 功能键使用浅灰色背景
        button.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } else if ([keyText isEqualToString:@"空格"]) {
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } else if ([keyText containsString:@"⌫"]) {
        // 退格键使用浅灰色背景
        button.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } else {
        // 字母键和符号键使用白色背景
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    // 添加点击效果
    [button addTarget:self action:@selector(keyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (BOOL)isLetter:(NSString *)text {
    if (text.length != 1) return NO;
    unichar character = [text characterAtIndex:0];
    return (character >= 'a' && character <= 'z') || (character >= 'A' && character <= 'Z');
}

- (void)createFunctionKeysRow:(UIView *)previousRow {
    UIView *functionRow = [[UIView alloc] init];
    functionRow.backgroundColor = [UIColor clearColor];
    [self.keyboardContainer addSubview:functionRow];
    
    functionRow.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [functionRow.leadingAnchor constraintEqualToAnchor:self.keyboardContainer.leadingAnchor],
        [functionRow.trailingAnchor constraintEqualToAnchor:self.keyboardContainer.trailingAnchor],
        [functionRow.topAnchor constraintEqualToAnchor:previousRow.bottomAnchor constant:8],
        [functionRow.heightAnchor constraintEqualToConstant:50]
    ]];
    
    // 根据键盘类型创建不同的功能键
    NSArray *functionKeys;
    NSArray *keyWidths;
    
    if (self.currentKeyboardType == KeyboardTypeSymbols) {
        // 符号键盘功能键：ABC + 空格 + 完成
        functionKeys = @[@"ABC", @"空格", @"完成"];
        CGFloat totalSpacing = 2 * 6; // 3个键之间有2个间距
        CGFloat availableWidth = [UIScreen mainScreen].bounds.size.width - 16 - totalSpacing;
        
        CGFloat smallKeyWidth = 50; // ABC键的宽度
        CGFloat spaceKeyWidth = availableWidth - smallKeyWidth * 2; // 空格键宽度
        CGFloat doneKeyWidth = smallKeyWidth; // 完成键宽度
        
        keyWidths = @[@(smallKeyWidth), @(spaceKeyWidth), @(doneKeyWidth)];
    } else {
        // 字母键盘功能键：符 + 123 + 空格 + 完成
        functionKeys = @[@"符", @"123", @"空格", @"完成"];
        CGFloat totalSpacing = 3 * 6; // 4个键之间有3个间距
        CGFloat availableWidth = [UIScreen mainScreen].bounds.size.width - 16 - totalSpacing;
        
        // 计算按键宽度：符和123使用相同宽度，空格更宽，完成使用相同宽度
        CGFloat smallKeyWidth = 50; // 符和123的宽度
        CGFloat spaceKeyWidth = availableWidth - smallKeyWidth * 3; // 空格键宽度
        CGFloat doneKeyWidth = smallKeyWidth; // 完成键宽度
        
        keyWidths = @[@(smallKeyWidth), @(smallKeyWidth), @(spaceKeyWidth), @(doneKeyWidth)];
    }
    
    for (NSInteger i = 0; i < functionKeys.count; i++) {
        NSString *keyText = functionKeys[i];
        UIButton *button = [self createKeyButton:keyText];
        [functionRow addSubview:button];
        
        CGFloat currentKeyWidth = [keyWidths[i] floatValue];
        
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [button.topAnchor constraintEqualToAnchor:functionRow.topAnchor],
            [button.bottomAnchor constraintEqualToAnchor:functionRow.bottomAnchor],
            [button.widthAnchor constraintEqualToConstant:currentKeyWidth]
        ]];
        
        if (i == 0) {
            [button.leadingAnchor constraintEqualToAnchor:functionRow.leadingAnchor].active = YES;
        } else {
            [button.leadingAnchor constraintEqualToAnchor:functionRow.subviews[i-1].trailingAnchor constant:6].active = YES;
        }
    }
}

- (NSArray<NSArray<NSString *> *> *)getCurrentKeys {
    switch (self.currentKeyboardType) {
        case KeyboardTypeLetters:
            return self.letterKeys;
        case KeyboardTypeNumbers:
            return self.numberKeys;
        case KeyboardTypeSymbols:
            return self.symbolKeys;
    }
}

- (void)keyButtonTapped:(UIButton *)sender {
    NSString *keyText = sender.titleLabel.text;
    
    if ([keyText isEqualToString:@"完成"]) {
        if ([self.delegate respondsToSelector:@selector(customKeyboardDidTapDone)]) {
            [self.delegate customKeyboardDidTapDone];
        }
    } else if ([keyText isEqualToString:@"空格"]) {
        if ([self.delegate respondsToSelector:@selector(customKeyboardDidTapSpace)]) {
            [self.delegate customKeyboardDidTapSpace];
        }
    } else if ([keyText isEqualToString:@"123"]) {
        self.currentKeyboardType = KeyboardTypeNumbers;
        [self createKeyboard];
        if ([self.delegate respondsToSelector:@selector(customKeyboardDidSwitchToNumbers)]) {
            [self.delegate customKeyboardDidSwitchToNumbers];
        }
    } else if ([keyText isEqualToString:@"ABC"]) {
        self.currentKeyboardType = KeyboardTypeLetters;
        [self createKeyboard];
    } else if ([keyText isEqualToString:@"符"]) {
        self.currentKeyboardType = KeyboardTypeSymbols;
        [self createKeyboard];
        if ([self.delegate respondsToSelector:@selector(customKeyboardDidSwitchToSymbols)]) {
            [self.delegate customKeyboardDidSwitchToSymbols];
        }
    } else if ([keyText isEqualToString:@"#+="]) {
        self.currentKeyboardType = KeyboardTypeSymbols;
        [self createKeyboard];
    } else if ([keyText containsString:@"⌫"]) {
        if ([self.delegate respondsToSelector:@selector(customKeyboardDidTapBackspace)]) {
            [self.delegate customKeyboardDidTapBackspace];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(customKeyboardDidTapKey:)]) {
            [self.delegate customKeyboardDidTapKey:keyText];
        }
    }
}

- (void)capsLockButtonTapped:(UIButton *)sender {
    // 切换大小写状态
    switch (self.capsLockState) {
        case CapsLockStateOff:
            self.capsLockState = CapsLockStateOn;
            break;
        case CapsLockStateOn:
            self.capsLockState = CapsLockStateCaps;
            break;
        case CapsLockStateCaps:
            self.capsLockState = CapsLockStateOff;
            break;
    }
    
    // 更新大小写切换按钮外观
    [self updateCapsLockButtonAppearance];
    
    // 重新创建键盘以更新字母显示
    if (self.currentKeyboardType == KeyboardTypeLetters) {
        [self createKeyboard];
    }
    
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(customKeyboardDidToggleCapsLock)]) {
        [self.delegate customKeyboardDidToggleCapsLock];
    }
}

@end
