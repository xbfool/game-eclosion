//
//  ECGameScene.m
//  Blocks_Cocos
//
//  Created by Tsubasa on 13-9-1.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "ECGameScene.h"
#import "ECPauseScene.h"

@implementation ECGameScene
+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	ECGameScene *layer = [ECGameScene node];
	[scene addChild: layer];
	return scene;
}

-(void) onEnter
{
	[super onEnter];
    
    // Set background
    CC_CREATE_SPRITE_CENTER(background, @"bg_game.png", 0);
    
    // Play button
    CC_CREATE_MENUITEM(pauseBtn, @"roundbuttonoff.png", @"roundbuttonon.png", pause);
    pauseBtn.position = ccp(WINSIZE.width - 35, WINSIZE.height - 35);
    CC_MENUITEM_ADD_ICON(pauseBtn, @"pause.png");
    
    // Menu
    CCMenu * m = [CCMenu menuWithItems:pauseBtn, nil];
    m.position = CGPointZero;
    [self addChild:m];
}

-(void) pause {
    CCScene *pauseScene = [ECPauseScene scene];
    CC_TRANSLATE_SCENE(pauseScene);
}

@end
