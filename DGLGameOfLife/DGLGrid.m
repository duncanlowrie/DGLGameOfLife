//
//  DGLGrid.m
//  DGLGameOfLife
//
//  Created by Duncan Lowrie on 01/05/2014.
//  Copyright (c) 2014 Duncan Lowrie. All rights reserved.
//

#import "DGLGrid.h"
#import "DGLCell.h"

@implementation DGLGrid

- (id)initGridWithCellSize:(CGSize)cellSize{
    self = [super init];
    if(self != nil){
        [self setupGridWithCellSize:cellSize];
    }
    return self;
}


- (void)setupGridWithCellSize:(CGSize)cellSize{
    if(cellSize.width == 0 || cellSize.height == 0){
        cellSize = CGSizeMake(1.0, 1.0);
    }
    
    self.cellSize = cellSize;
    
    
    //determine number of rows and columns...
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    self.cellsPerRow = floorf(screenSize.height / cellSize.width);
    self.numberOfRows = floorf(screenSize.width / cellSize.height);
    
    
    // create cells array...
    self.cells = [NSMutableArray array];
    
    //fill array with cell objects...
    NSInteger numberOfCells = self.numberOfRows * self.cellsPerRow;
    for(NSInteger cellCount = 0; cellCount < numberOfCells; cellCount++){
        DGLCell *cell = [[DGLCell alloc] init];

        //work out yPos...
        NSInteger row = cellCount / floorf(self.cellsPerRow);
        CGFloat yPos = row * self.cellSize.height;
        
        //work out xPos...
        CGFloat xPos = (cellCount - (row * self.cellsPerRow)) * self.cellSize.width;
        
        //store the cell's frame...
        cell.cellFrame = CGRectMake(xPos, yPos, self.cellSize.width, self.cellSize.height);
        
        [self.cells addObject:cell];
    }
    
    
    //determine cell neighbours...
    for(DGLCell *cell in self.cells){
        [self calculateNeighboursForCell:cell atIndex:[self.cells indexOfObject:cell]];
    }
    
}


- (void)calculateNeighboursForCell:(DGLCell *)cell atIndex:(NSInteger)cellIndex{
    //determine neighbouring cells for provided cell...
    
    NSInteger neighbourIndex;
    DGLCell *neighbourCell;
    
    //NW
    if(cellIndex % self.cellsPerRow != 0){
        neighbourIndex = cellIndex - self.cellsPerRow - 1;
        if(neighbourIndex >= 0){
            neighbourCell = [self.cells objectAtIndex:neighbourIndex];
            [cell.neighbourCells addObject:neighbourCell];
        }
    }
    
    //N
    neighbourIndex = cellIndex - self.cellsPerRow;
    if(neighbourIndex >= 0){
        neighbourCell = [self.cells objectAtIndex:neighbourIndex];
        [cell.neighbourCells addObject:neighbourCell];
    }
    
    //NE
    if((cellIndex+1) % self.cellsPerRow != 0){
        neighbourIndex = cellIndex - self.cellsPerRow + 1;
        if(neighbourIndex >= 0){
            neighbourCell = [self.cells objectAtIndex:neighbourIndex];
            [cell.neighbourCells addObject:neighbourCell];
        }
    }
    
    //E
    if((cellIndex+1) % self.cellsPerRow != 0){
        neighbourIndex = cellIndex + 1;
        neighbourCell = [self.cells objectAtIndex:neighbourIndex];
        [cell.neighbourCells addObject:neighbourCell];
    }
    
    //SE
    if((cellIndex+1) % self.cellsPerRow != 0){
        neighbourIndex = cellIndex + self.cellsPerRow + 1;
        if(neighbourIndex < self.cells.count){
            neighbourCell = [self.cells objectAtIndex:neighbourIndex];
            [cell.neighbourCells addObject:neighbourCell];
        }
    }
    
    //S
    neighbourIndex = cellIndex + self.cellsPerRow;
    if(neighbourIndex < self.cells.count){
        neighbourCell = [self.cells objectAtIndex:neighbourIndex];
        [cell.neighbourCells addObject:neighbourCell];
    }
    
    //SW
    if(cellIndex % self.cellsPerRow != 0){
        neighbourIndex = cellIndex + self.cellsPerRow - 1;
        if(neighbourIndex < self.cells.count){
            neighbourCell = [self.cells objectAtIndex:neighbourIndex];
            [cell.neighbourCells addObject:neighbourCell];
        }
    }
    
    //W
    if(cellIndex % self.cellsPerRow != 0){
        neighbourIndex = cellIndex - 1;
        neighbourCell = [self.cells objectAtIndex:neighbourIndex];
        [cell.neighbourCells addObject:neighbourCell];
    }
}


- (void)toggleCellAtIndex:(NSInteger)cellIndex{
    //switch cell at provided index on or off...
    if(cellIndex >= 0 && cellIndex < self.cells.count){
        DGLCell *cell = [self.cells objectAtIndex:cellIndex];
        cell.aliveNextTurn = !cell.aliveNextTurn;
        cell.aliveThisTurn = cell.aliveNextTurn;
    }
    
}

@end
