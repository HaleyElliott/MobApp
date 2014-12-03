//
//  AddBookViewController.m
//  TextbookExchange
//
//  Created by Haley Elliott on 11/3/14.
//
//  Modified By JINGXIAN FENG on 12/2/14 with book cover.
//

#import "AddBookViewController.h"
#import <Parse/Parse.h>

@interface AddBookViewController ()
@property UIAlertView *alert;
@property (weak, nonatomic) IBOutlet UITextField *authorTxt;
@property (weak, nonatomic) IBOutlet UITextField *ISBNtxt;
@property (weak, nonatomic) IBOutlet UITextField *titleTxt;
- (IBAction)AddBookBut:(UIButton *)sender;


@end

@implementation AddBookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Show no-cover image
    image = [UIImage imageNamed:@"book_cover_not_found.jpg"];
    [imageView setImage:image];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (IBAction)AddBookBut:(UIButton *)sender {
    [super viewDidLoad];
    
    // Convert book cover image to NSData and then using PFFile
    NSData *imageData = UIImagePNGRepresentation(image);
    PFFile *imageFile = [PFFile fileWithName:@"image.jpg" data:imageData];
    
    PFUser *currentUser = [PFUser currentUser];
    
    PFObject *book = [PFObject objectWithClassName:@"Books"];
    book[@"imageFile"] = imageFile;
    book[@"ISBN"] = _ISBNtxt.text;
    book[@"ownerID"] = currentUser.username;
    book[@"title"] = _titleTxt.text;
    book[@"author"]= _authorTxt.text;
    book[@"exchanged"] = @NO;
    [book saveInBackground];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Book Added"
                                                   message: @" "
                                                  delegate: self
                                         cancelButtonTitle:@"Okay"
                                         otherButtonTitles:nil];
    [alert show];
    _ISBNtxt.text = @"";
    _authorTxt.text = @"";
    _titleTxt.text =@"";
    image = [UIImage imageNamed:@"book_cover_not_found.jpg"];
    [imageView setImage:image];
}

- (IBAction)takePhoto:(id)sender {
    // Determine if there is a camera
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] == YES){
        picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        
        // Set source to the camera
        picker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        
        // Show image picker
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else{
        self.alert = [[UIAlertView alloc] initWithTitle:@"No Camera!" message:@"Sorry, you don't have a camera on this device." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [self.alert show];
    }
}

- (IBAction)choosePic:(id)sender {
    pickerLib = [[UIImagePickerController alloc] init];
    pickerLib.delegate = self;
    
    // Set source to the photo library
    pickerLib.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    
    // Show image picker
    [self presentViewController:pickerLib animated:YES completion:NULL];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    // Show image in the UIImageView
    [imageView setImage:image];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)clearImage:(id)sender {
    image = [UIImage imageNamed:@"book_cover_not_found.jpg"];
    [imageView setImage:image];
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
