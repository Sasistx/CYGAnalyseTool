Pod::Spec.new do |s|

  s.name         = "CYGAnalyseTool"
  s.version      = "1.0.7"
  s.summary      = "一些调试用工具"
  s.description  = "Url请求结果展示工具&UIDebuggingInformationOverlay"

  s.homepage     = "https://github.com/Sasistx/CYGAnalyseTool"
  s.license      = "MIT"
  s.author             = { "Sasistx" => "gaotianxiang@chunyu.me" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/Sasistx/CYGAnalyseTool.git", :tag => "s.version" }
  s.source_files  = "CYGAnalyseTool/Tools/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"
  s.weak_framework = 'CoreMotion'

end
