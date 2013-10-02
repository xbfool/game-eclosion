//
//  ECGameScene.m
//  Blocks_Cocos
//
//  Created by ; on 13-9-1.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "ECGameScene.h"
#import "ECPauseScene.h"
#import "ECLevelScene.h"
#import "ECMenuScene.h"
#import "ECTileMap.h"

@interface ECGameScene()<ECPauseSceneDelegate>

@end

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
    
    // LoadGaem
    ECTileMap *map = [ECTileMap mapBuildWithFile:@"level0"];
    [self addChild:map];
}

-(void) pause {
    if ( !_pauseScene ) {
        _pauseScene = [[ECPauseScene alloc] init];
        _pauseScene.delegate = self;
    }
    
	[self addChild: _pauseScene];
}

#pragma PauseScene Delegate
-(void) resumeGame {
    [_pauseScene removeFromParentAndCleanup:NO];
}

-(void) restartGame {
    [_pauseScene removeFromParentAndCleanup:NO];
}

-(void) gotoLevelScene {
    CC_TRANSLATE_SCENE([ECLevelScene scene]);
}

-(void) gotoMenuScene {
    CC_TRANSLATE_SCENE([ECMenuScene scene]);
}

@end
