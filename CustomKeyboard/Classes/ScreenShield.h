#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 防截屏保护类 - Objective-C版本
 * 提供简单易用的API来保护视图内容不被截屏
 */
@interface ScreenShield : NSObject

/**
 * 单例方法
 * @return 防截屏保护实例
 */
+ (instancetype)shared;

/**
 * 为指定窗口启用防截屏保护
 * @param window 需要保护的窗口
 */
- (void)protectWithWindow:(UIWindow *)window;

/**
 * 为指定视图启用防截屏保护
 * @param view 需要保护的视图
 */
- (void)protectWithView:(UIView *)view;

/**
 * 移除指定视图的防截屏保护
 * @param view 需要移除保护的视图
 */
- (void)unprotectWithView:(UIView *)view;

/**
 * 启用屏幕录制保护（显示模糊遮罩）
 * @param blockingMessage 可选的自定义提示信息
 */
- (void)protectFromScreenRecording:(nullable NSString *)blockingMessage;

@end

/**
 * UIView的防截屏扩展
 */
@interface UIView (ScreenShield)

/**
 * 为当前视图设置防截屏保护
 */
- (void)setScreenCaptureProtection;

/**
 * 移除当前视图的防截屏保护
 */
- (void)unsetScreenCaptureProtection;

@end

NS_ASSUME_NONNULL_END
