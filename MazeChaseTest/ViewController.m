//
//  ViewController.m
//  MazeChaseTest
//
//  Created by Andrey Shkulipa on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "PathFinder.h"

#define DOSTEPLOG(...) do{}while(0)

NSMutableArray* result = nil;
int ** table = NULL;
int finalRow = 9;
int finalColumn = 9;

void doStep(int i, int j, NSMutableArray* positionsArray);
void doStep(int i, int j, NSMutableArray* positionsArray)
{
    if(table[i][j] == 0)
    {
        DOSTEPLOG(@"Can't move to (%d, %d). Bailing...", i, j);
        return;
    }
    
    CGPoint p = CGPointMake(j, i);
    
    NSValue* pointValue = [NSValue valueWithCGPoint:p];
    
    [positionsArray addObject:pointValue];
    table[i][j] = 0;
    
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
    
    
    if(i == finalRow && j == finalColumn)
    {
        NSMutableArray* positionsArrayCopy = [positionsArray mutableCopy];
        [result addObject:positionsArrayCopy];
        
        //DOSTEPLOG(@"Restoring value at target position...");
        //table[i][j] = 1;
        DOSTEPLOG(@"Reached the target. positionsArray == %@", positionsArray);
        
        [positionsArrayCopy release];
    }
    else
    {
        DOSTEPLOG(@"making move to (%d, %d)", i, j+1);
        doStep(i, j+1, positionsArray);
        DOSTEPLOG(@"making move to (%d, %d)", i, j-1);
        doStep(i, j-1, positionsArray);
        DOSTEPLOG(@"making move to (%d, %d)", i+1, j);
        doStep(i+1, j, positionsArray);
        DOSTEPLOG(@"making move to (%d, %d)", i-1, j);
        doStep(i-1, j, positionsArray);
    }
    
    [positionsArray removeObjectIdenticalTo:pointValue];
    table[i][j] = 1;
}
//void doStep(int i, int j, NSMutableArray* positionsArray)
//{
//    if(table[i][j] == 0)
//    {
//        NSLog(@"Can't move to (%d, %d). Bailing...", i, j);
//        return;
//    }
//    
//    CGPoint p = CGPointMake(j, i);
//    
//    NSValue* pointValue = [NSValue valueWithCGPoint:p];
//    
//    [positionsArray addObject:pointValue];
//    table[i][j] = 0;
//    
//    NSLog(@"Zeroing out at (%d, %d). Now table looks like:", i, j);
//    for(int i = 0; i<11; ++i)
//    {
//        for(int j = 0; j < 11; ++j)
//        {
//            printf("%d", table[i][j]);
//        }
//        
//        printf("\n");
//    }
//    
//    
//    if(i == finalRow && j == finalColumn)
//    {
//        NSMutableArray* positionsArrayCopy = [positionsArray mutableCopy];
//        [result addObject:positionsArrayCopy];
//        
//        //NSLog(@"Restoring value at target position...");
//        //table[i][j] = 1;
//        NSLog(@"Reached the target. positionsArray == %@", positionsArray);
//        
//        [positionsArrayCopy release];
//    }
//    else
//    {
//        NSLog(@"making move to (%d, %d)", i, j+1);
//        doStep(i, j+1, positionsArray);
//        NSLog(@"making move to (%d, %d)", i, j-1);
//        doStep(i, j-1, positionsArray);
//        NSLog(@"making move to (%d, %d)", i+1, j);
//        doStep(i+1, j, positionsArray);
//        NSLog(@"making move to (%d, %d)", i-1, j);
//        doStep(i-1, j, positionsArray);
//    }
//    
//    [positionsArray removeObjectIdenticalTo:pointValue];
//    table[i][j] = 1;
//}

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"MAP" ofType:@""];
    NSString* map = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    
    NSArray* rows = [map componentsSeparatedByString:@"\n"];
    table = (int **)malloc([rows count] * sizeof(int *));
    
    for(int i = 0; i<[rows count]; ++i)
    {
        NSString* rowString = [rows objectAtIndex:i];
        int* rowArray = (int *)malloc([rowString length] * sizeof(int));
        table[i] = rowArray;
        for(int j = 0; j < [rowString length]; ++j)
        {
            unichar c = [rowString characterAtIndex:j];
            rowArray[j] = c - '0';
        }
    }
    
    for(int i = 0; i<[rows count]; ++i)
    {
        NSString* rowString = [rows objectAtIndex:i];
        for(int j = 0; j < [rowString length]; ++j)
        {
            printf("%d", table[i][j]);
        }
        
        printf("\n");
    }
    
    int initialRow = 1;
    int initialColumn = 1;
    
//    result = [[NSMutableArray alloc] init];
//    NSMutableArray* positionsArray = [[NSMutableArray alloc] init];
//    
//    NSLog(@"dummy before");    
//    doStep(initialRow, initialColumn, positionsArray);
//    NSLog(@"dummy after");
// 
//    NSLog(@"Printing results: ");
//    
//    for(NSArray * positions in result)
//    {
//        NSLog(@"%@", positions);
//        NSLog(@"\n\n");
//    }
    
    float sideLength = 320/11.;
    
    PathFinder* pf = [[PathFinder alloc] init];
    
    NSLog(@"dummy before");    
    NSArray* res = [pf createPathsForFromRow:initialRow andFromColumn:initialColumn toRow:finalRow andToColumn:finalColumn inMap:table];
    NSLog(@"dummy after");  
    
    NSLog(@"callCount == %d", callCount);

#if TARGET_CPU_ARM
    return;
#endif

    
    
//    NSInteger shortest = [[result objectAtIndex:0] count];
//    int index = 0;
//    
//    for(int i = 0; i < [result count]; ++i)
//    {
//        NSArray* positionsArray = [result objectAtIndex:i];
//        if([positionsArray count] < shortest)
//        {
//            shortest = [positionsArray count];
//            index = i;
//        }
//    }

    
    for(int i = 0; i < [res count]; ++i)
    {
        UIGraphicsBeginImageContext(CGSizeMake(320, 320));
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(ctx, [[UIColor whiteColor] CGColor]);
        CGContextFillRect(ctx, CGRectMake(0, 0, 320, 320));
        
        for(int k = 0; k < 11; ++k)
        {
            for(int j = 0; j < 11; ++j)
            {
                if(table[k][j] == 0)
                {
                    CGRect rect = CGRectMake(j*sideLength, k*sideLength, sideLength, sideLength);
                    CGContextSetFillColorWithColor(ctx, [[UIColor blackColor] CGColor]);
                    CGContextFillRect(ctx, rect);
                }
            }
        }
        
        NSArray* positionsArray = [res objectAtIndex:i];
        for(int k = 0; k < [positionsArray count]; ++k)
        {
            CGPoint p = [[positionsArray objectAtIndex:k] CGPointValue];
            CGRect rect = CGRectMake(p.x*sideLength, p.y*sideLength, sideLength, sideLength);
            CGContextSetFillColorWithColor(ctx, [[UIColor greenColor] CGColor]);
            CGContextFillRect(ctx, rect);
        }
        
        UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
        NSData* toWrite = UIImagePNGRepresentation(image);
        NSString* fileName = [NSString stringWithFormat:@"MAZE%d.PNG", i];
        [toWrite writeToFile:fileName atomically:YES];
        
        
        
        UIGraphicsPopContext();
    }
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
