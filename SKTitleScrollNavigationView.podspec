Pod::Spec.new do |s|
  s.name             = 'SKTitleScrollNavigationView'
  s.version          = '0.2.0'
  s.summary          = '滚动标题导航栏，支持红点气泡，可自定义下划线长度，支持居中及左对齐等'
  s.description      = <<-DESC
  Scroll title navigation bar, support red dot bubble, custom underline length, support centering and left alignment, etc.
                       DESC
  s.homepage         = 'https://github.com/shevakuilin/SKTitleScrollNavigationView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'shevakuilin' => 'shevakuilin@gmail.com' }
  s.source           = { :git => 'https://github.com/shevakuilin/SKTitleScrollNavigationView.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'Source/SKTitleScrollNavigationView/*.swift'
  s.swift_version = '4.1'
end
