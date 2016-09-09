#
#  Be sure to run `pod spec lint CYGAnalyseTool.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "CYGAnalyseTool"
  s.version      = "1.0.0"
  s.summary      = "Url请求结果展示工具"
  s.description  = <<-DESC
                   DESC

  s.homepage     = "https://github.com/Sasistx/CYGAnalyseTool"
  s.license      = "MIT (example)"
  s.author             = { "Sasistx" => "gaotianxiang@chunyu.me" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/Sasistx/CYGAnalyseTool.git", :tag => "s.version" }
  s.source_files  = "CYGAnalyseTool/Tools/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"
  s.weak_framework = 'CoreMotion'

end
