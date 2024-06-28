#
# Be sure to run `pod lib lint EasyPay.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'EasyPay'
  s.version          = '0.9.72'
  s.summary          = 'Mobile iOS SDK for Easy Pay'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Easy-Pay-Solutions/Mobile-SDK-IOS'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Easy Pay Solutions' => 'ndraper@easypaysolutions.com' }
  s.source           = { :git => 'https://github.com/Easy-Pay-Solutions/Mobile-SDK-IOS.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.9'

  s.source_files = 'Sources/**/*.swift'
  
  s.resources = 'Sources/**/*.xib', 'Sources/EasyPay/Resources/*.ttf', 'Sources/EasyPay/Resources/EasyPayAssets.xcassets'

  s.resource_bundles = {
    'EasyPay' => [
        'Resources/EasyPayAssets.xcassets',
        'Resources/Fonts/*.ttf',
        'Sources/**/*.xib',
        ]
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Sentry', '~> 8.25.2'
end
