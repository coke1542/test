Pod::Spec.new do |s|

  s.name         = "YPScrollPageView"
  s.version      = "1.1.0"
  s.summary      = "YPScrollPageView."

  s.description  = <<-DESC
                    添加content刷新方法
                   DESC

  s.homepage     = "https://github.com/hz-wyp/YPScrollPageView"

  s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.author       = "wangyanping"

  s.platform     = :ios, "8.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/hz-wyp/YPScrollPageView.git", :tag => s.version.to_s }

  s.source_files  = "YPScrollPageView/YPScrollPageView/YPHeader.h"
  # s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"

#  s.resources  = "YPScrollPageView/YPScrollPageView/**/*.{storyboard,xib,png}"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true
  
  s.subspec 'other' do |ss|
      ss.source_files = 'YPScrollPageView/YPScrollPageView/other/*.{h,m}'
  end
  s.subspec 'config' do |ss|
      ss.source_files = 'YPScrollPageView/YPScrollPageView/config/*.{h,m}'
  end
  s.subspec 'view' do |ss|
      ss.dependency 'YPScrollPageView/YPScrollPageView/config','YPScrollPageView/YPScrollPageView/other'
      ss.source_files = 'YPScrollPageView/YPScrollPageView/view/*.{h,m}'
  end
  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
end
