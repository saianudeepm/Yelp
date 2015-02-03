//
//  YelpListingCell.h
//  Yelp
//
//  Created by Sai Anudeep Machavarapu on 1/29/15.
//  Copyright (c) 2015 salome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Business.h"
#import "AFNetworking.h"


@interface YelpListingCell : UITableViewCell 

@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView;
@property (weak, nonatomic) IBOutlet UILabel *reviewsLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *dollarLabel;

@property (strong,nonatomic) Business* business;

- (void) setBusiness: (Business*) business;
@end
