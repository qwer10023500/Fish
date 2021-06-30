# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'
inhibit_all_warnings!

target 'Fish' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for Fish
  
  pod 'Alamofire' # Network
  
  pod 'RxSwift' # Reactive
  pod 'RxCocoa' # Reactive
  pod 'NSObject+Rx' # Reactive
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '5.0'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
    end
  end
end
