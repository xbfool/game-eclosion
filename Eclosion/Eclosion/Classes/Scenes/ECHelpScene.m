//
//  ECHelpScene.m
//  Eclosion
//
//  Created by Tsubasa on 13-9-8.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "ECHelpScene.h"

@implementation ECHelpScene

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	ECHelpScene *layer = [ECHelpScene node];
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
