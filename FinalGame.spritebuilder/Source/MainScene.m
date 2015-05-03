#import "MainScene.h"
#import "CCPhysics+ObjectiveChipmunk.h"

@implementation MainScene {
	CCSprite *_addBoneArea1, *_addBoneArea2;
	CCSprite *tempBone;
	CCSprite *_cloud;
	Catapult *_catapult;
    CCNode *_catapultArm;
    CCNode *_mouseJointNode;
    CCNode *_god;
	Tower *_tower;
    CCPhysicsJoint *_mouseJoint;
    CCNode *_currentCannon;
	int angle;
	NSString *_material;
}

- (void)didLoadFromCCB {
    self.userInteractionEnabled = TRUE;
	//_physicsNode.debugDraw = TRUE;
	_physicsNode.collisionDelegate = self;
    _mouseJointNode.physicsBody.collisionMask = @[];
}

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CGPoint touchLocation = [touch locationInNode:self];
	
	//NSString *test = [NSString stringWithFormat:@"%f", _addBoneArea1.boundingBox.size.width];
	//NSLog(test);
	if (isGameover) {
		// go back to the map scene
		CCScene *mapScene = [CCBReader loadAsScene:@"MapScene"];
		[[CCDirector sharedDirector] replaceScene:mapScene];
		return;
	}
	
	if (CGRectContainsPoint(_addBoneArea1.boundingBox, touchLocation)) {
		//[self addBoneTouchLocation:touchLocation];
		// add horizontal bone
		if (totalGold >= [Bones getPrice]) {
			tempBone = [CCSprite spriteWithImageNamed:_material];
			tempBone.scale = 0.2;
			angle = 90;
			tempBone.rotation = angle;
			tempBone.position = touchLocation;
			[self addChild:tempBone];
		}
	} else if (CGRectContainsPoint(_addBoneArea2.boundingBox, touchLocation)) {
		// add vertical bone
		if (totalGold >= [Bones getPrice]) {
			tempBone = [CCSprite spriteWithImageNamed:_material];
			tempBone.scale = 0.2;
			angle = 0;
			tempBone.position = touchLocation;
			[self addChild:tempBone];
		}
    } else if (CGRectContainsPoint([_catapultArm boundingBox], ccpSub(touchLocation, _catapult.position))) {
		// create joint at catapult
        _mouseJointNode.position = ccpSub(touchLocation, _catapult.position);
        _mouseJoint = [CCPhysicsJoint connectedSpringJointWithBodyA:_mouseJointNode.physicsBody bodyB:_catapultArm.physicsBody anchorA:ccp(0,0) anchorB:ccp(11, 66) restLength:0.f stiffness:3000.f damping:150.f];
	} else {
		[self addCatapult:touchLocation];
	}
}

- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
	CGPoint touchLocation = [touch locationInNode:self];
	if (tempBone != nil) {
		tempBone.position = touchLocation;
    } else if (_mouseJoint != nil) {
        _mouseJointNode.position = ccpSub(touchLocation, _catapult.position);
    }
}

- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
	CGPoint touchLocation = [touch locationInNode:self];
	if (tempBone != nil) {
		[self addBoneTouchLocation:touchLocation:angle];
		[self removeChild:tempBone];
		tempBone = nil;
    } else if (_mouseJoint != nil) {
        [self releaseCatapult];
    }
}

- (void)releaseCatapult {
    [_mouseJoint invalidate];
    _mouseJoint = nil;
    
    _currentCannon = [CCBReader load:@"Stone"];
    CGPoint cannonPosition = ccpAdd(_catapult.position, _catapultArm.position);
    cannonPosition = ccpAdd(cannonPosition, ccp(5, 5));
    _currentCannon.position = cannonPosition;
    [_physicsNode addChild:_currentCannon];
    _currentCannon.physicsBody.allowsRotation = TRUE;
}

- (void)addBoneTouchLocation:(CGPoint)touchLocation:(int)rotate {
    CCNode* bone = [CCBReader load:_material];
    bone.position = touchLocation;
	bone.rotation = rotate - 90;
    [_physicsNode addChild:bone];
	[_bones addObject:bone];
	totalGold -= [Bones getPrice];
	_goldLabel.string = [NSString stringWithFormat:@"%d", totalGold];
}

- (void)addCatapult:(CGPoint)curPosition {
	if (_catapult != nil) return;
	_catapult = (Catapult *)[CCBReader load:@"Catapult"];
	_catapult.position = curPosition;
    _catapultArm = [_catapult getArm];
    _mouseJointNode = [_catapult getJointNode];
	[_physicsNode addChild:_catapult];
}

- (void)addTower:(CGPoint)curPosition {
	if (_tower != nil) return;
	_tower = (Tower *)[CCBReader load:@"Tower"];
	_tower.position = ccp(curPosition.x, screeSize.height);
	[_physicsNode addChild:_tower];
}

// add minion when the button is pressed
- (void) minionButtonPressed {
	if (totalGold >= 100) {
		CCNode *minion = [CCBReader load:@"Minions"];
		minion.position = ccp(0, _ground1.boundingBox.size.height + 15);
		[_minions addObject:minion];
		[self addChild:minion];
		totalGold -= [Minions getPrice];
		_goldLabel.string = [NSString stringWithFormat:@"%d", totalGold];
	}
}

