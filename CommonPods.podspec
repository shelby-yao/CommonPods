#
# Be sure to run `pod lib lint CommonPods.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CommonPods'
  s.version          = '0.0.5'
  s.summary          = 'A short description of CommonPods.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC
   s.source = 'https://github.com/CocoaPods/Specs.git'

  s.homepage         = 'https://github.com/shelby-yao/CommonPods'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'shelby-yao' => 'shelby_yao@163.com' }
  s.source           = { :git => 'https://github.com/shelby-yao/CommonPods.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

   s.ios.deployment_target = '10.0'
s.swift_version = '5.0'

  s.source_files = 'CommonPods/Classes/**/*.{h,m,swift}', 'CommonPods/BClasses/**/*.{h,m,swift}'
   s.public_header_files = 'CommonPods/Classes/**/*.h', 'CommonPods/BClasses/**/*.h'
   s.resources = 'CommonPods/Classes/TZImagePickerController.bundle', 'CommonPods/BClasses/business.bundle', 'CommonPods/BClasses/keyboard.bundle'
   s.dependency 'JKUIViewExtension', '~>0.0.3'
   s.dependency 'JKAlertTransition', '0.0.1'
   s.dependency 'SnapKit' , '4.2.0'
   s.dependency 'RxSwift' , '5.1.0'
   s.dependency 'RxCocoa' , '5.1.0'
   #s.dependency 'RxDataSources', '4.0.1'
   s.dependency 'JKNetwork' , '0.0.6'
   s.dependency 'Toast-Swift', '4.0.1'
   s.dependency 'FDFullscreenPopGesture', '1.1'
   s.dependency 'MJRefresh' , '3.2.3'
   s.dependency 'Swinject'

    
    s.dependency 'TZImagePreviewController' , '0.3.0'
    s.dependency 'YYCategories'
end
