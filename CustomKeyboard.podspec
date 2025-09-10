#
# Be sure to run `pod lib lint CustomKeyboard.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CustomKeyboard'
  s.version          = '0.1.0'
  s.summary          = 'A custom keyboard library for iOS with secure input support.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
CustomKeyboard 是一个功能强大的 iOS 自定义键盘库，提供安全输入支持。
支持字母、数字、符号三种键盘模式，具有现代化的 UI 设计和流畅的用户体验。
                       DESC

  s.homepage         = 'https://github.com/bigbigpro/CustomKeyboard'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'bigbigpro' => 'bigbigpro@163.com' }
  s.source           = { :git => 'https://github.com/bigbigpro/CustomKeyboard.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'

  s.source_files = 'CustomKeyboard/Classes/**/*'
  
  s.resource_bundles = {
    'CustomKeyboard' => ['CustomKeyboard/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
