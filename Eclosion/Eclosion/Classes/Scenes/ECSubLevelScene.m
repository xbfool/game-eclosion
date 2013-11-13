//
//  ECSubLevelScene.m
//  Eclosion
//
//  Created by Tsubasa on 13-11-6.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "ECSubLevelScene.h"
#import "ECLevelManager.h"
#import "ECGameScene.h"
#import "ECLevelScene.h"


@implementation ECSubLevelScene
+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	ECSubLevelScene *layer = [ECSubLevelScene node];
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
        for ( int col = 0; col < 3; col++ ) {
            CC_CREATE_MENUITEM(lev1, @"cleared.png", @"cleared.png", beginGame:);
            lev1.tag = row * 3 + col;
            lev1.position = ccp(60 + col * 100, 300 - row * 100);
            
            [levelsArrya addObject:lev1];
        }
    }
    
    // Menu
    CCMenu * m = [CCMenu menuWithArray:levelsArrya];
    m.position = CGPointZero;
    [self addChild:m];
}

-(void) back {
    CC_TRANSLATE_SCENE([ECLevelScene scene]);
}

-(void) beginGame:(CCMenuItem *)item {
    int stage = [ECLevelManager manager].currentStage;
    [ECLevelManager manager].currentLevel =  stage * LEVEL_PER_STAGE + item.tag;
    
    CC_TRANSLATE_SCENE([ECGameScene scene]);
}

@end
