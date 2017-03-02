
Pod::Spec.new do |s|

  s.name         = "LRAlertView"
  s.version      = "1.0.1"
  s.summary      = "自定义警告窗，有两种类型：AlertView、ActionSheet；可以做升级提示弹窗，删除选项，日期选择器等的弹窗。 "

  s.homepage     = "https://github.com/raikkonen1003/LRAlertView"
  

  s.license      = "MIT"
  

  s.author             = { "raikkonen1003" => "raikkonen1003@163.com" }

  s.platform     = :ios, "7.0"

  s.ios.deployment_target = "7.0"

  s.source       = { :git => "https://github.com/raikkonen1003/LRAlertView.git", :tag => s.version.to_s }

  s.source_files = "LRAlertView/*.{h,m}"
  
  s.requires_arc = true


end
