//
//  DMChatRoomViewController.m
//  TextbookExchange
//
//  Created by Haley Elliott on 12/2/14.
//
//
#import "chatCell.h"
#import "DMChatRoomViewController.h"
#import "BookDetailViewController.h"
#define TABBAR_HEIGHT 49.0f
#define TEXTFIELD_HEIGHT 70.0f
#define MAX_ENTRIES_LOADED 25

@interface DMChatRoomViewController ()
- (IBAction)senderButt:(UIButton *)sender;

@end

@implementation DMChatRoomViewController
@synthesize tfEntry;
@synthesize chatTable;
NSString                *className;
NSString                *userName;
BOOL _reloading;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.newChat = false;
    self.chatData = [[NSArray alloc] init];
    tfEntry.delegate = self;
    tfEntry.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self registerForKeyboardNotifications];
   
        // Update the view.
    
}

- (void)setDetailItem:(id)newDetailItem
{
    if (_sentBook != newDetailItem) {
        _sentBook = newDetailItem;
        
        [self loadTableData];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self freeKeyboardNotifications];
}

-(void)loadTableData{
    PFUser *currentUser = [PFUser currentUser];
    userName = currentUser.username;
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    NSString *stringOne = currentUser.username;
    NSString *stringTwo = self.sentBook[@"ownerID"];
    
    NSComparisonResult result = [stringOne compare:stringTwo];
    
    if (result == NSOrderedAscending) // stringOne < stringTwo
    {
        self.chatRoom =[NSMutableString stringWithFormat:@"%@%@", stringOne, stringTwo];
    }
    else if (result == NSOrderedDescending) // stringOne > stringTwo
    {
        self.chatRoom =[NSMutableString stringWithFormat:@"%@%@", stringTwo, stringOne];
    }

    PFQuery *query = [PFQuery queryWithClassName:@"ChatRoom"];
    [query whereKey:@"chatRoom" equalTo:self.chatRoom];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            for (PFObject *object in objects) {
                [temp addObject: object];
            }
        }
        else{
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        self.chatData = [NSArray arrayWithArray:temp];
        [self.chatTable reloadData];
    }];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.chatData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    chatCell *cell = (chatCell *)[tableView dequeueReusableCellWithIdentifier: @"chatCellIdentifier"];
    NSUInteger row = [self.chatData count]-[indexPath row]-1;
 
        NSString *chatText = [[self.chatData objectAtIndex:row] objectForKey:@"message"];
        cell.textString.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        cell.textString.text = chatText;
        [cell.textString sizeToFit];
    
    PFObject *object = [self.chatData objectAtIndex:row]; // A PFObject
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"M/DD hh:mm"];
    NSString *date = [df stringFromDate:object.createdAt];
    
    
    
    
        cell.timeLabel.text = date;
        
        cell.userLabel.text = [NSString stringWithFormat:@"%@:", [[self.chatData objectAtIndex:row] objectForKey:@"username"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - Chat textfield
-(IBAction) textFieldDoneEditing : (id) sender
{
    NSLog(@"the text content%@",tfEntry.text);
    [sender resignFirstResponder];
    [tfEntry resignFirstResponder];
}

-(IBAction) backgroundTap:(id) sender
{
    [self.tfEntry resignFirstResponder];
}



-(void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


-(void) freeKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


-(void) keyboardWasShown:(NSNotification*)aNotification
{
    NSLog(@"Keyboard was shown");
    NSDictionary* info = [aNotification userInfo];
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y- keyboardFrame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    
    [UIView commitAnimations];
    
}

-(void) keyboardWillHide:(NSNotification*)aNotification
{
    NSLog(@"Keyboard will hide");
    NSDictionary* info = [aNotification userInfo];
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + keyboardFrame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    
    [UIView commitAnimations];
}
- (IBAction)senderButt:(UIButton *)sender {
    
    PFUser *currentUser = [PFUser currentUser];
    PFObject *chat = [PFObject objectWithClassName:@"ChatRoom"];
    chat[@"username"] = currentUser.username;
    chat[@"message"] = self.tfEntry.text;
    chat[@"chatRoom"] = self.chatRoom;
    [chat saveInBackground];
    self.tfEntry.text = @"";
    [self loadTableData];
    [self.chatTable reloadData];

    
}
@end
