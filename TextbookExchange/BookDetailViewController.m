//
//  BookDetailViewController.m
//  TextbookExchange
//
//  Created by Haley Elliott on 11/4/14.
//
//  Modified By JINGXIAN FENG on 12/2/14 with book cover.
//

#import "BookDetailViewController.h"
#import "EditBookViewController.h"
#import "DMChatRoomViewController.h"

@interface BookDetailViewController ()
@property (weak, nonatomic) IBOutlet UIButton *editButt;
@property (weak, nonatomic) IBOutlet UIButton *chatterButt;

@property (weak, nonatomic) IBOutlet UITextView *emailTView;
- (void)configureView;
@end

@implementation BookDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    
    if (self.detailItem) {
       
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:self.detailItem[@"ownerID"]]; // find all the women
        NSArray *girls = [query findObjects];
        PFUser * user = [girls objectAtIndex:0];
        // Retrieving the image back involves calling one of the getData variants on the PFFile
        PFFile *imageFile = self.detailItem[@"imageFile"];
        [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                image = [UIImage imageWithData:imageData];
            }
            else {
                image = [UIImage imageNamed:@"book_cover_not_found.jpg"];
            }
            [imageView setImage:image];
        }];
    
        self.titleL.text =[self.detailItem objectForKey:@"title"];
        self.authorL.text = self.detailItem[@"author"];
        self.isbnL.text = self.detailItem[@"ISBN"];
        self.ownerL.text = user.username;
        self.tpL.text = [NSString stringWithFormat:@"%d", [[user objectForKey:@"points"] intValue]];
        self.emailTView.text = user.email;
        
        
        self.emailTView.editable = NO;
        self.emailTView.dataDetectorTypes = UIDataDetectorTypeAll;
        
        PFUser *currentUser = [PFUser currentUser];
        if([self.detailItem[@"ownerID"] isEqualToString:currentUser.username]){
            self.editButt.hidden = NO;
            self.chatterButt.hidden = YES;
        }
        else{
            self.editButt.hidden = YES;
            self.chatterButt.hidden = NO;
        }
      
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"editBook"]) {
        PFObject *object = self.detailItem;
        [[segue destinationViewController] setDetailItem:object];
    }
    else if ([[segue identifier] isEqualToString:@"chatter"]) {
        PFObject *object = self.detailItem;
        [[segue destinationViewController] setDetailItem:object];
    }
    
}


@end
