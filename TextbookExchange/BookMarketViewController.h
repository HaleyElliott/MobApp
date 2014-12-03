//
//  BookMarketViewController.h
//  TextbookExchange
//
//  Created by Haley Elliott on 11/5/14.
//
//

#import <UIKit/UIKit.h>

@interface BookMarketViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UISearchDisplayDelegate>
@property (weak, nonatomic) IBOutlet UITableView *bookMarketTable;

@end
