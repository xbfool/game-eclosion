//
//  ECInfoScene.m
//  Eclosion
//
//  Created by Tsubasa on 13-9-8.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "ECInfoScene.h"

@implementation ECInfoScene

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	ECInfoScene *layer = [ECInfoScene node];
	[scene addChild: layer];
	return scene;
}

-(void) onEnter
{
	[super onEnter];
    
    // Set background
    CC_CREATE_SPRITE_CENTER(background, @"bg_credithelp.png", 0);
}

@end
