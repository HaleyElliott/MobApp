//
//  EditBookViewController.h
//  TextbookExchange
//
//  Created by Haley Elliott on 11/5/14.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EditBookViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImagePickerController *picker;
    UIImagePickerController *pickerLib;
    
    UIImage *image;
    __weak IBOutlet UIImageView *imageView;
}
- (IBAction)takePhoto:(id)sender;
- (IBAction)choosePic:(id)sender;
- (IBAction)clearImage:(id)sender;

- (IBAction)savBookButt:(UIButton *)sender;
- (IBAction)exchangedButt:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *titleLBL;
@property (weak, nonatomic) IBOutlet UITextField *authorLBL;
@property (weak, nonatomic) IBOutlet UITextField *isbnLBL;
@property (strong, nonatomic) id sentBook;
@end
