Pod::Spec.new do |s|
  s.name         = 'Dropbox-Blocks'
  s.version      = '0.0.1'
  s.platform     =  :ios, '5.0'
  s.summary      = 'Blocks API for the Dropbox SDK'
  s.author       = { 'Andy Molloy' => 'amolloy@gmail.com' }
  s.source       = { :git => 'https://amolloy@bitbucket.org/amolloy/shared.git', :commit => '3d623fcbb2109b26b96e706b953ff716f1b516b7' }
  s.source_files = 'DBRestClient+Blocks.{h,m}'
  s.requires_arc = true
end
