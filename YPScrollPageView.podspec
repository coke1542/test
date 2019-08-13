Pod::Spec.new do |s|

  s.name         = "YPScrollPageView"
  s.version      = "1.0.2"
  s.summary      = "YPScrollPageView."

  s.description  = <<-DESC
    YPScrollPageView 1.0.2 版本-公测
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

  s.source_files  = "YPScrollPageView/YPScrollPageView/**/*.{h,m,swift}"
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

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

end
