//
//  EditBookViewController.m
//  TextbookExchange
//
//  Created by Haley Elliott on 11/5/14.
//
//

#import "EditBookViewController.h"
#import "BookDetailViewController.h"

@interface EditBookViewController ()
@property UIAlertView *alert;

@end

@implementation EditBookViewController


- (void)setDetailItem:(id)newDetailItem
{
    if (_sentBook != newDetailItem) {
        _sentBook = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}
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
    [self configureView];
}

-(void) configureView
{
    // Retrieving the image back involves calling one of the getData variants on the PFFile
    PFFile *imageFile = self.sentBook[@"imageFile"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            image = [UIImage imageWithData:imageData];
        }
        else {
            image = [UIImage imageNamed:@"book_cover_not_found.jpg"];
        }
        [imageView setImage:image];
    }];
    
    self.titleLBL.text = self.sentBook[@"title"];
    self.authorLBL.text = self.sentBook[@"author"];
    self.isbnLBL.text = self.sentBook[@"ISBN"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
/*
#pragma mark - Navigation
*/
// In a storyboard-based application, you will often want to do a little preparation before navigation



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

- (IBAction)savBookButt:(UIButton *)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"Books"];
    PFObject *temp = self.sentBook;
    // Convert book cover image to NSData and then using PFFile
    NSData *imageData = UIImagePNGRepresentation(image);
    PFFile *imageFile = [PFFile fileWithName:@"image.jpg" data:imageData];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId: temp.objectId block:^(PFObject *book, NSError *error) {
        
        // will get sent to the cloud. playerName hasn't changed.
        book[@"imageFile"] = imageFile;
        book[@"author"] = self.authorLBL.text;
        book[@"ISBN"] = self.isbnLBL.text;
        book[@"title"] = self.titleLBL.text;
        [book saveInBackground];
        self.sentBook = book;
    }];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Book Saved!"
                                                   message: @" "
                                                  delegate: self
                                         cancelButtonTitle:@"Okay"
                                         otherButtonTitles:nil];
    [alert show];
}

- (IBAction)exchangedButt:(UIButton *)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"Books"];
    PFObject *temp = self.sentBook;
    // Retrieve the object by id
    [query getObjectInBackgroundWithId: temp.objectId block:^(PFObject *book, NSError *error) {
        
        // Now let's update it with some new data. In this case, only cheatMode and score
        // will get sent to the cloud. playerName hasn't changed.
        book[@"exchanged"] = @YES;
        [book saveInBackground];
        self.sentBook = book;
    }];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
