source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '13.0'
use_frameworks!

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end

target 'USSD Tester' do
  pod 'Alamofire', '~> 5.2'
  pod 'NotificationBannerSwift', '~> 3.0.0'
end