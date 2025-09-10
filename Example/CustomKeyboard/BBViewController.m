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
}

- (void)setupCustomKeyboard {
    // 创建自定义键盘
    self.customKeyboard = [[CustomKeyboardViewController alloc] initWithTitle:@"安全键盘"];
    self.customKeyboard.delegate = self;
    
    // 设置文本框的输入视图为自定义键盘
    self.textField.inputView = self.customKeyboard.view;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
