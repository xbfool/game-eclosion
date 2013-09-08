//
//  ECLevelScene.m
//  Eclosion
//
//  Created by Tsubasa on 13-9-4.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "ECLevelScene.h"
#import "ECMenuScene.h"
#import "ECGameScene.h"

@implementation ECLevelScene

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	ECLevelScene *layer = [ECLevelScene node];
	[scene addChild: layer];
	return scene;
}

-(void) onEnter
{
	[super onEnter];
    
    // Set background
    CC_CREATE_SPRITE_CENTER(background, @"bg_levelselect.png", 0);
    CC_CREATE_SPRITE(title, @"level selection.png",ccp(WINSIZE.width/2, 100), 0);
    
    // Back button
    CC_CREATE_MENUITEM(backBtn, @"roundbuttonoff.png", @"roundbuttonon.png", back);
    backBtn.position = ccp(WINSIZE.width - 35, WINSIZE.height - 35);
    CC_MENUITEM_ADD_ICON(backBtn, @"back.png");
    
    // Menu
    CCMenu * m = [CCMenu menuWithItems:backBtn, nil];
    m.position = CGPointZero;
    [self addChild:m];
    
    // Level Menu
    [self createLevelMenu];
}

-(void) createLevelMenu {
    
    NSMutableArray *levelsArrya = [NSMutableArray array];
    for ( int row = 0; row < 3; row++ ) {
        
        CC_CREATE_MENUITEM(lev1, @"stagecleared.png", @"stageon.png", beginGame);
        lev1.position = ccp(60, 300 - row * 100);
        
        CC_CREATE_MENUITEM(lev2, @"stageunlocked.png", @"stageon.png", beginGame);
        lev2.position = ccp(60 + 100, 300 - row * 100);
        
        CC_CREATE_MENUITEM(lev3, @"stagelocked.png", @"stagelocked.png", beginGame);
        lev3.position = ccp(60 + 200, 300 - row * 100);
        
        [levelsArrya addObject:lev1];
        [levelsArrya addObject:lev2];
        [levelsArrya addObject:lev3];
    }
    
    // Menu
    CCMenu * m = [CCMenu menuWithArray:levelsArrya];
    m.position = CGPointZero;
    [self addChild:m];
}

-(void) back {
    CC_TRANSLATE_SCENE([ECMenuScene scene]);
}

-(void) beginGame {
    CC_TRANSLATE_SCENE([ECGameScene scene]);
}

@end
