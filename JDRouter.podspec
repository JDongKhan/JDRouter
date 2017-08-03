

Pod::Spec.new do |s|

  s.name         = "JDRouter"
  s.version      = "1.2.9"
  s.summary      = "JDRouter"

  s.description  = <<-DESC
			JDRouter
                   DESC

  s.homepage     = "https://github.com/wangjindong/JDRouter.git"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.author             = { "wangjindong" => "419591321@qq.com" }
  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/wangjindong/JDRouter.git", :tag => s.version.to_s }

  s.subspec 'Intent' do |ss|
    ss.source_files = 'Intent/**/*.{h,m}'
    ss.public_header_files = 'Intent/**/*.h'
  end

  s.subspec 'Router' do |cc|
    cc.source_files = 'Router/**/*.{h,m}'
    cc.public_header_files = 'Router/**/*.h'
  end

 s.subspec 'Protocol' do |cc|
    cc.source_files = 'Protocol/**/*.{h,m}'
    cc.public_header_files = 'Protocol/**/*.h'
  end

  s.frameworks = 'Foundation', 'UIKit'
  s.requires_arc = true

 
end
