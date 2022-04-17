
#ifndef AS_USE_VIDEO
#define AS_USE_VIDEO 1
#endif

#import "VideoKitComponentView.h"

#import <React/RCTMountingTransactionObserving.h>
#import <React/UIView+React.h>

#import <react/renderer/components/VideoKitViewSpec/ComponentDescriptors.h>
#import <react/renderer/components/VideoKitViewSpec/EventEmitters.h>
#import <react/renderer/components/VideoKitViewSpec/Props.h>
#import <react/renderer/components/VideoKitViewSpec/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"

using namespace facebook::react;


// TODO Subclass our own ASVideoNode so we can set image placeholder properly & other props

@interface VideoKitView () <RCTVideoViewViewProtocol, ASVideoNodeDelegate, AVPictureInPictureControllerDelegate>
@end

@implementation VideoKitView {
    UIView * _view;
    ASVideoNode * _videoNode;
    AVPictureInPictureController * _pipController;
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
        
        _videoNode.shouldAutoplay = defaultProps->autoPlay;
        _videoNode.frame = self.layer.bounds;
        _videoNode.style.flexGrow = 1;
        _videoNode.gravity = AVLayerVideoGravityResizeAspect;
        _videoNode.muted = defaultProps->muted;
        _videoNode.shouldAutorepeat = defaultProps->muted;
        
        _videoNode.delegate = self;
        _videoNode.placeholderEnabled = true;
        _videoNode.placeholderFadeDuration = 0.3;
        _videoNode.URL = [NSURL URLWithString:@"https://source.unsplash.com/user/c_v_r/1600x900"];
        
        [_videoNode.view setUserInteractionEnabled:defaultProps->isUserInteractionEnabled];
        
        [_view addSubview:_videoNode.view];
        self.contentView = _videoNode.view;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidEnterBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        
    }

    return self;
}

- (void)applicationDidEnterBackground:(NSNotification *) notification
{
    //[_videoNode.playerLayer setPlayer:nil];
    dispatch_async(dispatch_get_main_queue(), ^ {
        [_videoNode pause];
    });
}


- (void)parseProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
    
}

- (void)dealloc {
    _videoNode = nil;
}

- (void)updateSourceIfNeeded:(VideoViewSourceStruct const &) source withPIP:(BOOL)pipEnabled
{
    NSString *src = [[NSString alloc] initWithUTF8String: source.uri.c_str()];

    [_videoNode resetToPlaceholder];
    dispatch_async(dispatch_get_main_queue(), ^ {
        printf("PROPS 111\n");
        AVAsset *asset = [AVAsset assetWithURL:[NSURL URLWithString:src]];
        self->_videoNode.asset = asset;
        if (pipEnabled) {
            [self setupPIP];
        }
    });
}

- (void)setupPIP
{
    if ([AVPictureInPictureController isPictureInPictureSupported]) {
        _pipController = [[AVPictureInPictureController alloc] initWithPlayerLayer:_videoNode.playerLayer];
        if (@available(iOS 14.2, *)) {
            [self->_pipController setCanStartPictureInPictureAutomaticallyFromInline:true];
        } else {
            // Fallback on earlier versions
        }
        _pipController.delegate = self;
    }
}


- (void)videoNode:(ASVideoNode *)videoNode willChangePlayerState:(ASVideoNodePlayerState)state toState:(ASVideoNodePlayerState)toState
{
    if (toState == ASVideoNodePlayerStatePlaying) {
        //[self setupPIP];
    }
}
- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
    const auto &oldViewProps = *std::static_pointer_cast<VideoViewProps const>(_props);
    const auto &newViewProps = *std::static_pointer_cast<VideoViewProps const>(props);
    
    printf("UPDATED PROPS\n");
    [self parseProps:_props oldProps:props];
    
    if (oldViewProps.source.uri != newViewProps.source.uri) {
        [self updateSourceIfNeeded:newViewProps.source withPIP:newViewProps.pictureInPicture];
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
    
    if (oldViewProps.autoRepeat != newViewProps.autoRepeat) {
        _videoNode.shouldAutorepeat = newViewProps.autoRepeat;
    }
    
    [super updateProps:props oldProps:oldProps];
}




@end



Class<RCTComponentViewProtocol> VideoViewCls(void)
{
  return VideoKitView.class;
}
