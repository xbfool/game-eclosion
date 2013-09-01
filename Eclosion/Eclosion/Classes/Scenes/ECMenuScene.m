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

    
    // Set menu
    _playBtn = [CCMenuItemSprite itemWithNormalSprite:
               [CCSprite spriteWithFile:@"btn_play_common.png"]
                                      selectedSprite:nil
                                      disabledSprite:nil
                                              target:self selector:@selector(beginGame)];
    _playBtn.position = ccp(WINSIZE.width/2, WINSIZE.height/2);
    
    CCMenu * m = [CCMenu menuWithItems:_playBtn, nil];
    m.position = CGPointZero;
    [self addChild:m];
	
	// In one second transition to the new scene
	//[self scheduleOnce:@selector(makeTransition:) delay:1];
}

-(void) makeTransition
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[ECGameScene scene] withColor:ccWHITE]];
}

-(void) beginGame {
    [self makeTransition];
}


@end
