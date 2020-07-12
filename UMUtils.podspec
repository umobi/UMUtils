#
# Be sure to run `pod lib lint UMUtils.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UMUtils'
  s.version          = '1.3.0'
  s.summary          = "Utility Class Library"
  s.homepage         = 'https://github.com/umobi/UMUtils'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ramon Vicente' => 'ramon@umobi.com.br', 'brennobemoura' => 'brenno@umobi.com.br' }
  s.source           = { :git => 'https://github.com/umobi/UMUtils.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.swift_version = '5.2'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.dependency 'Material', '>= 3.0.0', "< 4.0.0"
  s.dependency 'ConstraintBuilder', '>= 2.0.0', "< 3.0.0"
  s.dependency 'UIContainer', '>= 2.1.0', "< 3.0.0"
  s.dependency 'UICreator', '>= 1.0.0', '< 2.0.0'
  s.dependency 'RxSwift', '>= 5.0.0', "< 6.0.0"
  s.dependency 'RxCocoa', '>= 5.0.0', "< 6.0.0"
  s.dependency 'AIFlatSwitch', ">= 1.0.7", "< 2.0.0"
  s.dependency 'Moya', ">= 14.0.0", "< 15.0.0"

end
