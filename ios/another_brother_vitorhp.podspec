#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint another_brother.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'another_brother_vitorhp'
  s.version          = '0.0.5'
  s.summary          = 'A flutter plugin project for printing using the Brother printers.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Rounin Labs' => 'hernandez.f@rouninlabs.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'#, 'Classes/PtouchPrinterKit-Bridging-Header.h'

  
  #s.preserve_paths = 'Lib/BRLMPrinterKit.framework'
  # s.xcconfig = { 'OTHER_LDFLAGS' => '-framework BRLMPrinterKit.framework' }
  # s.ios.vendored_frameworks = 'Lib/BRLMPrinterKit.framework'
  #s.vendored_frameworks = 'BRLMPrinterKit.framework'

  s.vendored_frameworks = 'Frameworks/BRLMPrinterKit.framework' # ou .framework
    
  #s.ios.vendored_frameworks = 'Lib/BRPtouchPrinterKit.framework'
  #s.vendored_frameworks = 'BRPtouchPrinterKit.framework'
  
  #s.dependency 'BRLMPrinterKit'
  s.dependency 'BRLMPrinterKit_AB'
  s.dependency 'BROTHERSDK'
  
  #s.dependency 'BRLMPrinterKitBind'
  
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386', 'ENABLE_BITCODE' => 'NO' }
  s.swift_version = '5.0'

  s.user_target_xcconfig = {
    'ENABLE_BITCODE' => 'NO'
  }

  # (A) Remover bitcode do artefato vendorizado NA INSTALAÇÃO DO POD
  s.prepare_command = <<-CMD
set -e
if [ -d "Frameworks/BRLMPrinterKit.xcframework" ]; then
  find "Frameworks/BRLMPrinterKit.xcframework" -type f -perm -111 -name "BRLMPrinterKit" -print0 | xargs -0 -I{} sh -c 'xcrun bitcode_strip -r "{}" -o "{}" || true'
fi
if [ -d "Frameworks/BRLMPrinterKit.framework" ]; then
  BIN="Frameworks/BRLMPrinterKit.framework/BRLMPrinterKit"
  [ -f "$BIN" ] && xcrun bitcode_strip -r "$BIN" -o "$BIN" || true
fi
  CMD

  # (B) Cinto e suspensório: strip também APÓS a compilação do Pod
  s.script_phases = [{
    :name => 'Strip bitcode (another_brother_vitorhp)',
    :execution_position => :after_compile,
    :shell_path => '/bin/sh',
    :script => <<-'SCRIPT'
set -e
APP_FW_DIR="${TARGET_BUILD_DIR}/${WRAPPER_NAME}/Frameworks"
if [ -d "$APP_FW_DIR" ]; then
  find "$APP_FW_DIR" -type d -name "*.framework" | while read -r FW; do
    BIN="$FW/$(basename "$FW" .framework)"
    if file "$BIN" | grep -q "Mach-O"; then
      xcrun bitcode_strip -r "$BIN" -o "$BIN" || true
    fi
  done
  find "$APP_FW_DIR" -type f -name "*.a" | while read -r LIB; do
    xcrun bitcode_strip -r "$LIB" -o "$LIB" || true
  done
fi
SCRIPT
  }]

  
end
