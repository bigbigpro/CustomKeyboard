#import "ScreenShield.h"

// 防截屏保护的tag值
static const NSInteger kScreenShieldTag = 54321;

@interface ScreenShield ()
@property (nonatomic, strong, nullable) UIVisualEffectView *blurView;
@property (nonatomic, strong, nullable) id recordingObservation;
@property (nonatomic, copy) NSString *blockingScreenMessage;
@end

@implementation ScreenShield

+ (instancetype)shared {
    static ScreenShield *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ScreenShield alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _blockingScreenMessage = @"Screen recording not allowed";
    }
    return self;
}

#pragma mark - Public Methods

- (void)protectWithWindow:(UIWindow *)window {
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [window setScreenCaptureProtection];
//    });
}

- (void)protectWithView:(UIView *)view {
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [view setScreenCaptureProtection];
//    });
}

- (void)unprotectWithView:(UIView *)view {
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [view unsetScreenCaptureProtection];
//    });
}

- (void)protectFromScreenRecording:(nullable NSString *)blockingMessage {
    if (blockingMessage) {
        self.blockingScreenMessage = blockingMessage;
    }
    
    if (@available(iOS 11.0, *)) {
        [UIScreen.mainScreen addObserver:self
                              forKeyPath:@"isCaptured"
                                 options:NSKeyValueObservingOptionNew
                                 context:nil];
    }
}

#pragma mark - Private Methods

- (void)addBlurView {
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.frame = UIScreen.mainScreen.bounds;
    
    // 添加提示标签
    UILabel *label = [[UILabel alloc] init];
    label.text = self.blockingScreenMessage;
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textColor = [UIColor blackColor];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [blurView.contentView addSubview:label];
    
    [NSLayoutConstraint activateConstraints:@[
        [label.centerXAnchor constraintEqualToAnchor:blurView.contentView.centerXAnchor],
        [label.centerYAnchor constraintEqualToAnchor:blurView.contentView.centerYAnchor]
    ]];
    
    self.blurView = blurView;
    
    // 获取当前窗口并添加模糊视图
    UIWindow *keyWindow = nil;
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene *windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) {
                        keyWindow = window;
                        break;
                    }
                }
                if (keyWindow) break;
            }
        }
    } else {
        keyWindow = [UIApplication sharedApplication].keyWindow;
    }
    
    [keyWindow addSubview:blurView];
}

- (void)removeBlurView {
    [self.blurView removeFromSuperview];
    self.blurView = nil;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(nullable NSString *)keyPath
                      ofObject:(nullable id)object
                        change:(nullable NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(nullable void *)context {
    if ([keyPath isEqualToString:@"isCaptured"]) {
        BOOL isRecording = [change[NSKeyValueChangeNewKey] boolValue];
        if (isRecording) {
            [self addBlurView];
        } else {
            [self removeBlurView];
        }
    }
}

- (void)dealloc {
    [UIScreen.mainScreen removeObserver:self forKeyPath:@"isCaptured"];
}

@end

#pragma mark - UIView+ScreenShield

@implementation UIView (ScreenShield)

- (void)setScreenCaptureProtection {
    // 检查是否已经存在保护视图
    if ([self viewWithTag:kScreenShieldTag]) {
        NSLog(@"ScreenShield: 防截屏保护已存在，跳过添加");
        return;
    }
    
    // 如果没有父视图，递归处理所有子视图
    if (!self.superview) {
        for (UIView *subview in self.subviews) {
            [subview setScreenCaptureProtection];
        }
        return;
    }
    
    // 创建安全的UITextField
    UITextField *secureTextField = [[UITextField alloc] init];
    secureTextField.backgroundColor = [UIColor whiteColor];
    secureTextField.translatesAutoresizingMaskIntoConstraints = NO;
    secureTextField.tag = kScreenShieldTag;
    secureTextField.secureTextEntry = YES;
    secureTextField.userInteractionEnabled = NO;
    
    // 插入到最底层
    [self insertSubview:secureTextField atIndex:0];
    
    // 设置约束，填满整个视图
    [NSLayoutConstraint activateConstraints:@[
        [secureTextField.topAnchor constraintEqualToAnchor:self.topAnchor],
        [secureTextField.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [secureTextField.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [secureTextField.trailingAnchor constraintEqualToAnchor:self.trailingAnchor]
    ]];
    
    // 设置图层层次结构以实现防截屏
    if (self.layer.superlayer) {
        [self.layer.superlayer addSublayer:secureTextField.layer];
        if (secureTextField.layer.sublayers.lastObject) {
            [secureTextField.layer.sublayers.lastObject addSublayer:self.layer];
        }
    }
    
    NSLog(@"ScreenShield: 已添加防截屏保护");
}

- (void)unsetScreenCaptureProtection {
    // 查找防截屏的UITextField
    UITextField *secureTextField = (UITextField *)[self viewWithTag:kScreenShieldTag];
    if (secureTextField) {
        // 只是禁用安全文本输入，不移除UITextField
        secureTextField.secureTextEntry = NO;
        NSLog(@"ScreenShield: 已禁用防截屏保护");
    } else {
        // 如果没找到，尝试在父视图中查找
        UIView *parentView = self.superview;
        while (parentView && !secureTextField) {
            secureTextField = (UITextField *)[parentView viewWithTag:kScreenShieldTag];
            parentView = parentView.superview;
        }
        
        if (secureTextField) {
            secureTextField.secureTextEntry = NO;
            NSLog(@"ScreenShield: 已禁用防截屏保护（从父视图找到）");
        } else {
            NSLog(@"ScreenShield: 未找到防截屏保护，无需禁用");
        }
    }
}

@end
