//
//  MenuScene.m
//  FinalGame
//
//  Created by Rainy Yang on 5/2/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "MenuScene.h"

@implementation MenuScene
- (void)play {
	CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
	[GameProperty setMaterial:@"Bones"];
	[[CCDirector sharedDirector] replaceScene:mainScene];
}

@end
