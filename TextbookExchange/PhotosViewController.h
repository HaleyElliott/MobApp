//
//  PhotosViewController.h
//  TextbookExchange
//
//  Created by Qihong Shen on 12/2/14.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <Parse/Parse.h>
#include <stdlib.h>

@interface PhotosViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, MBProgressHUDDelegate>
{
    __weak IBOutlet UIScrollView *photoScrollView;
    
    NSMutableArray *allImages;
    MBProgressHUD *HUD;
    MBProgressHUD *refreshHUD;
    
}
- (IBAction)refresh:(id)sender;
- (IBAction)cameraButtonTapped:(id)sender;

- (void)uploadImage:(NSData *)imageData;
- (void)setUpImages:(NSArray *)images;
- (void)buttonTouched:(id)sender;

@end
