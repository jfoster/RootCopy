//
//  ViewController.m
//  RootBrowser
//
//  Created by Jacob on 25/01/2016.
//  Copyright © 2016 ETASoon. All rights reserved.
//

#import "ViewController.h"

#import <JGProgressHUD/JGProgressHUD.h>

@interface ViewController ()

@end

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];
}

-(IBAction)copySpringBoard:(id)sender {
    [self copyFile:@"/System/Library/CoreServices/SpringBoard.app"];
}
- (IBAction)copyFrameworks:(id)sender {
    [self copyFile:@"/System/Library/Frameworks"];
}
- (IBAction)copyPrivateFrameworks:(id)sender {
    [self copyFile:@"/System/Library/PrivateFrameworks"];
}

- (IBAction)copyApplications:(id)sender {
    [self copyFile:@"/Applications"];
}

- (IBAction)copyRingtones:(id)sender {
    [self copyFile:@"/Library/Ringtones"];
    [self copyFile:@"/System/Library/Audio/UISounds"];
}

- (IBAction)copyAll:(id)sender {
    [self copySpringBoard:sender];
    [self copyFrameworks:sender];
    [self copyPrivateFrameworks:sender];
    [self copyApplications:sender];
    [self copyRingtones:sender];
}

-(void)copyFile:(NSString*)path {
    NSString* file = path.lastPathComponent;
    NSLog(@"%@", file);
    
    NSString* newPath = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject.path stringByAppendingPathComponent:file];
    NSLog(@"%@", newPath);
    
    JGProgressHUD* hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
    hud.textLabel.text = @"Copying";
    hud.indicatorView = [[JGProgressHUDIndeterminateIndicatorView alloc] init];
    hud.interactionType = JGProgressHUDInteractionTypeBlockAllTouches;
    [hud showInView:self.view];
    
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        
        NSError* error = nil;
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:newPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:newPath error:&error];
            if (error) NSLog(@"error: %@", error);
        }
        
        [[NSFileManager defaultManager] copyItemAtPath:path toPath:newPath error:&error];
        if (error) NSLog(@"error: %@", error);
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            if (error) {
                hud.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
                hud.textLabel.text = error.localizedDescription;
            } else {
                hud.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
                hud.textLabel.text = @"Success";
            }
            [hud dismissAfterDelay:2.5 animated:YES];
        }];
    }];
}
@end
