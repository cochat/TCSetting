Pod::Spec.new do |s|
  s.name         = "RHSetting"
  s.version      = "1.2.1.7"
  
  s.summary      = "用于App的设置页面，简单、实用、美观"
  s.homepage     = "https://github.com/cochat/TCSetting"
  s.license      = "Apache"
  s.author             = { "ichensheng" => "cs200521@163.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/cochat/TCSetting.git", :tag => "#{s.version}" }
  s.source_files  = "TCSetting/TCSetting/*.{h,m}"
  s.requires_arc = true
  s.dependency "Masonry", "~> 1.1.0"
	s.dependency "TCTools", "~> 0.1.16"
end
