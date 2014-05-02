//
//  DGLGridView.m
//  DGLGameOfLife
//
//  Created by Duncan Lowrie on 02/05/2014.
//  Copyright (c) 2014 Duncan Lowrie. All rights reserved.
//

#import "DGLGridView.h"
#import "DGLGrid.h"
#import "DGLCell.h"

@implementation DGLGridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // Drawing code
    if(self.grid == nil){
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor * redColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    
    CGContextSetFillColorWithColor(context, redColor.CGColor);
    
    //NSLog(@"gridView drawRect");
    
    //draw each cell in place...
    for(DGLCell *cell in self.grid.cells){
        if(cell.aliveThisTurn){
            CGContextFillRect(context, cell.cellFrame);
        }
    }
}


@end
