//
//  BookDetailViewController.h
//  TextbookExchange
//
//  Created by Haley Elliott on 11/4/14.
//
//  Modified By JINGXIAN FENG on 12/2/14 with book cover.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface BookDetailViewController : UIViewController
{
    UIImage *image;
    __weak IBOutlet UIImageView *imageView;
}
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *authorL;
@property (weak, nonatomic) IBOutlet UILabel *isbnL;
@property (weak, nonatomic) IBOutlet UILabel *ownerL;
@property (weak, nonatomic) IBOutlet UILabel *tpL;

@property (strong, nonatomic) id detailItem;
@end
