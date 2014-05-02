//
//  DGLViewController.m
//  DGLGameOfLife
//
//  Created by Duncan Lowrie on 01/05/2014.
//  Copyright (c) 2014 Duncan Lowrie. All rights reserved.
//

#import "DGLViewController.h"
#import "DGLCell.h"

@interface DGLViewController (){
    NSInteger currentlyTouchedCellIndex;
}

@end

@implementation DGLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"View Did Load");
    
    [self speedSliderAction:self.speedSlider];
    
    [self setupGrid];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)setupGrid{
    CGSize cellSize = CGSizeMake(10.0, 10.0);
    self.grid = [[DGLGrid alloc] initGridWithCellSize:cellSize];
    
    //fill in random cells...
    for(NSInteger cellCounter = 0; cellCounter < 200; cellCounter++){
        NSInteger randomCellIndex = arc4random()%self.grid.cells.count-1;
        [self.grid toggleCellAtIndex:randomCellIndex];
    }
    
    //pass grid reference to the grid view...
    self.gridView.grid = self.grid;
    
    [self updateGeneration:0];
}

- (void)resetGrid{
    //kill all cells...
    for(DGLCell *cell in self.grid.cells){
        cell.aliveNextTurn = NO;
        cell.aliveThisTurn = NO;
    }
    
    [self updateGeneration:0];
    [self refreshGridView];
}

- (void)refreshGridView{
    //update the gridView...
    [self.gridView setNeedsDisplay];
}

- (void)scheduleNextSimulationStep{
    [self performSelector:@selector(tick) withObject:nil afterDelay:self.speed];
}

- (void)updateGeneration:(NSInteger)newGeneration{
    self.generation = newGeneration;
     self.generationLabel.text = [NSString stringWithFormat:@"Generation %li", (long)self.generation];
}

- (void)tick{
    //a single simulation step...
    [self updateGeneration:self.generation+1];
   
    [self updateCellStates];
    [self performSimulationStep];
    
    [self refreshGridView];
    
    //schedule the next sim step...
    if(self.runningSimulation){
        [self scheduleNextSimulationStep];
    }
}

- (void)updateCellStates{
    for(DGLCell *cell in self.grid.cells){
        cell.aliveThisTurn = cell.aliveNextTurn;
    }
}

- (void)performSimulationStep{
    //NSLog(@"sim step!  generation = %i", self.generation);
    //run the a single step on each cell...
    for(DGLCell *cell in self.grid.cells){
        [cell step];
    }
}

- (void)toggleCellAtLocation:(CGPoint)location{
    //determine cell index and toggle the cell on/off...
    NSInteger row = floorf(location.y / self.grid.cellSize.height);
    NSInteger column = floorf(location.x / self.grid.cellSize.width);
    NSInteger cellIndex = (row * self.grid.cellsPerRow) + column;
    if(currentlyTouchedCellIndex != cellIndex){
        currentlyTouchedCellIndex = cellIndex;
        [self.grid toggleCellAtIndex:cellIndex];
    }
    
    [self refreshGridView];
}


#pragma mark touch handling...

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];
    [self toggleCellAtLocation:location];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];
    [self toggleCellAtLocation:location];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    currentlyTouchedCellIndex = -1;
}


#pragma mark IB Actions...

- (IBAction)startStopButtonAction:(id)sender{
    NSLog(@"startStopButtonAction fired");
    self.runningSimulation = !self.runningSimulation;
    if(self.runningSimulation){
        [self scheduleNextSimulationStep];
        [self.startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
    }else{
        [self.startStopButton setTitle:@"Start" forState:UIControlStateNormal];
    }
}

- (IBAction)resetButtonAction:(id)sender{
    NSLog(@"resetButtonAction fired");
    [self resetGrid];
}

- (IBAction)speedSliderAction:(id)sender{
    UISlider *slider = (UISlider *)sender;
    NSLog(@"speedSliderAction - value = %f", slider.value);
    self.speed = 1.0 - slider.value;
}

@end
