# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'

target 'GrausApp' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for GrausApp
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxFeedback', :git => 'https://github.com/kzaher/RxFeedback.git', :commit => '90306372483bc145d8b2d73f8943691235cb159d'
  pod 'RxDataSources', '~> 1.0'


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
