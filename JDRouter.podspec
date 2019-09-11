

Pod::Spec.new do |s|

  s.name         = "JDRouter"
  s.version      = '2.0.0' 
  s.summary      = "JDRouter"

  s.description  = <<-DESC
			JDRouter
                   DESC

  s.homepage     = "https://github.com/JDongKhan/JDRouter.git"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.author             = { "wangjindong" => "419591321@qq.com" }
  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/JDongKhan/JDRouter.git", :tag => s.version.to_s }

  s.subspec 'Intent' do |ss|
    ss.source_files = 'Sources/Intent/*.{h,m}'
    ss.public_header_files = 'Sources/Intent/*.h'
  end

  s.subspec 'Annotation' do |cc|
    cc.source_files = 'Sources/Annotation/*.{h,m}'
    cc.public_header_files = 'Sources/Annotation/*.h'
  end

  s.frameworks = 'Foundation', 'UIKit'
  s.requires_arc = true

 
end
