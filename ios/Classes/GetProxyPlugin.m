#import "GetProxyPlugin.h"
#import <get_proxy/get_proxy-Swift.h>

@implementation GetProxyPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftGetProxyPlugin registerWithRegistrar:registrar];
}
@end
