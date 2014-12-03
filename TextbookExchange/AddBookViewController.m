//
//  AddBookViewController.m
//  TextbookExchange
//
//  Created by Haley Elliott on 11/3/14.
//
//

#import "AddBookViewController.h"
#import <Parse/Parse.h>

@interface AddBookViewController ()
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
    PFUser *currentUser = [PFUser currentUser];
    
    PFObject *book = [PFObject objectWithClassName:@"Books"];
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
    
}
@end
