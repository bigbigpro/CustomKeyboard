//
//  BBViewController.m
//  CustomKeyboard
//
//  Created by ext.jiangxielin1 on 09/10/2025.
//  Copyright (c) 2025 ext.jiangxielin1. All rights reserved.
//

#import "BBViewController.h"

@interface BBViewController ()

@end

@implementation BBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    [self setupCustomKeyboard];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"自定义键盘示例";
    
    // 创建文本输入框
    self.textField = [[UITextField alloc] init];
    self.textField.placeholder = @"点击这里使用自定义键盘";
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.font = [UIFont systemFontOfSize:16];
    self.textField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.textField];
    
    // 设置约束
    [NSLayoutConstraint activateConstraints:@[
        [self.textField.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:50],
        [self.textField.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.textField.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.textField.heightAnchor constraintEqualToConstant:50]
    ]];
    
    // 添加说明标签
    UILabel *instructionLabel = [[UILabel alloc] init];
    instructionLabel.text = @"这是一个自定义键盘的示例应用\n键盘支持字母、数字和符号输入\n点击文本框即可使用自定义键盘";
    instructionLabel.numberOfLines = 0;
    instructionLabel.textAlignment = NSTextAlignmentCenter;
    instructionLabel.font = [UIFont systemFontOfSize:14];
    instructionLabel.textColor = [UIColor grayColor];
    instructionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:instructionLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        [instructionLabel.topAnchor constraintEqualToAnchor:self.textField.bottomAnchor constant:30],
        [instructionLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [instructionLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20]
    ]];
    
    // 添加震动反馈开关
    UISwitch *hapticSwitch = [[UISwitch alloc] init];
    hapticSwitch.on = YES;
    hapticSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [hapticSwitch addTarget:self action:@selector(hapticSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:hapticSwitch];
    
    UILabel *hapticLabel = [[UILabel alloc] init];
    hapticLabel.text = @"震动反馈";
    hapticLabel.font = [UIFont systemFontOfSize:16];
    hapticLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:hapticLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        [hapticLabel.topAnchor constraintEqualToAnchor:instructionLabel.bottomAnchor constant:30],
        [hapticLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [hapticLabel.centerYAnchor constraintEqualToAnchor:hapticSwitch.centerYAnchor]
    ]];
    
    [NSLayoutConstraint activateConstraints:@[
        [hapticSwitch.topAnchor constraintEqualToAnchor:instructionLabel.bottomAnchor constant:30],
        [hapticSwitch.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20]
    ]];
}

- (void)setupCustomKeyboard {
    // 使用单例自定义键盘
    CustomKeyboardView *customKeyboard = [CustomKeyboardView sharedInstance];
    customKeyboard.delegate = self;
    
    // 启用震动反馈
    customKeyboard.hapticFeedbackEnabled = YES;
    
    // 确保键盘有正确的高度
    CGFloat keyboardHeight = 300;
    customKeyboard.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, keyboardHeight);
    
    // 设置文本框的输入视图为自定义键盘
    self.textField.inputView = customKeyboard;
    
    NSLog(@"自定义键盘已设置，高度: %.0f，震动反馈: %@", keyboardHeight, customKeyboard.hapticFeedbackEnabled ? @"启用" : @"禁用");
}

#pragma mark - CustomKeyboardDelegate

- (void)customKeyboardDidTapKey:(NSString *)key {
    self.textField.text = [self.textField.text stringByAppendingString:key];
}

- (void)customKeyboardDidTapBackspace {
    if (self.textField.text.length > 0) {
        self.textField.text = [self.textField.text substringToIndex:self.textField.text.length - 1];
    }
}

- (void)customKeyboardDidTapSpace {
    self.textField.text = [self.textField.text stringByAppendingString:@" "];
}

- (void)customKeyboardDidTapDone {
    [self.textField resignFirstResponder];
}

- (void)customKeyboardDidSwitchToNumbers {
    NSLog(@"切换到数字键盘");
}

- (void)customKeyboardDidSwitchToSymbols {
    NSLog(@"切换到符号键盘");
}

- (void)customKeyboardDidToggleCapsLock {
    NSLog(@"大小写切换");
}

- (void)hapticSwitchChanged:(UISwitch *)sender {
    CustomKeyboardView *customKeyboard = [CustomKeyboardView sharedInstance];
    customKeyboard.hapticFeedbackEnabled = sender.isOn;
    
    NSLog(@"震动反馈已%@", sender.isOn ? @"启用" : @"禁用");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 验证键盘是否正确设置
    if (self.textField.inputView) {
        NSLog(@"键盘已正确设置为自定义键盘");
        NSLog(@"键盘类型: %@", [self.textField.inputView class]);
        NSLog(@"键盘frame: %@", NSStringFromCGRect(self.textField.inputView.frame));
    } else {
        NSLog(@"警告：键盘未正确设置");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
