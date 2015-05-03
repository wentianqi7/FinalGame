//
//  GameProperty.h
//  FinalGame
//
//  Created by Rainy Yang on 5/2/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface GameProperty : CCNode
+ (NSString *)getMaterial;
+ (void)setMaterial:(NSString *)name;
@end
