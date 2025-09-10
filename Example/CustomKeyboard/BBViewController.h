//
//  BBViewController.h
//  CustomKeyboard
//
//  Created by ext.jiangxielin1 on 09/10/2025.
//  Copyright (c) 2025 ext.jiangxielin1. All rights reserved.
//

@import UIKit;
#import "CustomKeyboardViewController.h"

@interface BBViewController : UIViewController <CustomKeyboardDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) CustomKeyboardViewController *customKeyboard;

@end
