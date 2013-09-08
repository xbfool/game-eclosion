//
//  ECMenuScene.m
//  Blocks_Cocos
//
//  Created by Tsubasa on 13-9-1.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "ECMenuScene.h"
#import "ECGameScene.h"
#import "ECVolumeScene.h"
#import "ECInfoScene.h"
#import "ECHelpScene.h"


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
    CC_CREATE_MENUITEM(playBtn, @"roundbuttonoff.png", @"roundbuttonon.png", beginGame);
    playBtn.position = ccp(WINSIZE.width/2, WINSIZE.height/2);
    
    // Volume button
    CC_CREATE_MENUITEM(volumeBtn, @"roundbuttonsmalloff.png",@"roundbuttonsmallon.png", gotoVolumeScene);
    volumeBtn.position = ccp(WINSIZE.width/2 - 90, WINSIZE.height/2 - 80);
    CC_MENUITEM_ADD_ICON(volumeBtn, @"musicon.png");
    
    // Help button
    CC_CREATE_MENUITEM(helpBtn, @"roundbuttonsmalloff.png",@"roundbuttonsmallon.png", gotoHelpScene);
    helpBtn.position = ccp(WINSIZE.width/2, WINSIZE.height/2 - 80);
    CC_MENUITEM_ADD_ICON(helpBtn, @"help.png");
    
    // Info button
    CC_CREATE_MENUITEM(infoButton, @"roundbuttonsmalloff.png",@"roundbuttonsmallon.png", gotoInfoScene);
    infoButton.position = ccp(WINSIZE.width/2 + 90, WINSIZE.height/2 - 80);
    CC_MENUITEM_ADD_ICON(infoButton, @"credits.png");
    
    // Facebook button
    CC_CREATE_MENUITEM(facebookButton, @"facebookon.png", @"facebookon.png", gotoFacebook);
    facebookButton.position = ccp(WINSIZE.width - 40, 30);
    
    // Twitter button
    CC_CREATE_MENUITEM(twitterButton, @"tweeteron.png", @"facebookon.png", gotoTwitter);
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
    CC_TRANSLATE_SCENE([ECVolumeScene scene]);
}

-(void) gotoHelpScene {
    CC_TRANSLATE_SCENE([ECHelpScene scene]);
}

-(void) gotoInfoScene {
    CC_TRANSLATE_SCENE([ECInfoScene scene]);
}

-(void) gotoFacebook {
}

-(void) gotoTwitter {
}

@end
