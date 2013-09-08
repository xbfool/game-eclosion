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
    CCMenuItemSprite * playBtn = [CCMenuItemSprite itemWithNormalSprite:
               [CCSprite spriteWithFile:@"roundbuttonoff.png"]
                                      selectedSprite:nil
                                      disabledSprite:nil
                                 target:self selector:@selector(beginGame)];
    playBtn.position = ccp(WINSIZE.width/2, WINSIZE.height/2);
    [playBtn addChild:[CCSprite spriteWithFile:@""]];
    
    // Volume button
    CCMenuItemSprite * volumeBtn = [CCMenuItemSprite itemWithNormalSprite:
                                  [CCSprite spriteWithFile:@"roundbuttonsmalloff.png"]
                                                         selectedSprite:nil
                                                         disabledSprite:nil
                                  target:self selector:@selector(beginGame)];
  
    volumeBtn.position = ccp(WINSIZE.width/2 - 90, WINSIZE.height/2 - 80);
    
    // Help button
    CCMenuItemSprite * helpBtn = [CCMenuItemSprite itemWithNormalSprite:
                                  [CCSprite spriteWithFile:@"roundbuttonsmalloff.png"]
                                                         selectedSprite:nil
                                                         disabledSprite:nil
                                  target:self selector:@selector(beginGame)];
    helpBtn.position = ccp(WINSIZE.width/2, WINSIZE.height/2 - 80);
    
    // Info button
    CCMenuItemSprite * infoButton = [CCMenuItemSprite itemWithNormalSprite:
                                  [CCSprite spriteWithFile:@"roundbuttonsmallon.png"]
                                                         selectedSprite:nil
                                                         disabledSprite:nil
                                  target:self selector:@selector(beginGame)];
    infoButton.position = ccp(WINSIZE.width/2 + 90, WINSIZE.height/2 - 80);
    
    // 菜单
    CCMenu * m = [CCMenu menuWithItems:playBtn, volumeBtn, helpBtn, infoButton, nil];
    m.position = CGPointZero;
    [self addChild:m];
	
}

-(void) makeTransition
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[ECGameScene scene] withColor:ccWHITE]];
}

-(void) beginGame {
    [self makeTransition];
}


@end
