//
//  DGLCell.h
//  DGLGameOfLife
//
//  Created by Duncan Lowrie on 01/05/2014.
//  Copyright (c) 2014 Duncan Lowrie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DGLCell : NSObject

@property (nonatomic)BOOL aliveThisTurn;
@property (nonatomic)BOOL aliveNextTurn;
@property (nonatomic, strong)NSMutableArray *neighbourCells;
@property (nonatomic)CGRect cellFrame;

- (void)step;

@end
