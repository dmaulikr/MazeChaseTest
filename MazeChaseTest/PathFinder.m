//
//  PathFinder.m
//  MazeChaseTest
//
//  Created by Andrey Shkulipa on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PathFinder.h"

#define PATHFINDERLOG(...) do{}while(0)

NSInteger** gMap_;
NSInteger gTargetRow_;
NSInteger gTargetColumn_;

int callCount = 0;

NSMutableArray* gResultingPaths_;


void makeMove(NSInteger row, NSInteger column, NSMutableArray* previousPositionsArray);
void makeMove(NSInteger row, NSInteger column, NSMutableArray* previousPositionsArray)
{
    ++callCount;
    
    if(gMap_[row][column] == 0)
    {
        PATHFINDERLOG(@"Can't move to (%d, %d). Bailing...", row, column);
        return;
    }
    
    CGPoint p = CGPointMake(column, row);
    
    NSValue* pointValue = [NSValue valueWithCGPoint:p];
    
    [previousPositionsArray addObject:pointValue];
    gMap_[row][column] = 0;
    
    //    DOSTEPLOG(@"Zeroing out at (%d, %d). Now table looks like:", i, j);
    //    for(int i = 0; i<11; ++i)
    //    {
    //        for(int j = 0; j < 11; ++j)
    //        {
    //            printf("%d", table[i][j]);
    //        }
    //        
    //        printf("\n");
    //    }
    
    
    if(row == gTargetRow_ && column == gTargetColumn_)
    {
        NSMutableArray* positionsArrayCopy = [previousPositionsArray mutableCopy];
        [gResultingPaths_ addObject:positionsArrayCopy];
        
        //DOSTEPLOG(@"Restoring value at target position...");
        //table[i][j] = 1;
        PATHFINDERLOG(@"Reached the target. positionsArray == %@", positionsArray);
        
        [positionsArrayCopy release];
    }
    else
    {
        makeMove(row, column+1, previousPositionsArray);
        makeMove(row, column-1, previousPositionsArray);
        makeMove(row+1, column, previousPositionsArray);
        makeMove(row-1, column, previousPositionsArray);
        
//        [self makeMoveToRow:row column:(column+1) withPreviousPositionsArray:positionsArray];
//        [self makeMoveToRow:row column:(column-1) withPreviousPositionsArray:positionsArray];
//        [self makeMoveToRow:(row+1) column:column withPreviousPositionsArray:positionsArray];
//        [self makeMoveToRow:(row-1) column:column withPreviousPositionsArray:positionsArray];
        //        DOSTEPLOG(@"making move to (%d, %d)", i, j+1);
        //        doStep(i, j+1, positionsArray);
        //        DOSTEPLOG(@"making move to (%d, %d)", i, j-1);
        //        doStep(i, j-1, positionsArray);
        //        DOSTEPLOG(@"making move to (%d, %d)", i+1, j);
        //        doStep(i+1, j, positionsArray);
        //        DOSTEPLOG(@"making move to (%d, %d)", i-1, j);
        //        doStep(i-1, j, positionsArray);
    }
    
    [previousPositionsArray removeObjectIdenticalTo:pointValue];
    gMap_[row][column] = 1;
}


@interface PathFinder()
{
    NSInteger** map_;
    NSInteger targetRow_;
    NSInteger targetColumn_;
}

@property (nonatomic, retain) NSMutableArray* resultingPaths;

- (void)makeMoveToRow:(NSInteger)row column:(NSInteger)column withPreviousPositionsArray:(NSMutableArray *)positionsArray;

@end

@implementation PathFinder

@synthesize resultingPaths;


- (id)init
{
    self = [super init];
    if(self)
    {
        [self setResultingPaths:[NSMutableArray array]];
        
        gResultingPaths_ = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)makeMoveToRow:(NSInteger)row column:(NSInteger)column withPreviousPositionsArray:(NSMutableArray *)positionsArray
{
    ++callCount;
    
    if(self->map_[row][column] == 0)
    {
        PATHFINDERLOG(@"Can't move to (%d, %d). Bailing...", row, column);
        return;
    }
    
    CGPoint p = CGPointMake(column, row);
    
    NSValue* pointValue = [NSValue valueWithCGPoint:p];
    
    [positionsArray addObject:pointValue];
    self->map_[row][column] = 0;
    
    //    DOSTEPLOG(@"Zeroing out at (%d, %d). Now table looks like:", i, j);
    //    for(int i = 0; i<11; ++i)
    //    {
    //        for(int j = 0; j < 11; ++j)
    //        {
    //            printf("%d", table[i][j]);
    //        }
    //        
    //        printf("\n");
    //    }
    
    
    if(row == self->targetRow_ && column == self->targetColumn_)
    {
        NSMutableArray* positionsArrayCopy = [positionsArray mutableCopy];
        [self->resultingPaths addObject:positionsArrayCopy];
        
        //DOSTEPLOG(@"Restoring value at target position...");
        //table[i][j] = 1;
        PATHFINDERLOG(@"Reached the target. positionsArray == %@", positionsArray);
        
        [positionsArrayCopy release];
    }
    else
    {
        [self makeMoveToRow:row column:(column+1) withPreviousPositionsArray:positionsArray];
        [self makeMoveToRow:row column:(column-1) withPreviousPositionsArray:positionsArray];
        [self makeMoveToRow:(row+1) column:column withPreviousPositionsArray:positionsArray];
        [self makeMoveToRow:(row-1) column:column withPreviousPositionsArray:positionsArray];
//        DOSTEPLOG(@"making move to (%d, %d)", i, j+1);
//        doStep(i, j+1, positionsArray);
//        DOSTEPLOG(@"making move to (%d, %d)", i, j-1);
//        doStep(i, j-1, positionsArray);
//        DOSTEPLOG(@"making move to (%d, %d)", i+1, j);
//        doStep(i+1, j, positionsArray);
//        DOSTEPLOG(@"making move to (%d, %d)", i-1, j);
//        doStep(i-1, j, positionsArray);
    }
    
    [positionsArray removeObjectIdenticalTo:pointValue];
    self->map_[row][column] = 1;
}

- (NSArray *)createPathsForFromRow:(NSInteger)fromRow andFromColumn:(NSInteger)fromColumn toRow:(NSInteger)toRow andToColumn:(NSInteger)toColumn inMap:(NSInteger **)map
{
    
    if(YES)
    {
        [[self resultingPaths] removeAllObjects];
        
        self->map_ = map;
        self->targetRow_ = toRow;
        self->targetColumn_ = toColumn;
        
        NSMutableArray* previousPositionsArray = [[NSMutableArray alloc] init];
        [self makeMoveToRow:fromRow column:fromColumn withPreviousPositionsArray:previousPositionsArray];
        [previousPositionsArray release];
        
        return [self resultingPaths];
    }
    else
    {
        [gResultingPaths_ removeAllObjects];
        
        gMap_ = map;
        gTargetRow_ = toRow;
        gTargetColumn_ = toColumn;
        
        NSMutableArray* previousPositionsArray = [[NSMutableArray alloc] init];
        makeMove(fromRow, fromColumn, previousPositionsArray);
        [previousPositionsArray release];
        
        return gResultingPaths_;
    }
    
    return nil;

}

@end

