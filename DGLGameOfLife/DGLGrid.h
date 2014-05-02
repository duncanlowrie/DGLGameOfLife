//
//  DGLGrid.h
//  DGLGameOfLife
//
//  Created by Duncan Lowrie on 01/05/2014.
//  Copyright (c) 2014 Duncan Lowrie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DGLGrid : NSObject

@property (nonatomic, strong)NSMutableArray *cells;
@property (nonatomic)NSInteger cellsPerRow;
@property (nonatomic)NSInteger numberOfRows;
@property (nonatomic)CGSize cellSize;

- (id)initGridWithCellSize:(CGSize)cellSize;
- (void)toggleCellAtIndex:(NSInteger)cellIndex;

@end
