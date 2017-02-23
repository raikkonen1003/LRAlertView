
Pod::Spec.new do |s|

  s.name         = "LRAlertView"
  s.version      = "1.0.0"
  s.summary      = "自定义警告窗，有两种类型：AlertView、ActionSheet；可以做升级提示弹窗，删除选项，日期选择器等的弹窗。 "

  s.homepage     = "https://github.com/raikkonen1003/LRAlertView"
  

  s.license      = "MIT"
  

  s.author             = { "raikkonen1003" => "" }

  s.platform     = :ios, "7.0"

  s.ios.deployment_target = "7.0"

  s.source       = { :git => "https://github.com/raikkonen1003/LRAlertView.git", :tag => "#{s.version}" }

  s.source_files = "LRAlertView/LRAlertView/*.{h,m}"
  
  s.requires_arc = true


end
