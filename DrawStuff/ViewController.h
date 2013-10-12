//
//  ViewController.h
//  DrawStuff
//
//  Created by Dzuy Linh on 10/12/13.
//  Copyright (c) 2013 Dzuy Linh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawStuffViewController.h"

@interface ViewController : UIViewController <DrawStuffDelegate> {
    DrawStuffViewController *draw_stuff;
    
    __weak IBOutlet UIImageView *original_image;
    __weak IBOutlet UIView *drawing_holder;
    __weak IBOutlet UIImageView *final_image_view;
}

- (IBAction) startDrawingHandler:(id)sender;

@end
