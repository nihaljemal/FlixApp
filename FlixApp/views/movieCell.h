//
//  movieCell.h
//  FlixApp
//
//  Created by Nihal Riyadh Jemal on 6/28/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface movieCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *SynopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterLabel;

@end
