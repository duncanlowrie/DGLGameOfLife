//
//  DGLGridView.h
//  DGLGameOfLife
//
//  Created by Duncan Lowrie on 02/05/2014.
//  Copyright (c) 2014 Duncan Lowrie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DGLGrid;

@interface DGLGridView : UIView

@property (nonatomic, weak)DGLGrid *grid;

@end
