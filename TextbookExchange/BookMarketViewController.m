//
//  BookMarketViewController.m
//  TextbookExchange
//
//  Created by Haley Elliott on 11/5/14.
//
//

#import "BookDetailViewController.h"
#import "BookMarketViewController.h"
#import <Parse/Parse.h>

@interface BookMarketViewController ()
@property NSArray* allBooks;
- (IBAction)sorter:(UIButton *)sender;
@property NSArray * searchResults;
@property BOOL checker;

@end

@implementation BookMarketViewController

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
    self.checker = FALSE;
    // Do any additional setup after loading the view.
    self.allBooks = [[NSArray alloc] init];
    self.searchResults = [[NSArray alloc] init];
    NSMutableArray * temp = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Books"];
    [query whereKey:@"exchanged" equalTo:@NO];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            for (PFObject *object in objects) {
                [temp addObject: object];
            }
        }
        else{
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
        self.allBooks = [NSArray arrayWithArray:temp];
        [self.bookMarketTable reloadData];
    }];
   // [self.searchDisplayController setActive:NO animated:YES];
}


-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.searchDisplayController.searchResultsTableView){
        return [self.searchResults count];
    }
    else{
        return self.allBooks.count;
    }
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   // UITableViewCell *cell = [self.bookMarketTable dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
     UITableViewCell *cell = [self.bookMarketTable dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.numberOfLines = 3;
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if(tableView == self.searchDisplayController.searchResultsTableView){
        PFObject *temp =self.searchResults[indexPath.row] ;
        NSString *tempStr = [NSString stringWithFormat:@"%@",
                             temp[@"title"]];
        
        cell.textLabel.text = tempStr;
        self.checker = TRUE;
    }
    else{
        PFObject *temp =self.allBooks[indexPath.row] ;
        NSString *tempStr = [NSString stringWithFormat:@"%@",
                             temp[@"title"]];
        
        cell.textLabel.text = tempStr;
        self.checker = FALSE;
    }
   
    return cell;
}

# pragma search bar

-(void) filterContentForSearchText:(NSString* )searchText scope:(NSString *)scope
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title beginswith[c] %@", searchText];
    self.searchResults = [self.allBooks filteredArrayUsingPredicate:predicate];
}

-(BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
    }


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation
*/
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
     if(self.checker == TRUE){
         if ([[segue identifier] isEqualToString:@"showBookDetail"]) {
             [self.searchDisplayController setActive:NO animated:YES];
             NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
             PFObject *object = self.searchResults[indexPath.row];
             [[segue destinationViewController] setDetailItem:object];
         }
     }
     else{
         if ([[segue identifier] isEqualToString:@"showBookDetail"]) {
             [self.searchDisplayController setActive:NO animated:YES];
             NSIndexPath *indexPath = [self.bookMarketTable indexPathForSelectedRow];
             PFObject *object = self.allBooks[indexPath.row];
             [[segue destinationViewController] setDetailItem:object];
         }

     }
}


- (IBAction)sorter:(UIButton *)sender {
    
    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    NSArray *descriptors = [NSArray arrayWithObject:valueDescriptor];
    self.allBooks = [self.allBooks sortedArrayUsingDescriptors:descriptors];
    [self.bookMarketTable reloadData];


}
@end
