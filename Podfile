# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Load' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Load
  pod 'Alamofire'
  pod 'SwiftyJSON'
  pod 'AlamofireSwiftyJSON'
  pod 'NVActivityIndicatorView', '~> 4.7.0'
  pod 'SDWebImage'
  pod "KRPullLoader"
  pod 'ReachabilitySwift'
  pod 'IQKeyboardManagerSwift'
  pod 'MGSwipeTableCell'
  pod 'ObjectMapper'
  pod 'MaterialComponents/Snackbar'
  pod 'DropDown'
  pod 'CarbonKit'
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  pod 'GooglePlacePicker'
  pod 'FloatRatingView'
  pod 'JCTagListView'
  pod 'RangeSeekSlider'
  pod 'VENTokenField'
  pod 'Socket.IO-Client-Swift'
  pod 'BubblePictures'
  # pod 'CircleSlider' 
  pod 'Polyline'
  pod 'RealmSwift'
  pod 'XCDYouTubeKit'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/RemoteConfig'
  pod 'Firebase/Core'
  pod 'RxRelay'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'EasyPeasy'
  pod 'CountryPickerView'

  target 'LoadTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'LoadUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end

plugin 'cocoapods-patch'
