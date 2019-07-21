Pod::Spec.new do |s|
  s.name         = "PTBaseKit"
  s.version      = "0.2.1"
  s.summary      = "便利iOS开发的封装s"
  s.description  = "thinker 轮子集合"
  s.homepage     = "https://github.com/p36348/PTBaseKit.git"
  s.license      = "Apache License, Version 2.0"
  s.author       = { "Oreo" => "p36348@gmail.com" }
  s.platform     = :ios
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/p36348/PTBaseKit.git", :branch => 'master', :tag => "#{s.version}" }
  s.source_files  = "PTBaseKit/Source/*.swift", "PTBaseKit/Source/**/*.swift"

  s.dependency 'SnapKit'
  s.dependency 'RxCocoa'
  s.dependency 'RxSwift'
  s.dependency 'MJRefresh'
  s.dependency 'Kingfisher', '~> 4.10.1' 
  s.dependency 'IGListKit'
end