- (void) addEnemy {
	CCNode *enemy = [CCBReader load:@"Enemy"];
	enemy.position = ccp(screeSize.width, _ground1.boundingBox.size.height + 11);
	[_enemies addObject:enemy];
	[self addChild:enemy];
}

- (void)onEnter {
	[super onEnter];
	_minions = [[NSMutableArray alloc] init];
	_toDelete = [[NSMutableArray alloc] init];
	_bones = [[NSMutableArray alloc] init];
	_enemies = [[NSMutableArray alloc] init];
	screeSize = [CCDirector sharedDirector].viewSize;
	_popLabel.visible = TRUE;
	_goldLabel.visible = TRUE;
	_timeLabel.visible = TRUE;
	_enemyInterval = 0.f;
	_goldInterval = 0.f;
	_catapult = nil;
    _mouseJoint = nil;
	_tower = nil;
	totalGold = 300;
	totalTime = 100.f;
	goldInc = 100;
	isGameover = FALSE;
	_material = [GameProperty getMaterial];
	NSLog(_material);
}

- (void) removeFromList {
	for (CCNode *element in _toDelete) {
		if ([element isKindOfClass:[Minions class]]) {
			[_minions removeObject:element];
		} else if ([element isKindOfClass:[Enemy class]]) {
			[_enemies removeObject:element];
		}
		
		[self removeChild:element cleanup:true];
	}
	[_toDelete removeAllObjects];
}

- (void)update:(CCTime)delta {
	if (!isGameover) {
		[self checkGameover];
	} else {
		return;
	}
	
	// add enemy minion
	_enemyInterval += delta;
	_goldInterval += delta;
	if (_enemyInterval > 20.f) {
		[self addEnemy];
		_enemyInterval = 0.f;
	}
	
	// update units position
	for (CCNode *minion in _minions) {
        minion.position = ccp(minion.position.x + 25 * delta, minion.position.y);
		if (minion.position.x > screeSize.width) {
			[_toDelete addObject:minion];
		}
    }
	
	// update enemy position
	for (CCNode *enemy in _enemies) {
		enemy.position = ccp(enemy.position.x - 25 * delta, enemy.position.y);
		if (enemy.position.x < 0) {
			[_toDelete addObject:enemy];
		}
	}
	
	// check units collision
	for (Unit *minion in _minions) {
		for (Unit *enemy in _enemies) {
			if (CGRectIntersectsRect(minion.boundingBox, enemy.boundingBox)) {
				[minion reduceHealth];
				[enemy reduceHealth];
				
				if ([minion isDead]) {
					[_toDelete addObject:minion];
				}
				if ([enemy isDead]) {
					[_toDelete addObject:enemy];
				}
			}
		}
	}
	
	[self removeFromList];
	[self updatePopulation];
	
	// check if any material has reach the target height
	for (CCNode *material in _bones) {
		if (material.position.y >= _cloud.position.y - 20) {
			// current bone has reach the top
			[self addTower:material.position];
			break;
		}
	}
	
	// update gold
	if (_goldInterval > 2.f) {
		totalGold += goldInc;
		_goldLabel.string = [NSString stringWithFormat:@"%d", totalGold];
		_goldInterval = 0.f;
	}
	
	// update timer
	_timeLabel.string = [NSString stringWithFormat:@"%d", (int)(totalTime -= delta)];
}

- (void) checkGameover {
	if (totalTime < 0.1f) {
		isGameover = TRUE;
		_timeLabel.visible = FALSE;
		for (int i = 0; i < 10; i++) {
			CCNode *failbox = [CCBReader load:@"Fail"];
			[_physicsNode addChild:failbox];
			failbox.position = ccp(screeSize.width / 2, screeSize.height + 30 * i);
		}
	}
}

- (void) victory {
	isGameover = TRUE;
	_timeLabel.visible = FALSE;
	for (int i = 0; i < 1; i++) {
		CCSprite *failbox = (CCSprite *)[CCBReader load:@"Fail"];
		[failbox setSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"win.png"]];
		failbox.scale = 0.5;
		[_physicsNode addChild:failbox];
		failbox.position = ccp(screeSize.width / 2, screeSize.height + 30 * i);
	}
}

- (void)updatePopulation {
	_popLabel.string = [NSString stringWithFormat:@"%d", [_minions count]];
	_popLabel.visible = true;
}

- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair bone:(CCNode *)nodeA scene:(CCNode *)nodeB {
	float energy = [pair totalKineticEnergy];
	
	// if energy is large enough, remove the bone
	if (energy > 5000.f) {
		[[_physicsNode space] addPostStepBlock:^{[self boneRemoved:nodeA];} key:nodeA];
	}
}

- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair ground:(CCNode *)nodeA scene:(CCNode *)nodeB {
	nodeB.physicsBody.type = CCPhysicsBodyTypeStatic;
}

- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair ground:(CCNode *)nodeA god:(CCNode *)nodeB {
	if (!isGameover) {
		[self victory];
	}
}

- (void)boneRemoved:(CCNode *)bone {
	[_bones removeObject:bone];
	[bone removeFromParent];
}

@end