//
//  MyBooksViewController.m
//  TextbookExchange
//
//  Created by Haley Elliott on 11/3/14.
//
//

#import "MyBooksViewController.h"
#import "BookDetailViewController.h"
#import <Parse/Parse.h>

@interface MyBooksViewController ()
@property NSMutableArray* books;
@property (weak, nonatomic) IBOutlet UITableView *bookListTable;

@end

@implementation MyBooksViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Do any additional setup after loading the view.
    self.books = [[NSMutableArray alloc] init];
    PFUser *currentUser = [PFUser currentUser];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Books"];
    [query whereKey:@"ownerID" equalTo:currentUser.username];
    [query whereKey:@"exchanged" equalTo:@NO];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                [self.books addObject: object];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        [self.bookListTable reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES - we will be able to delete all rows
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Perform the real delete action here. Note: you may need to check editing style
    //   if you do not perform delete only.
    PFObject *temp =self.books[indexPath.row];
    PFQuery *query = [PFQuery queryWithClassName:@"Books"];
    [query getObjectInBackgroundWithId:temp.objectId block:^(PFObject *deletedBook, NSError *error) {
        // Do something with the returned PFObject in the gameScore variable.
        [deletedBook deleteInBackground];
        [deletedBook saveInBackground];
        [self.books removeObjectAtIndex: indexPath.row];
        [self.bookListTable reloadData];
    }];
    
   
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.books.count;
}

-(UITableViewCell*) tableView:(UITableView *)bookListTable cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [bookListTable dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.numberOfLines = 3;
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    PFObject *temp =self.books[indexPath.row] ;
    //NSString *amt = [NSString stringWithFormat:@"%f",temp.amount];
    NSString *tempStr = [NSString stringWithFormat:@"%@",
                         temp[@"title"]];
    
    cell.textLabel.text = tempStr;
    return cell;
}

/*
#pragma mark - Navigation
*/
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.bookListTable indexPathForSelectedRow];
        PFObject *object = self.books[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }

}


@end
