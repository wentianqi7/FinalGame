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
    CCPhysicsJoint *_mouseJoint;
    CCNode *_currentCannon;
	int angle;
}

- (void)didLoadFromCCB {
    self.userInteractionEnabled = TRUE;
	_physicsNode.debugDraw = TRUE;
    _mouseJointNode.physicsBody.collisionMask = @[];
}

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CGPoint touchLocation = [touch locationInNode:self];
	
	//NSString *test = [NSString stringWithFormat:@"%f", _addBoneArea1.boundingBox.size.width];
	//NSLog(test);
	
	if (CGRectContainsPoint(_addBoneArea1.boundingBox, touchLocation)) {
		//[self addBoneTouchLocation:touchLocation];
		tempBone = [CCSprite spriteWithImageNamed:@"bone.png"];
		tempBone.scale = 0.2;
		angle = 90;
		tempBone.rotation = angle;
		tempBone.position = touchLocation;
		[self addChild:tempBone];
	} else if (CGRectContainsPoint(_addBoneArea2.boundingBox, touchLocation)) {
		tempBone = [CCSprite spriteWithImageNamed:@"bone.png"];
		tempBone.scale = 0.2;
		angle = 0;
		tempBone.position = touchLocation;
		[self addChild:tempBone];
    } else if (CGRectContainsPoint([_catapultArm boundingBox], ccpSub(touchLocation, _catapult.position))) {
        _mouseJointNode.position = ccpSub(touchLocation, _catapult.position);
        _mouseJoint = [CCPhysicsJoint connectedSpringJointWithBodyA:_mouseJointNode.physicsBody bodyB:_catapultArm.physicsBody anchorA:ccp(0,0) anchorB:ccp(11, 66) restLength:0.f stiffness:3000.f damping:150.f];
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
    CCNode* bone = [CCBReader load:@"Bones"];
    bone.position = touchLocation;
	bone.rotation = rotate - 90;
    [_physicsNode addChild:bone];
	[_bones addObject:bone];
}

- (void)addCatapult:(CGPoint)curPosition {
	if (_catapult != nil) return;
	_catapult = (Catapult *)[CCBReader load:@"Catapult"];
	_catapult.position = curPosition;
    _catapultArm = [_catapult getArm];
    _mouseJointNode = [_catapult getJointNode];
	[_physicsNode addChild:_catapult];
}

- (void) minionButtonPressed {
    CCNode *minion = [CCBReader load:@"Minions"];
    minion.position = ccp(0, _ground1.boundingBox.size.height + 11);
    [_minions addObject:minion];
    [self addChild:minion];
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
	_popLabel.visible = true;
	_enemyInterval = 0.f;
	_catapult = nil;
    _mouseJoint = nil;
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
	// add enemy minion
	_enemyInterval += delta;
	if (_enemyInterval > 20.f) {
		[self addEnemy];
		_enemyInterval = 0.f;
	}
	
	// update minion position
	for (CCNode *minion in _minions) {
        minion.position = ccp(minion.position.x + 25 * delta, minion.position.y);
		if (minion.position.x > screeSize.width) {
			[_toDelete addObject:minion];
		}
    }
	
	for (CCNode *enemy in _enemies) {
		enemy.position = ccp(enemy.position.x - 25 * delta, enemy.position.y);
		if (enemy.position.x < 0) {
			[_toDelete addObject:enemy];
		}
	}
	
	// check collision
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
	
	// check if any bone has reach the target height
	for (Bones *bone in _bones) {
		if (bone.position.y >= _cloud.position.y - 20) {
			// current bone has reach the top
			[self addCatapult:bone.position];
			break;
		}
	}
}

- (void)updatePopulation {
	_popLabel.string = [NSString stringWithFormat:@"%lu", [_minions count]];
	_popLabel.visible = true;
}

@end