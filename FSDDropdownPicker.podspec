#
# Be sure to run `pod lib lint FSDDropdownPicker.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "FSDDropdownPicker"
  s.version          = "0.5.0"
  s.summary          = "A dropdown picker component displayed from a UINavigationItem."
  s.description      = <<-DESC
                       A DropDownList displayed from a UINavigationItem.
                       * Set the items name and icons and the button will change accordingly

                       DESC
  s.homepage         = "https://github.com/felix-dumit/FSDDropdownPicker"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Felix Dumit" => "felix.dumit@gmail.com" }
  s.source           = { :git => "https://github.com/felix-dumit/FSDDropdownPicker.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/felix_dumit'

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
