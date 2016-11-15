platform :ios, ‘9.3’
#use_frameworks!
 
target ’TimeTracker’ do
	use_frameworks!
	pod 'RealmSwift', '~> 2.0.2'
    	pod 'Charts'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = ‘2.3’
      end
    end
  end