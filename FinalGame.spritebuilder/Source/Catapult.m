//
//  Catapult.m
//  FinalGame
//
//  Created by Rainy Yang on 4/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Catapult.h"

@implementation Catapult

- (CCNode *) getArm {
    return _catapultArm;
}

- (CCNode *) getJointNode {
    return _mouseJointNode;
}

@end
