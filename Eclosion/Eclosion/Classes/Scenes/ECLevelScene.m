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
#import "ECLevelManager.h"
#import "ECSubLevelScene.h"

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
    CC_CREATE_SPRITE(title, @"stage selection.png",ccp(WINSIZE.width/2, 100), 0);
    
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
    
    // Score
    ECLevelManager *lm = [ECLevelManager manager];
    CCLabelTTF *label = [CCLabelTTF labelWithString:
                         [NSString stringWithFormat:@"%d/%d",[lm totalScore], MAX_LEVEL * 3]
                                           fontName:@"MarkerFelt-Thin" fontSize:20];
    label.position = ccp(65, WINSIZE.height - 20);
    [self addChild:label];
}

-(void) createLevelMenu {
    NSMutableArray *levelsArrya = [NSMutableArray array];
    for ( int row = 0; row < 3; row++ ) {
        for ( int col = 0; col < 3; col++ ) {
            int stage = row * 3 + col;
            if ( stage >= MAX_STAGE ) break;
            
            // add level
            ECLevel *beginLevel = [[ECLevelManager manager].levelDataArray objectAtIndex:stage * LEVEL_PER_STAGE];
            ECLevel *endLevel = [[ECLevelManager manager].levelDataArray objectAtIndex:(stage + 1) * LEVEL_PER_STAGE - 1];
            NSString *filename;
            if ( endLevel.cleared == LevelStatusCleared ) {
                filename = @"stagecleared.png";
            } else if ( beginLevel.cleared == LevelStatusLock ) {
                filename = @"stagelocked.png";
            } else {
                filename = @"stageunlocked.png";
            }
            CC_CREATE_MENUITEM(lev1, filename, filename, beginGame:);
            lev1.tag = row * 3 + col;
            lev1.position = ccp(60 + col * 100, 300 - row * 100);
            
            // level number
            if ( beginLevel.cleared != LevelStatusLock ) {
                CCLabelTTF *label = [CCLabelTTF labelWithString:
                                     [NSString stringWithFormat:@"%d",row * 3 + col + 1 ]
                                                       fontName:@"MarkerFelt-Thin" fontSize:20];
                label.position = ccp(52,42);
                [lev1 addChild:label];
            }
            
            [levelsArrya addObject:lev1];
        }
    }
    
    // Menu
    CCMenu * m = [CCMenu menuWithArray:levelsArrya];
    m.position = CGPointZero;
    [self addChild:m];
}

-(void) back {
    CC_TRANSLATE_SCENE([ECMenuScene scene]);
}

-(void) beginGame:(CCMenuItem *)item {
    [ECLevelManager manager].currentStage = item.tag;
    CC_TRANSLATE_SCENE([ECSubLevelScene scene]);
}

@end
