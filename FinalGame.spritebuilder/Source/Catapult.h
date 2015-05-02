//
//  Catapult.h
//  FinalGame
//
//  Created by Rainy Yang on 4/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface Catapult : CCSprite {
    CCNode *_catapultArm;
    CCNode *_mouseJointNode;
    CCNode *_pullbackNode;
}

- (CCNode *) getArm;
- (CCNode *) getJointNode;

@end
