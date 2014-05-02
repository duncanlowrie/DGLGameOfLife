//
//  DGLCell.m
//  DGLGameOfLife
//
//  Created by Duncan Lowrie on 01/05/2014.
//  Copyright (c) 2014 Duncan Lowrie. All rights reserved.
//

#import "DGLCell.h"

@implementation DGLCell

- (id)init{
    self = [super init];
    if(self != nil){
        self.neighbourCells = [NSMutableArray array];
    }
    
    return self;
}

- (void)step{
    //apply life rules to determine if this cell lives or dies...
    
    //THE RULES:
    //1 - Any live cell with fewer than two live neighbours dies, as if caused by under-population.
    //2 - Any live cell with two or three live neighbours lives on to the next generation.
    //3 - Any live cell with more than three live neighbours dies, as if by overcrowding.
    //4 - Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
    
    NSInteger liveNeighbours = 0;
    for(DGLCell *cell in self.neighbourCells){
        if(cell.aliveThisTurn){
            liveNeighbours++;
        }
    }
    
    if(!self.aliveThisTurn && liveNeighbours == 3){
        //4:
        self.aliveNextTurn = YES;
        
    }else if(self.aliveThisTurn){
        if(liveNeighbours < 2){
            //1:
            self.aliveNextTurn = NO;
            
        }else if(liveNeighbours == 2 || liveNeighbours == 3){
            //2:
            self.aliveNextTurn = YES;
            
        }else if(liveNeighbours > 3){
            //3:
            self.aliveNextTurn = NO;
        }
    }
}

@end
