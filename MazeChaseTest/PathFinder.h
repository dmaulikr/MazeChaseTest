//
//  PathFinder.h
//  MazeChaseTest
//
//  Created by Andrey Shkulipa on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

extern int callCount;

@interface PathFinder : NSObject


//- (NSArray *)createPathsFrom:(CGPoint)fromPoint to:(CGPoint)toPoint inMap:(NSInteger **)map;
- (NSArray *)createPathsForFromRow:(NSInteger)fromRow andFromColumn:(NSInteger)fromColumn toRow:(NSInteger)toRow andToColumn:(NSInteger)toColumn inMap:(NSInteger **)map;

@end
