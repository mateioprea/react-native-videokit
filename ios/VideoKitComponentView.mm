
#define AS_USE_VIDEO 1

#import "VideoKitComponentView.h"
#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>
#import <AsyncDisplayKit/ASDisplayNode+Beta.h>
#import <AsyncDisplayKit/ASStackLayoutSpec.h>
#import <AsyncDisplayKit/ASInsetLayoutSpec.h>
#import <AsyncDisplayKit/ASVideoNode.h>

#import <AVFoundation/AVFoundation.h>
#import <React/RCTMountingTransactionObserving.h>
#import <React/UIView+React.h>

#import <react/renderer/components/VideoKitViewSpec/ComponentDescriptors.h>
#import <react/renderer/components/VideoKitViewSpec/EventEmitters.h>
#import <react/renderer/components/VideoKitViewSpec/Props.h>
#import <react/renderer/components/VideoKitViewSpec/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"

using namespace facebook::react;


// TODO Subclass our own ASVideoNode so we can set image placeholder properly & other props

@interface VideoKitView () <RCTVideoViewViewProtocol>
@end

@implementation VideoKitView {
    UIView * _view;
    ASVideoNode * _videoNode;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
    return concreteComponentDescriptorProvider<VideoViewComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        static const auto defaultProps = std::make_shared<const VideoViewProps>();
        _props = defaultProps;
        _view = [[UIView alloc] init];
        
        printf("AUTO PLAY %d\n", defaultProps->autoPlay);
        _videoNode = [[ASVideoNode alloc] init];
        [self updateSourceIfNeeded: defaultProps->source];
        _videoNode.shouldAutoplay = defaultProps->autoPlay;
        _videoNode.frame = self.layer.bounds;
        _videoNode.style.flexGrow = 1;
        _videoNode.gravity = AVLayerVideoGravityResizeAspect;
        _videoNode.muted = defaultProps->muted;
        _videoNode.shouldAutorepeat = defaultProps->muted;
        
        _videoNode.placeholderEnabled = true;
        _videoNode.URL = [NSURL URLWithString:@"https://source.unsplash.com/user/c_v_r/1600x900"];
        
        [_videoNode.view setUserInteractionEnabled:defaultProps->isUserInteractionEnabled];
        
        [_view addSubview:_videoNode.view];
        self.contentView = _videoNode.view;
        
    }

    return self;
}


- (void)parseProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
    
}

- (void)updateSourceIfNeeded:(VideoViewSourceStruct const &) source
{
    NSString *src = [[NSString alloc] initWithUTF8String: source.uri.c_str()];

    [_videoNode resetToPlaceholder];
    dispatch_async(dispatch_get_main_queue(), ^ {
        AVAsset *asset = [AVAsset assetWithURL:[NSURL URLWithString:src]];
        self->_videoNode.asset = asset;
    });
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
    const auto &oldViewProps = *std::static_pointer_cast<VideoViewProps const>(_props);
    const auto &newViewProps = *std::static_pointer_cast<VideoViewProps const>(props);
    
    printf("UPDATED PROPS\n");
    [self parseProps:_props oldProps:props];
    
    if (oldViewProps.source.uri != newViewProps.source.uri) {
        [self updateSourceIfNeeded:newViewProps.source];
    }
    
    if (oldViewProps.autoPlay != newViewProps.autoPlay) {
        _videoNode.shouldAutoplay = newViewProps.autoPlay;
    }
    
    if (oldViewProps.muted != newViewProps.muted) {
        _videoNode.muted = newViewProps.muted;
    }
    
    if (oldViewProps.loop != newViewProps.loop) {
        _videoNode.shouldAutorepeat = newViewProps.loop;
    }
    
    if (oldViewProps.isUserInteractionEnabled != newViewProps.isUserInteractionEnabled) {
        [_videoNode.view setUserInteractionEnabled:newViewProps.isUserInteractionEnabled];
    }
    
    [super updateProps:props oldProps:oldProps];
}




@end



Class<RCTComponentViewProtocol> VideoViewCls(void)
{
  return VideoKitView.class;
}
