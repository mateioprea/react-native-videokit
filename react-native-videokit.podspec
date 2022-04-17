require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))
fabric_enabled = ENV['RCT_NEW_ARCH_ENABLED']
folly_version = '2021.06.28.00-v2'
folly_compiler_flags = '-DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1 -Wno-comma -Wno-shorten-64-to-32'


Pod::Spec.new do |s|
  s.name         = "react-native-videokit"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]

  s.platforms    = { :ios => "11.0" }
  s.source       = { :git => "https://github.com/mateioprea/react-native-videokit.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m,mm}", "cpp/**/*.{h,cpp}"

  s.dependency "React-Core"
  s.dependency "Texture"

  if fabric_enabled
      s.pod_target_xcconfig = {
        'HEADER_SEARCH_PATHS' => '"$(PODS_ROOT)/boost" "$(PODS_ROOT)/boost-for-react-native"  "$(PODS_ROOT)/RCT-Folly"',
        "OTHER_CPLUSPLUSFLAGS" => "-DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1",
        "CLANG_CXX_LANGUAGE_STANDARD" => "c++17",
      }
      s.platforms       = { ios: '11.0', tvos: '11.0' }
      s.compiler_flags  = folly_compiler_flags
      s.source_files    = 'ios/**/*.{h,m,mm,cpp}'
      s.requires_arc    = true

      s.dependency "React"
      s.dependency "React-RCTFabric"
      s.dependency "React-Codegen"
      s.dependency "RCT-Folly", folly_version
      s.dependency "RCTRequired"
      s.dependency "RCTTypeSafety"
      s.dependency "ReactCommon/turbomodule/core"
  end
end
