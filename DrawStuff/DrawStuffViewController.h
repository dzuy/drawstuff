//
//  DrawStuffViewController.h
//  DrawStuff
//
//  Created by Dzuy Linh on 10/12/13.
//  Copyright (c) 2013 Dzuy Linh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DrawStuffDelegate <NSObject>

@optional
- (void) didFinishSavingImage:(UIImage*)image;

@end

@interface DrawStuffViewController : UIViewController {
    __weak IBOutlet UIImageView *draw_image_view;
    __weak IBOutlet UIImageView *original_image_view;
    
    __weak IBOutlet UIView *compiled_drawing_holder;
    __weak IBOutlet UIView *ui_holder;
    
    UIColor *current_color;
    CGPoint last_point;
    CGPoint pre_previous_point;
    CGPoint previous_point;
    CGFloat line_width;
    
    CGFloat start_width;
    CGFloat end_width;
    
    float screen_width;
    float screen_height;
    
    NSMutableArray *paint_stroke_arr;
}

@property (nonatomic, retain) id<DrawStuffDelegate>delegate;

- (void) initDrawStuff:(UIImage*)orig_image;

- (IBAction) undoHandler:(id)sender;
- (IBAction) saveHandler:(id)sender;

@end
