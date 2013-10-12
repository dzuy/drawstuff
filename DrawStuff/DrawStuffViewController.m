//
//  DrawStuffViewController.m
//  DrawStuff
//
//  Created by Dzuy Linh on 10/12/13.
//  Copyright (c) 2013 Dzuy Linh. All rights reserved.
//

#import "DrawStuffViewController.h"

@interface DrawStuffViewController ()

@end

@implementation DrawStuffViewController

- (void) initDrawStuff:(UIImage*)orig_image {
    start_width = 8;
    end_width = 4;
    current_color = [UIColor redColor];
    draw_image_view.userInteractionEnabled = YES;
    draw_image_view.multipleTouchEnabled = YES;
    
    self.view.userInteractionEnabled = YES;
    self.view.multipleTouchEnabled = YES;
    
    paint_stroke_arr = [[NSMutableArray alloc]init];
 
    screen_width = [UIScreen mainScreen].bounds.size.width;
    screen_height = [UIScreen mainScreen].bounds.size.height;
    
    original_image_view.image = orig_image;
}

- (void) undo {
    if ([paint_stroke_arr count] == 1) {
        draw_image_view.image = nil;
        [paint_stroke_arr removeAllObjects];
    } else {
        draw_image_view.image = [paint_stroke_arr objectAtIndex:[paint_stroke_arr count]-2];
        [paint_stroke_arr removeLastObject];
    }
}

- (void) saveImage {
    UIGraphicsBeginImageContext(compiled_drawing_holder.bounds.size);
    [compiled_drawing_holder.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *final_image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.delegate didFinishSavingImage:final_image];
}


- (IBAction) undoHandler:(id)sender{
    if ([paint_stroke_arr count] > 0) {
        [self undo];
    }
}
- (IBAction) saveHandler:(id)sender {
    [self saveImage];
}

#pragma mark - Touch Handlers
- (CGPoint) calculateMidPointForPoint:(CGPoint)p1 andPoint:(CGPoint)p2 {
    return CGPointMake((p1.x+p2.x)/2, (p1.y+p2.y)/2);
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    previous_point = [touch locationInView:self.view];
    line_width = start_width;
}
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    pre_previous_point = previous_point;
    previous_point = [touch previousLocationInView:self.view];
    CGPoint currentPoint = [touch locationInView:self.view];
    
    // calculate mid point
    CGPoint mid1 = [self calculateMidPointForPoint:previous_point andPoint:pre_previous_point];
    CGPoint mid2 = [self calculateMidPointForPoint:currentPoint andPoint:previous_point];
    
    
    CGFloat scale = 1.0;
    if([[UIScreen mainScreen]respondsToSelector:@selector(scale)]) {
        CGFloat tmp = [[UIScreen mainScreen]scale];
        if (tmp > 1.5) {
            scale = 2.0;
        }
    }
    
    if(scale > 1.5) {
        UIGraphicsBeginImageContextWithOptions(draw_image_view.frame.size, NO, scale);
    } else {
        UIGraphicsBeginImageContext(draw_image_view.frame.size);
    }
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [current_color setStroke];
    
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), true);
    CGContextSetShouldAntialias(UIGraphicsGetCurrentContext(), true);
    
    [draw_image_view.image drawInRect:CGRectMake(0, 0, draw_image_view.frame.size.width, draw_image_view.frame.size.height)];
    
    CGContextMoveToPoint(context, mid1.x, mid1.y);
    CGContextAddQuadCurveToPoint(context, previous_point.x, previous_point.y, mid2.x, mid2.y);
    
    CGContextSetLineCap(context, kCGLineCapRound);
    
    CGFloat xDist = (previous_point.x - currentPoint.x); //[2]
    CGFloat yDist = (previous_point.y - currentPoint.y); //[3]
    CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist)); //[4]
    
    distance = distance / 10;
    
    if (distance > 10) {
        distance = 10.0;
    }
    
    distance = distance / 10;
    distance = distance * 3;
    
    if (end_width - distance > line_width) {
        line_width = line_width + 0.3;
    } else {
        line_width = line_width - 0.3;
    }
    
    CGContextSetLineWidth(context, line_width);
    CGContextStrokePath(context);
    
    draw_image_view.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSLog(@"drawing shit");
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    
    if ([touch tapCount] == 1) {
        
        CGFloat scale = 1.0;
        if([[UIScreen mainScreen]respondsToSelector:@selector(scale)]) {
            CGFloat tmp = [[UIScreen mainScreen]scale];
            if (tmp > 1.5) {
                scale = 2.0;
            }
        }
        
        if(scale > 1.5) {
            UIGraphicsBeginImageContextWithOptions(draw_image_view.frame.size, NO, scale);
        } else {
            UIGraphicsBeginImageContext(draw_image_view.frame.size);
        }
        
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        [current_color setStroke];
        
        CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), true);
        CGContextSetShouldAntialias(UIGraphicsGetCurrentContext(), true);
        
        [draw_image_view.image drawInRect:CGRectMake(0, 0, draw_image_view.frame.size.width, draw_image_view.frame.size.height)];
        
        CGContextMoveToPoint(context, currentPoint.x, currentPoint.y);
        CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
        
        CGContextSetLineCap(context, kCGLineCapRound);
        
        CGContextSetLineWidth(context, 4.0);
        
        CGContextStrokePath(context);
        
        draw_image_view.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    [paint_stroke_arr addObject:draw_image_view.image];
}


#pragma mark - View Lifecycle
- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
