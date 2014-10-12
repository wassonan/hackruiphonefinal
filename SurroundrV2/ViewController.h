//
//  ViewController.h
//  SurroundrV2
//
//  Created by Ben Kropf on 10/11/14.
//  Copyright (c) 2014 benkropf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property BOOL readyToStream;
@property char *ip;
@property char *port;
@property (strong, nonatomic) IBOutlet UILabel *testLabel;

@end

