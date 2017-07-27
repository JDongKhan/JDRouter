Pod::Spec.new do |spec|
  spec.name         = 'JDRouter'
  spec.version      = '1.2.3'
  spec.summary      = 'JD'
  spec.description  = <<-DESC
			JDRouter
                      DESC

  spec.homepage     = "https://github.com/wangjindong"
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author       = { "wangjindong" => "419591321@qq.com" }
  spec.social_media_url   = "http://twitter.com/wjd"
  spec.source       = { :git => "https://github.com/wangjindong/JDRouter.git", :tag => s.version.to_s }

  spec.platform = :ios,'7.0'

  spec.source_files = 'Framework/**/*.{h,m,mm}'
  #spec.resource = 'Framework/**/*.{png,xib,plist}'

  spec.requires_arc = true
  spec.ios.deployment_target = '7.0'
  
  spec.public_header_files = 'Framework/**/*.h'

  #依赖关系，该项目所依赖的其他库，如果有多个需要填写多个spec.dependency

end