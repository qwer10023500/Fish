# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'
inhibit_all_warnings!

target 'Fishs' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for Fishs
  pod 'Moya' # Network
  
  pod 'Kingfisher' # Network Image
  
  pod 'MJRefresh' # Refresh
  
  pod 'RxSwift' # Reactive
  pod 'RxCocoa' # Reactive
  pod 'NSObject+Rx' # Reactive
  
  pod 'SnapKit' # AutoLayout
  
  pod 'R.swift' # Resource
  
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '5.0'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
    end
  end
end
