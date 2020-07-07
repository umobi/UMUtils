#
# Be sure to run `pod lib lint UMUtils.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UMUtils'
  s.version          = '1.2.0'
  s.summary          = "Utility Class Library"
  s.homepage         = 'https://github.com/umobi/UMUtils'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ramon Vicente' => 'ramon@umobi.com.br', 'brennobemoura' => 'brenno@umobi.com.br' }
  s.source           = { :git => 'https://github.com/umobi/UMUtils.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.watchos.deployment_target = '6.0'
  s.macos.deployment_target = '10.15'
  s.tvos.deployment_target = '13.0'
  s.swift_version = '5.2'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.dependency 'AIFlatSwitch', ">= 1.0.7", "< 2.0.0"

end
