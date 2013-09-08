//
//  ECPauseScene.m
//  Eclosion
//
//  Created by Tsubasa on 13-9-4.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "ECPauseScene.h"


@implementation ECPauseScene
@synthesize delegate;

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	ECPauseScene *layer = [ECPauseScene node];
	[scene addChild: layer];
	return scene;
}

-(void) onEnter
{
	[super onEnter];
    
    // Set background
    CC_CREATE_SPRITE_CENTER(background, @"bg_pause.png", 0);
    
    // Resume button
    CC_CREATE_MENUITEM(resumeBtn, @"buttonoff.png", @"buttonon.png", resumeGame);
    resumeBtn.position = ccp(100, 340);
    CC_MENUITEM_ADD_ICON(resumeBtn, @"resume_off.png");
    
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

-(void) resumeGame {

}

-(void) restartGame {
    
}

-(void) gotoLevelScene {
    
}

-(void) gotoMenuScene {
    
}

@end




