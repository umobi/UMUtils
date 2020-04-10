#
# Be sure to run `pod lib lint UMUtils.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UMUtils'
  s.version          = '1.0.0'
  s.summary          = "Utility Class Library"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/umobi/UMUtils'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ramon Vicente' => 'ramon@umobi.com.br', 'brennobemoura' => 'brenno@umobi.com.br' }
  s.source           = { :git => 'https://github.com/umobi/UMUtils.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.swift_version = '5.1'
  
  s.source_files = 'UMUtils/Classes/**/*'

  s.subspec 'Core' do |ss|
      ss.source_files = 'UMUtils/Classes/Core/**/*.swift'
  end
  
  s.subspec 'Material' do |ss|
      ss.source_files = 'UMUtils/Classes/Material/**/*.swift'

      ss.dependency 'UMUtils/Core'
      ss.dependency 'Material'
      ss.dependency 'ConstraintBuilder'
  end
  
  s.subspec 'View' do |ss|
      ss.source_files = 'UMUtils/Classes/View/**/*.swift'

      ss.dependency 'UMUtils/Core'
      ss.dependency 'ConstraintBuilder'
      ss.dependency 'UIContainer', '~> 1.2.0-beta.6'
      ss.platform = :ios, '10.0'
  end

  s.subspec 'Rx' do |ss|
      ss.source_files = 'UMUtils/Classes/Rx/*.swift'
      
      ss.dependency 'UMUtils/Core'
      ss.dependency 'RxSwift', '4.5'
      ss.dependency 'RxCocoa', '4.5'
  end

  s.subspec 'AIFlatSwitch_Rx' do |ss|
      ss.source_files = 'UMUtils/Classes/Rx/AIFlatSwitch/**/*.swift'

      ss.dependency 'UMUtils/Rx'
      ss.dependency 'RxSwift', '4.5'
      ss.dependency 'RxCocoa', '4.5'
      ss.dependency 'AIFlatSwitch'
  end

  s.subspec 'Activity_Rx' do |ss|
      ss.source_files = 'UMUtils/Classes/Rx/Activity/**/*.swift'

      ss.dependency 'UMUtils/Rx'
      ss.dependency 'UIContainer', '~> 1.2.0-beta.6'
  end
  
  s.subspec 'ViewModel' do |s|
      s.source_files = 'UMUtils/Classes/ViewModel/**/*.swift'
      
      s.dependency 'UMUtils/Core'
  end

  s.subspec 'APIModel' do |ss|
      ss.source_files = 'UMUtils/Classes/APIModel/**/*.swift'
      ss.dependency 'Moya'
      ss.dependency 'RxSwift', '4.5'
      ss.dependency 'RxCocoa', '4.5'
  end

end
