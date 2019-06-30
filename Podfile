# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'SwiftRedux' do
  use_frameworks!

  # Pods for SwiftRedux
  pod 'RxSwift', '~> 4.0'
  pod 'RxBlocking', '~> 4.0'
  pod 'SwiftFP/Main', git: 'https://github.com/protoman92/SwiftFP.git'
  
  target 'SwiftReduxTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'RxBlocking', '~> 4.0'
    pod 'RxTest', '~> 4.0'
    pod 'SafeNest/Main', git: 'https://github.com/protoman92/SafeNest.git'
  end
  
  target 'SwiftRedux-Demo' do
    inherit! :search_paths
    # Pods for demo
    pod 'RxBlocking', '~> 4.0'
    pod 'SafeNest/Main', git: 'https://github.com/protoman92/SafeNest.git'
    pod 'SwiftFP/Main', git: 'https://github.com/protoman92/SwiftFP.git'
  end
  
  target 'SwiftRedux-MusicDemo' do
    inherit! :search_paths
    pod 'RxBlocking', '~> 4.0'
    pod 'SwiftFP/Main', git: 'https://github.com/protoman92/SwiftFP.git'
  end
end
