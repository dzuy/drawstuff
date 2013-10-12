//
//  ViewController.m
//  DrawStuff
//
//  Created by Dzuy Linh on 10/12/13.
//  Copyright (c) 2013 Dzuy Linh. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void) initDraw {
    draw_stuff = [[DrawStuffViewController alloc]init];
    [drawing_holder addSubview:draw_stuff.view];
    draw_stuff.delegate = self;
    [draw_stuff initDrawStuff:original_image.image];
}

#pragma mark - DrawStuff Delegate Methods
- (void) didFinishSavingImage:(UIImage *)image {
    final_image_view.image = image;
    
}


- (IBAction)startDrawingHandler:(id)sender {
    [self initDraw];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
