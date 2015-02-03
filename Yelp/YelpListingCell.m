//
//  YelpListingCell.m
//  Yelp
//
//  Created by Sai Anudeep Machavarapu on 1/29/15.
//  Copyright (c) 2015 salome. All rights reserved.
//

#import "YelpListingCell.h"
#import "UIImageView+AFNetworking.h"


@implementation YelpListingCell

- (void)awakeFromNib {
    // Initialization code
    self.posterImageView.layer.cornerRadius =3;
    self.posterImageView.clipsToBounds= YES;
    self.titleLabel.preferredMaxLayoutWidth = self.titleLabel.frame.size.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    

    // Configure the view for the selected state
}

- (void) setBusiness:(Business *) business{
    
    [self.posterImageView setImageWithURL:[NSURL URLWithString:business.imageURL]];
    self.titleLabel.text = business.name;
    self.distanceLabel.text = [NSString stringWithFormat:@"%0.2lf mi",business.distance];
    [self.ratingImageView setImageWithURL:[NSURL URLWithString:business.ratingImageURL]];
    self.reviewsLabel.text = [NSString stringWithFormat:@"%ld",(long)business.numReviews ];
    self.addressLabel.text=business.address;
    self.categoryLabel.text=business.categories;
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.preferredMaxLayoutWidth = self.titleLabel.frame.size.width;
}
@end
