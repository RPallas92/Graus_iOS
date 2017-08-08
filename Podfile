# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'

target 'GrausApp' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for GrausApp
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxFeedback', :git => 'https://github.com/kzaher/RxFeedback.git', :tag => '0.2.0'
  pod 'RxDataSources', '~> 1.0'
  pod 'PINRemoteImage', '~> 2.1'
  pod 'Cache'


  target 'GrausAppTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'RxBlocking'
    pod 'RxTest'
    
  end

  target 'GrausAppUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
