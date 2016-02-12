// BobMakesTweaks
// I AM NOT OF COOLSTAR
// Calling it how it is, rude or not.

@interface SBCCQuickLaunchSectionController : UIViewController
@end

@interface SBCCSettingsSectionController : UIViewController
@end

@interface ZMControlTogglesView : UIView
@end

@interface ZMMusicPlayerView : UIView {
	UIImageView *_nowPlayingArtworkImageView;
}
@end

@interface ZMScrollView : UIScrollView
@end

@interface ZMView : UIView {
	ZMControlTogglesView *_controlTogglesView;
	ZMMusicPlayerView *_musicPlayerView;
}
+ (id)sharedInstance;
@end

%hook ZMControlTogglesView
- (id)initWithDelegate:(id)arg1 {

	UIView *fixedView = %orig;

	int subviewIndex = 0;
	for(UIImageView *possibleButton in [fixedView subviews]) {
		if((subviewIndex < 5) || (subviewIndex > 8)) {
			[possibleButton removeFromSuperview];
		}
		subviewIndex++;
	}

	SBCCSettingsSectionController *ccSettingsSection = [[NSClassFromString(@"SBCCSettingsSectionController") alloc] init];
	[[ccSettingsSection view] setFrame:CGRectMake(0, 26, [[UIScreen mainScreen] bounds].size.width, 50)];
	[[ccSettingsSection view] setBackgroundColor:[UIColor clearColor]];
	[fixedView addSubview:[ccSettingsSection view]];

	SBCCQuickLaunchSectionController *ccQuickLaunch = [[NSClassFromString(@"SBCCQuickLaunchSectionController") alloc] init];
	[[ccQuickLaunch view] setFrame:CGRectMake(0, 144, [[UIScreen mainScreen] bounds].size.width, 64)];
	[[ccQuickLaunch view] setBackgroundColor:[UIColor clearColor]];
	[fixedView addSubview:[ccQuickLaunch view]];

	return fixedView;
}
%end

%hook ZMMusicPlayerView
- (void)update {

	%orig;

	UIImageView *albumArt = [self valueForKey:@"_nowPlayingArtworkImageView"];
	albumArt.layer.cornerRadius = 14;
	albumArt.layer.masksToBounds = YES;
}
%end

%ctor{
    dlopen("/Library/MobileSubstrate/DynamicLibraries/Zentrum.dylib", RTLD_NOW);
}
