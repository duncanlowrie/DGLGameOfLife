//
//  DGLViewController.h
//  DGLGameOfLife
//
//  Created by Duncan Lowrie on 01/05/2014.
//  Copyright (c) 2014 Duncan Lowrie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DGLGrid.h"
#import "DGLGridView.h"

@interface DGLViewController : UIViewController

@property (nonatomic, strong)IBOutlet DGLGridView *gridView;
@property (nonatomic, strong)IBOutlet UILabel *generationLabel;
@property (nonatomic, strong)IBOutlet UILabel *populationLabel;
@property (nonatomic, strong)IBOutlet UIButton *startStopButton;
@property (nonatomic, strong)IBOutlet UIButton *resetButton;
@property (nonatomic, strong)IBOutlet UISlider *speedSlider;

@property (nonatomic, strong)DGLGrid *grid;
@property (nonatomic)NSInteger generation;
@property (nonatomic)NSInteger population;
@property (nonatomic)CGFloat speed;
@property (nonatomic)BOOL runningSimulation;

- (IBAction)startStopButtonAction:(id)sender;
- (IBAction)resetButtonAction:(id)sender;
- (IBAction)speedSliderAction:(id)sender;

@end
