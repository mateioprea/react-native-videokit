#import <React/RCTViewManager.h>

@interface VideoKitViewManager : RCTViewManager
@end

@implementation VideoKitViewManager

RCT_EXPORT_MODULE(VideoView)


+ (BOOL)requiresMainQueueSetup
{
  return YES;
}

- (UIView *)view
{
  return [[UIView alloc] init];
}

RCT_EXPORT_VIEW_PROPERTY(source, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(autoPlay, BOOL)
RCT_EXPORT_VIEW_PROPERTY(isUserInteractionEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(muted, BOOL)
RCT_EXPORT_VIEW_PROPERTY(loop, BOOL)
RCT_EXPORT_VIEW_PROPERTY(pictureInPicture, BOOL)

@end
