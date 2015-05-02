//
//  MainScene.h
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "cocos2d.h"
#import "Minions.h"
#import "Enemy.h"
#import "Bones.h"
#import "Catapult.h"

@interface MainScene : CCNode {
	CCPhysicsNode *_physicsNode;
	CCNode *_ground1;
	NSMutableArray *_minions;
	NSMutableArray *_bones;
	NSMutableArray *_enemies;
	NSMutableArray *_toDelete;
	CCLabelTTF *_popLabel;
	CGSize screeSize;
	NSTimeInterval _enemyInterval;
}

@end
