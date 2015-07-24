@interface SpringBoard : UIApplication
-(id) _accessibilityFrontMostApplication;
@end

@interface SBApplication
-(id) bundleIdentifier;
@end

@interface BBBulletinRequest : NSObject
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* message; 
@property (nonatomic, copy) NSString* sectionID;
@property (nonatomic, retain) NSDate* date;
@end

@interface SBBulletinBannerController
+(id)sharedInstance;
-(void)observer:(id)arg1 addBulletin:(id)arg2 forFeed:(unsigned long long)arg3;
-(void)observer:(id)arg1 addBulletin:(id)arg2 forFeed:(unsigned long long)arg3 playLightsAndSirens:(BOOL)arg4 withReply:(id)arg5;
@end

%hook SBScreenShotter

- (void)saveScreenshot:(_Bool)arg1 {

  SBApplication *frontApp = [(SpringBoard*)[UIApplication sharedApplication] _accessibilityFrontMostApplication]; 
  NSString *currentAppID = [frontApp bundleIdentifier];

  BOOL enabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"NLPSEnabled"];

  if([currentAppID isEqualToString:@"com.lastpass.ilastpass"]) {
    if(enabled == 0) {
      NSLog(@"NoLastPassScreenshot --> Current app is LastPass but Settings tell me to screen, kk");
      %orig(arg1);
    } else {
      BBBulletinRequest* banner = [[%c(BBBulletinRequest) alloc] init];
      [banner setTitle: @"NoLastPassScreenshot"];
      [banner setMessage: @"LastPass is opened, screenshot disabled"];
      [banner setDate: [NSDate date]];
      [banner setSectionID: @"com.apple.camera"];
      if([%c(SBBulletinBannerController) instancesRespondToSelector:@selector(observer:addBulletin:forFeed:playLightsAndSirens:withReply:)]) {
        [(SBBulletinBannerController *)[%c(SBBulletinBannerController) sharedInstance] observer:nil addBulletin:banner forFeed:2 playLightsAndSirens:YES withReply:nil];
      } else {
        [(SBBulletinBannerController *)[%c(SBBulletinBannerController) sharedInstance] observer:nil addBulletin:banner forFeed:2];
      }
      [banner release]; 
      NSLog(@"NoLastPassScreenshot --> Current app IS LastPass, no screenshot");
    }
  } else {
    NSLog(@"NoLastPassScreenshot --> Current app is not LastPass, screenshot is OK");
    %orig(arg1);
  }

}

%end
