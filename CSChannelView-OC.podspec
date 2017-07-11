Pod::Spec.new do |s|
  s.name         = "CSChannelView-OC"
  s.version      = "0.0.1"
  s.summary      = "一个灵活的频道View"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { 'Joslyn' => 'cs_joslyn@foxmail.com' }
  s.homepage     = 'https://github.com/JoslynWu/CSChannelView-OC'
  s.social_media_url   = "http://www.jianshu.com/u/fb676e32e2e9"

  s.ios.deployment_target = '8.0'

  s.source       = { :git => 'https://github.com/JoslynWu/CSChannelView-OC.git', :tag => s.version}
  
  s.requires_arc = true
  s.source_files = 'Sources/*.{h,m}'
  s.public_header_files = 'Sources/*.{h}'

  s.dependency 'SDWebImage', '~> 4.0.0'

end
