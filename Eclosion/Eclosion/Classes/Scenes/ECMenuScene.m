//
//  ECMenuScene.m
//  Blocks_Cocos
//
//  Created by Tsubasa on 13-9-1.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "ECMenuScene.h"
#import "ECGameScene.h"


@implementation ECMenuScene

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	ECMenuScene *layer = [ECMenuScene node];
	[scene addChild: layer];
	return scene;
}

-(void) onEnter
{
	[super onEnter];
    
    // Set background
    CC_CREATE_SPRITE_CENTER(background, @"bg_main.png", 0);

    
    // Play button
    CC_CREATE_MENUITEM(playBtn, @"roundbuttonoff.png", beginGame);
    playBtn.position = ccp(WINSIZE.width/2, WINSIZE.height/2);
    
    // Volume button
    CC_CREATE_MENUITEM(volumeBtn, @"roundbuttonsmalloff.png", gotoVolumeScene);
    volumeBtn.position = ccp(WINSIZE.width/2 - 90, WINSIZE.height/2 - 80);
    
    // Help button
    CC_CREATE_MENUITEM(helpBtn, @"roundbuttonsmalloff.png", gotoHelpScene);
    helpBtn.position = ccp(WINSIZE.width/2, WINSIZE.height/2 - 80);
    
    // Info button
    CC_CREATE_MENUITEM(infoButton, @"roundbuttonsmallon.png", gotoInfoScene);
    infoButton.position = ccp(WINSIZE.width/2 + 90, WINSIZE.height/2 - 80);
    
    // Facebook button
    CC_CREATE_MENUITEM(facebookButton, @"facebookon.png", gotoFacebook);
    facebookButton.position = ccp(WINSIZE.width - 40, 30);
    
    // Twitter button
    CC_CREATE_MENUITEM(twitterButton, @"tweeteron.png", gotoTwitter);
    twitterButton.position = ccp(WINSIZE.width - 90, 30);
    
    // Menu
    CCMenu * m = [CCMenu menuWithItems:playBtn, volumeBtn, helpBtn, infoButton,
                  facebookButton, twitterButton, nil];
    m.position = CGPointZero;
    [self addChild:m];
	
}

-(void) beginGame {
    CC_TRANSLATE_SCENE([ECGameScene scene]);
}

-(void) gotoVolumeScene {
    CC_TRANSLATE_SCENE([ECGameScene scene]);
}

-(void) gotoHelpScene {
    CC_TRANSLATE_SCENE([ECGameScene scene]);
}

-(void) gotoInfoScene {
    CC_TRANSLATE_SCENE([ECGameScene scene]);
}

-(void) gotoFacebook {
}

-(void) gotoTwitter {
}

@end
