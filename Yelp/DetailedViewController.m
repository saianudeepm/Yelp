//
//  DetailedViewController.m
//  Yelp
//
//  Created by Sai Anudeep Machavarapu on 2/2/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "DetailedViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailedViewController()
@property Business *business;
@end

@implementation DetailedViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    Business *selectedBusiness = self.selectedBusiness;
    [self setBusinessDetailedView:selectedBusiness];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) setBusinessDetailedView:(Business*)business{
    
    //set the current views data
    [self.posterImageView setImageWithURL:[NSURL URLWithString:business.imageURL]];
    self.titleLabel.text = business.name;
    self.distanceLabel.text = [NSString stringWithFormat:@"%0.2lf mi",business.distance];
    [self.ratingImageView setImageWithURL:[NSURL URLWithString:business.ratingImageURL]];
    self.reviewsLabel.text = [NSString stringWithFormat:@"%ld Reviews",(long)business.numReviews ];
    self.addressLabel.text=[NSString stringWithFormat:@"Address: %@",business.address];
    self.categoryLabel.text= [NSString stringWithFormat:@"Category: %@",business.categories ];


}

@end
