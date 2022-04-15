#import "BadgeManagerPlugin.h"
#if __has_include(<badge_manager/badge_manager-Swift.h>)
#import <badge_manager/badge_manager-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "badge_manager-Swift.h"
#endif

@implementation BadgeManagerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBadgeManagerPlugin registerWithRegistrar:registrar];
}
@end
