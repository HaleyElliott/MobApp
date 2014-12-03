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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Parse


#pragma mark - Table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.chatData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    chatCell *cell = (chatCell *)[tableView dequeueReusableCellWithIdentifier: @"chatCellIdentifier"];
    NSUInteger row = [self.chatData count]-[indexPath row]-1;
 
        NSString *chatText = [[self.chatData objectAtIndex:row] objectForKey:@"message"];
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        UIFont *font = [UIFont systemFontOfSize:14];
        CGSize size = [chatText sizeWithFont:font constrainedToSize:CGSizeMake(225.0f, 1000.0f) lineBreakMode:UILineBreakModeCharacterWrap];
        cell.textString.frame = CGRectMake(75, 14, size.width +20, size.height + 20);
        cell.textString.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        cell.textString.text = chatText;
        [cell.textString sizeToFit];
    
        cell.timeLabel.text = [[self.chatData objectAtIndex:row] objectForKey:@"createdAt"];
        
        cell.userLabel.text = [NSString stringWithFormat:@"%@:", [[self.chatData objectAtIndex:row] objectForKey:@"username"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellText = [[self.chatData objectAtIndex:self.chatData.count-indexPath.row-1] objectForKey:@"text"];
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:14.0];
    CGSize constraintSize = CGSizeMake(225.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    return labelSize.height + 40;
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"the text content%@",tfEntry.text);
    [textField resignFirstResponder];
    
    if (tfEntry.text.length>0) {
        // updating the table immediately
        NSArray *keys = [NSArray arrayWithObjects:@"text", @"userName", @"date", nil];
        NSArray *objects = [NSArray arrayWithObjects:tfEntry.text, userName, [NSDate date], nil];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        
        
        NSMutableArray *insertIndexPaths = [[NSMutableArray alloc] init];
        NSIndexPath *newPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [insertIndexPaths addObject:newPath];
        [chatTable beginUpdates];
        [chatTable insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationTop];
        [chatTable endUpdates];
        [chatTable reloadData];
        
        // going for the parsing
        PFObject *newMessage = [PFObject objectWithClassName:@"chatroom"];
        [newMessage setObject:tfEntry.text forKey:@"message"];
        [newMessage setObject:userName forKey:@"username"];
        [newMessage saveInBackground];
        [self loadTableData];
        tfEntry.text = @"";
    }
    
    return NO;
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
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y- keyboardFrame.size.height+TABBAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height)];
    
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
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + keyboardFrame.size.height-TABBAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height)];
    
    [UIView commitAnimations];
}
- (IBAction)senderButt:(UIButton *)sender {
    
    PFUser *currentUser = [PFUser currentUser];
    PFObject *chat = [PFObject objectWithClassName:@"ChatRoom"];
    chat[@"username"] = currentUser.username;
    chat[@"message"] = self.tfEntry.text;
    chat[@"chatRoom"] = self.chatRoom;
    [chat saveInBackground];
    [self.chatTable reloadData];

    
}
@end
