#
# Be sure to run `pod lib lint UsingCoreBluetoothClassic5_iOS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UsingCoreBluetoothClassic5_iOS'
  s.version          = '1.1.4'
  s.summary          = '更新版本:1.1.4'
  s.swift_versions   = '5.0'
# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: xcode11.1没有iOS13的模拟器，以至于api13的方法会报错，所以code中注释掉来了。使用的话，把所有有关iOS的code，注释开即可.更新版本:1.1.4
                       DESC

  s.homepage         = 'https://github.com/huahuali/UsingCoreBluetoothClassic5_iOS'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '1245485258@qq.com' => 'shaohuali@bestechnic.com' }
  s.source           = { :git => 'https://github.com/huahuali/UsingCoreBluetoothClassic5_iOS.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'

  s.source_files = 'UsingCoreBluetoothClassic5_iOS/UsingCoreBluetoothClassic5_iOS/Classes/*.swift'
  
  # s.resource_bundles = {
  #   'UsingCoreBluetoothClassic5_iOS' => ['UsingCoreBluetoothClassic5_iOS/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
