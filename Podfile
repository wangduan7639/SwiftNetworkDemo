platform :ios, :deployment_target => "8.0"
use_frameworks!
link_with 'SwiftNetworkDemo', 'SwiftNetworkDemoTests'
#inhibit_all_warnings!

pod 'RxSwift', '~> 2.0.0-beta.2'
pod 'SFProgressHUD', '~> 0.1.1'
#网络请求库
pod 'Alamofire', '~> 3.1.2'
pod 'SnapKit', '~> 0.18.0'
pod 'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git'
pod 'JSONModel', '~> 1.1.2'

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_STRICT_OBJC_MSGSEND'] = 'NO'
        end
    end
end