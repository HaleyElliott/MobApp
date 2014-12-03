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



- (IBAction)savBookButt:(UIButton *)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"Books"];
    PFObject *temp = self.sentBook;
    // Retrieve the object by id
    [query getObjectInBackgroundWithId: temp.objectId block:^(PFObject *book, NSError *error) {
        
        // Now let's update it with some new data. In this case, only cheatMode and score
        // will get sent to the cloud. playerName hasn't changed.
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
