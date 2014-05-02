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
    
    [self refreshGrid];
    
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
    for(NSInteger cellCounter = 0; cellCounter < 0; cellCounter++){
        NSInteger randomCellIndex = arc4random()%self.grid.cells.count-1;
        [self.grid toggleCellAtIndex:randomCellIndex];
    }
    
    self.cellViews = [NSMutableArray array];
    self.generation = 0;

}

- (void)refreshGrid{
    //remove all previous cell views...
    for(UIView *cellView in self.cellViews){
        [cellView removeFromSuperview];
    }
    [self.cellViews removeAllObjects];
    
    //draw the living cells...
    for(DGLCell *cell in self.grid.cells){
        if(cell.aliveThisTurn){
            [self drawCellAtIndex:[self.grid.cells indexOfObject:cell]];
        }
    }
}

- (void)resetGrid{
    //remove all previous cell views...
    for(UIView *cellView in self.cellViews){
        [cellView removeFromSuperview];
    }
    [self.cellViews removeAllObjects];
    
    for(DGLCell *cell in self.grid.cells){
        cell.aliveNextTurn = NO;
        cell.aliveThisTurn = NO;
    }
    
    self.generation = 0;
}

- (void)drawCellAtIndex:(NSInteger)cellIndex{
    
    //work out row  and xPos first...
    NSInteger row = cellIndex / floorf(self.grid.cellsPerRow);
    CGFloat yPos = row * self.grid.cellSize.height;
    
    //work out xPos...
    CGFloat xPos = (cellIndex - (row * self.grid.cellsPerRow)) * self.grid.cellSize.width;
    
    //generate a cell view at the calculated position...
    UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(xPos, yPos, self.grid.cellSize.width, self.grid.cellSize.height)];
    cellView.backgroundColor = [UIColor redColor];

    
    //add the cell to the grid view...
    [self.gridView addSubview:cellView];
    
    
    //add the cell the array so it can be removed at the start of the next step...
    [self.cellViews addObject:cellView];
    
}


- (void)scheduleNextSimulationStep{
    [self performSelector:@selector(tick) withObject:nil afterDelay:self.speed];
}

- (void)tick{
    //a single simulation step...
    self.generation++;
    self.generationLabel.text = [NSString stringWithFormat:@"Generation %li", (long)self.generation];
   
    [self updateCellStates];
    [self performSimulationStep];
    
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
    [self refreshGrid];
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
    [self refreshGrid];
    
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
    //[self setupGrid];
}

- (IBAction)speedSliderAction:(id)sender{
    UISlider *slider = (UISlider *)sender;
    NSLog(@"speedSliderAction - value = %f", slider.value);
    self.speed = 1.0 - slider.value;
}

@end
