#
# Be sure to run `pod lib lint UMUtils.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UMUtils'
  s.version          = '1.1.0'
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

  s.default_subspec = "Core"

  s.subspec 'Core' do |ss|
      ss.source_files = 'Sources/UMUtils/**/*.swift'
  end
  
  s.subspec 'UMMaterial' do |ss|
      ss.source_files = 'Sources/UMMaterial/**/*.swift'

      ss.dependency 'UMUtils/Core'
      ss.dependency 'Material', '~> 3.1.8'
      ss.dependency 'ConstraintBuilder', "~> 1.0.2"
  end
  
  s.subspec 'UMView' do |ss|
      ss.source_files = 'Sources/UMView/**/*.swift'

      ss.dependency 'UMUtils/Core'
      ss.dependency 'ConstraintBuilder', "~> 1.0.2"
      ss.dependency 'UIContainer', '~> 1.2.0-beta.9'
  end

  s.subspec 'RxUMUtils' do |ss|
      ss.source_files = 'Sources/RxUMUtils/*.swift'
      
      ss.dependency 'UMUtils/Core'
      ss.dependency 'RxSwift', '~> 5.0.0'
      ss.dependency 'RxCocoa', '~> 5.0.0'
  end

  s.subspec 'RxUMAIFlatSwitch' do |ss|
      ss.source_files = 'Sources/RxUMAIFlatSwitch/**/*.swift'

      ss.dependency 'UMUtils/RxUMUtils'
      ss.dependency 'AIFlatSwitch', "~> 1.0.7"
  end

  s.subspec 'RxUMActivity' do |ss|
      ss.source_files = 'Sources/RxUMActivity/**/*.swift'

      ss.dependency 'UMUtils/RxUMUtils'
      ss.dependency 'UIContainer', '~> 1.2.0-beta.9'
  end
  
  s.subspec 'UMViewModel' do |s|
      s.source_files = 'Sources/UMViewModel/**/*.swift'
      
      s.dependency 'UMUtils/Core'
  end

  s.subspec 'UMAPIModel' do |ss|
      ss.source_files = 'Sources/UMAPIModel/**/*.swift'
      ss.dependency 'Moya', "~> 14.0.0"
      ss.dependency 'RxSwift', '~> 5.0.0'
      ss.dependency 'RxCocoa', '~> 5.0.0'
  end

end
