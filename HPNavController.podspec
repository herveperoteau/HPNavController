Pod::Spec.new do |s|
  s.name     = 'HPNavController'
  s.version  = '1.0.0'
  s.license  = 'MIT'
  s.summary  = 'NavController like MailBox'
  s.author   = { 'Herve Peroteau' => 'herve.peroteau@gmail.com' }
  s.description = 'NavController like MailBox'
  s.platform = :ios
  s.ios.deployment_target = "7.0"
  s.source = { :git => "https://github.com/herveperoteau/HPNavController.git"}
  s.source_files = 'HPNavController'
  s.requires_arc = true
end
