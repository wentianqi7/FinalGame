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
#import "Tower.h"
#import "CCPhysics+ObjectiveChipmunk.h"
#import "GameProperty.h"

@interface MainScene : CCNode <CCPhysicsCollisionDelegate> {
	CCPhysicsNode *_physicsNode;
	CCNode *_ground1;
	CCNode *_worker1, *_worker2, *_worker3;
	NSMutableArray *_minions;
	NSMutableArray *_bones;
	NSMutableArray *_enemies;
	NSMutableArray *_toDelete;
	NSMutableArray *_workers;
	CGSize screeSize;
	NSTimeInterval _enemyInterval;
	NSTimeInterval _goldInterval;
	NSTimeInterval _addCataInterval;
	float _enemyDensity;
	int totalGold;
	CCLabelTTF *_goldLabel;
	CCLabelTTF *_timeLabel;
	float totalTime;
	int goldInc;
	bool isGameover;
}


@end
