Pod::Spec.new do |s|
  s.name         = "PTBaseKit"
  s.version      = "0.2.0"
  s.summary      = "便利iOS开发的封装s"
  s.description  = "在thinker vc工作期间, 为了方便同时更新维护多个项目, 把一些通用和标准化了的内容封装起来."
  s.homepage     = "https://github.com/p36348/PTBaseKit.git"
  s.license      = "Apache License, Version 2.0"
  s.author       = { "Oreo" => "p36348@gmail.com" }
  s.platform     = :ios
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/p36348/PTBaseKit.git", :branch => 'master', :tag => "#{s.version}" }
  s.source_files  = "PTBaseKit/Source/*.swift", "PTBaseKit/Source/**/*.swift"

  s.dependency 'SnapKit', '~> 3.0.0'
  s.dependency 'RxCocoa'
  s.dependency 'RxSwift'
  s.dependency 'MJRefresh'
  s.dependency 'MBProgressHUD'
  s.dependency 'Kingfisher'
end
