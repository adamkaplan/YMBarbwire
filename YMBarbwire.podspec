#
# Be sure to run `pod lib lint YMBarbwire.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "YMBarbwire"
  s.version          = "0.0.1"
  s.summary          = "A short description of YMBarbwire."
  s.description      = <<-DESC
                       An optional longer description of YMBarbwire

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/adamkaplan/YMBarbwire"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "adamkaplan" => "adamkaplan@yahoo-inc.com" }
  s.source           = { :git => "https://github.com/adamkaplan/YMBarbwire.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/adkap'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'YMBarbwire/YMBarbwire.h'

  s.subspec 'asm' do |asm|
    asm.source_files = 'YMBarbwire/asm/*.s'
    asm.compiler_flags = '-fno-modules'
  end

  s.subspec 'no-arc' do |noarc|
    noarc.source_files = 'YMBarbwire/YMBarb.{m,h}'
    noarc.requires_arc = false
    noarc.compiler_flags = '-fno-objc-arc'
  end

  s.subspec 'core' do |core|
    core.dependency 'YMBarbwire/asm'
    core.dependency 'YMBarbwire/no-arc'

    core.source_files = 'YMBarbwire/YMBarbwire.m', 'YMBarbwire/YMBarbConfig.{m,h}'
  end

  s.subspec 'categories' do |sc|
    sc.dependency 'YMBarbwire/core'

    sc.ios.public_header_files = 'YMBarbwire/categories/*.h'
    sc.ios.source_files = 'YMBarbwire/categories'
    sc.osx.source_files = ''
  end

  #s.source_files = 'YMBarbwire'
  # s.resource_bundles = {
  #   'YMBarbwire' => ['YMBarbwire/*.png']
  # }

  # s.public_header_files = 'YMBarbwire/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
