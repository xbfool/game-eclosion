//
//  ECGameScene.m
//  Blocks_Cocos
//
//  Created by Tsubasa on 13-9-1.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "ECGameScene.h"


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
}

@end
