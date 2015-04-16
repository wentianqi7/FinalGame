#import "MainScene.h"

@implementation MainScene {
	CCSprite *_addBoneArea1, *_addBoneArea2;
	CCSprite *tempBone;
	int angle;
}

- (void)didLoadFromCCB {
    self.userInteractionEnabled = TRUE;
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
	}
}

- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
	CGPoint touchLocation = [touch locationInNode:self];
	if (tempBone != nil) {
		tempBone.position = touchLocation;
	}
}

- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
	CGPoint touchLocation = [touch locationInNode:self];
	if (tempBone != nil) {
		[self addBoneTouchLocation:touchLocation:angle];
		[self removeChild:tempBone];
		tempBone = nil;
	}
}

- (void)addBoneTouchLocation:(CGPoint)touchLocation:(int)rotate {
    CCNode* bone = [CCBReader load:@"Bones"];
    bone.position = touchLocation;
	bone.rotation = rotate - 90;
    [_physicsNode addChild:bone];
	[_bones addObject:bone];
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
	if (_enemyInterval > 2.f) {
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
}

- (void)updatePopulation {
	_popLabel.string = [NSString stringWithFormat:@"%lu", [_minions count]];
	_popLabel.visible = true;
}

@end