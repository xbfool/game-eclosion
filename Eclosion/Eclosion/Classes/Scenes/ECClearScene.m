//
//  ECClearScene.m
//  Eclosion
//
//  Created by Tsubasa on 13-11-13.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "ECClearScene.h"
#import "ECGameScene.h"
#import "ECLevelScene.h"
#import "ECMenuScene.h"
#import "ECLevelManager.h"

@implementation ECClearScene
+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	ECClearScene *layer = [ECClearScene node];
	[scene addChild: layer];
	return scene;
}

-(void) onEnter
{
	[super onEnter];
    
    // Set background
    CC_CREATE_SPRITE_CENTER(background, @"bg_pause.png", 0);
    
    // Resume button
    CC_CREATE_MENUITEM(resumeBtn, @"buttonoff.png", @"buttonon.png", nextLevel);
    resumeBtn.position = ccp(100, 340);
    CC_MENUITEM_ADD_ICON(resumeBtn, @"next.png");
    
    ECLevel *level = [[ECLevelManager manager] getCurrentLevelData];
    if ( level.cleared != LevelStatusCleared ) {
        resumeBtn.visible = NO;
    }
    
    // Restart button
    CC_CREATE_MENUITEM(restartBtn, @"buttonoff.png", @"buttonon.png", restartGame);
    restartBtn.position = ccp(100, 340 - 70);
    CC_MENUITEM_ADD_ICON(restartBtn, @"restart_off.png");
    
    // Level button
    CC_CREATE_MENUITEM(levelBtn, @"buttonoff.png", @"buttonon.png", gotoLevelScene);
    levelBtn.position = ccp(100, 340 - 70*2);
    CC_MENUITEM_ADD_ICON(levelBtn, @"levelselect_off.png");
    
    // Menu button
    CC_CREATE_MENUITEM(menuBtn, @"buttonoff.png", @"buttonon.png", gotoMenuScene);
    menuBtn.position = ccp(100, 340 - 70*3);
    CC_MENUITEM_ADD_ICON(menuBtn, @"mainmenu_off.png");
    
    
    // Menu
    CCMenu * m = [CCMenu menuWithItems:resumeBtn, restartBtn, levelBtn, menuBtn, nil];
    m.position = CGPointZero;
    [self addChild:m];
}

- (void) nextLevel {
    [ECLevelManager manager].currentLevel ++;
    CC_TRANSLATE_SCENE([ECGameScene scene]);
}

- (void) restartGame {
    CC_TRANSLATE_SCENE([ECGameScene scene]);
}

- (void) gotoLevelScene {
    CC_TRANSLATE_SCENE([ECLevelScene scene]);
}

- (void) gotoMenuScene {
    CC_TRANSLATE_SCENE([ECMenuScene scene]);
}

@end
