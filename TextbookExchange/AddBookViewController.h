//
//  AddBookViewController.h
//  TextbookExchange
//
//  Created by Haley Elliott on 11/3/14.
//
//  Modified By JINGXIAN FENG on 12/2/14 with book cover.
//

#import <UIKit/UIKit.h>

@interface AddBookViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImagePickerController *picker;
    UIImagePickerController *pickerLib;
    
    UIImage *image;
    __weak IBOutlet UIImageView *imageView;
}
- (IBAction)takePhoto:(id)sender;
- (IBAction)choosePic:(id)sender;
- (IBAction)clearImage:(id)sender;

@end
