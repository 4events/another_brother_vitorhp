#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint another_brother.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'another_brother_vitorhp'
  s.version          = '0.0.2'
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
  #s.xcconfig = { 'OTHER_LDFLAGS' => '-framework BRLMPrinterKit.framework' }
  #s.ios.vendored_frameworks = 'Lib/BRLMPrinterKit.framework'
  #s.vendored_frameworks = 'BRLMPrinterKit.framework'
    
  #s.ios.vendored_frameworks = 'Lib/BRPtouchPrinterKit.framework'
  #s.vendored_frameworks = 'BRPtouchPrinterKit.framework'
  
  #s.dependency 'BRLMPrinterKit'
  s.dependency 'BRLMPrinterKit_AB'
  s.dependency 'BROTHERSDK'
  
  #s.dependency 'BRLMPrinterKitBind'
  
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386', 'ENABLE_BITCODE' => 'NO' }
  s.swift_version = '5.0'

  s.user_target_xcconfig = {
    'ENABLE_BITCODE' => 'NO'
  }

  #s.subspec 'BRLMPrinterKit' do |br|
  #  br.source_files = 'Lib/BRLMPrinterKit.framework/**/*'
  #  br.public_header_files = 'Lib/BRLMPrinterKit.framework/**/*.h'
  #end
  
  #s.subspec 'BRLMPrinterKitBind' do |brBind|
  #  brBind.public_header_files = 'Classes/PtouchPrinterKit-Bridging-Header.h'
  #  brBind.dependency 'BRLMPrinterKit'
  #end

  s.script_phases = [{
    :name => 'Strip Bitcode from vendored frameworks (another_brother_vitorhp)',
    :execution_position => :after_compile,
    :shell_path => '/bin/sh',
    :script => <<-'SCRIPT'
  set -euo pipefail

  # Caminho do produto do target (quando este Pod é integrado dinamicamente)
  APP_FRAMEWORKS_DIR="${TARGET_BUILD_DIR}/${WRAPPER_NAME}/Frameworks"

  if [ -d "$APP_FRAMEWORKS_DIR" ]; then
    echo "== Stripping bitcode from embedded frameworks in $APP_FRAMEWORKS_DIR =="
    find "$APP_FRAMEWORKS_DIR" -type f \( -name "*.framework" -o -name "*.a" \) -print0 | while IFS= read -r -d '' ITEM; do
      BIN="$ITEM"
      # Se for .framework, o binário fica dentro com o mesmo nome do framework
      if [ "${ITEM##*.}" = "framework" ]; then
        FWNAME="$(basename "$ITEM" .framework)"
        BIN="$ITEM/$FWNAME"
      fi
      if file "$BIN" | grep -q "Mach-O"; then
        echo "Stripping bitcode: $BIN"
        xcrun bitcode_strip -r "$BIN" -o "$BIN" || true
      fi
    done
  fi
  SCRIPT
  }]

  
end
