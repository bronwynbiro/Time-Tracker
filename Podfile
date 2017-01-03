#platform :ios, ‘9.3’
 
target ’TimeTracker’ do
	use_frameworks!
	pod 'RealmSwift', '~> 2.0.2'
    pod 'Charts', :git => 'https://github.com/danielgindi/Charts.git', :branch => 'master'
    pod 'FCAlertView'
    
    
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
