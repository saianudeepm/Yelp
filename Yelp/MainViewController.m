//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "YelpListingCell.h"
#import "Business.h"
#import "FilterViewController.h"
#import "DetailedViewController.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate,FilterViewControllerDelegate, UISearchBarDelegate, MKMapViewDelegate>

@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSArray *businessListingArray;

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) YelpListingCell *dummyCell;

@property (nonatomic, strong) NSString* searchTerm;

- (void) fetchBusinessesWithQuery: (NSString *) query params:(NSDictionary *) params;

-(void) onFilterButtonPress;
-(void) updateMapData;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        /*
        [self.client searchWithTerm:@"Thai" params:nil success:^(AFHTTPRequestOperation *operation, id response) {
            //NSLog(@"response: %@", response);
            NSArray *yelpListingDictionaries = response[@"businesses"];
            self.businessListingArray = [Business businessWithDictionaries:yelpListingDictionaries];
            [self.tableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@", [error description]);
        }];
        */
        [self fetchBusinessesWithQuery:@"Restaurants" params:nil];

      
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // setting up the datasources and delegates
    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    
    //Register the table cell xib file
    UINib *nib = [UINib nibWithNibName:@"YelpListingCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"YelpListingCell"];

    //self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.title=@"Yelp";
    
    //set up the filter and map bar buttons
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterButtonPress)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStylePlain target:self action:@selector(onMapButtonPress)];
    
    //set up the search bar
    self.searchBar = [UISearchBar new];
    self.searchBar.delegate = self;
    [self.searchBar sizeToFit];
    self.searchTerm = @"Restaurants";
    self.searchBar.text=self.searchTerm;
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setClearButtonMode:UITextFieldViewModeWhileEditing];
    self.searchBar.barTintColor = [UIColor colorWithRed:255.0 / 255.0 green:0.0 / 255.0 blue:0.0 / 255.0 alpha:1];
    self.navigationItem.titleView = self.searchBar;
    

    
    //set up the map view
    self.mapView.showsUserLocation= YES;
    [self.mapView setHidden:YES];
    self.mapView.delegate = self;
    
    
    //hide the searchbar and keyboard when user touches the tablecell or the map
    UITapGestureRecognizer *tableGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    UITapGestureRecognizer *mapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    //[self.tableView addGestureRecognizer:tableGestureRecognizer];
    [self.mapView addGestureRecognizer:mapGestureRecognizer];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.businessListingArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YelpListingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YelpListingCell" forIndexPath:indexPath];
    cell.business = self.businessListingArray[indexPath.row];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self configureCell:self.dummyCell forRowAtIndexPath:indexPath];
    [self.dummyCell layoutIfNeeded];
    
    CGSize size = [self.dummyCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height+1;
}

- (YelpListingCell *)dummyCell {
    
    if (!_dummyCell) {
        _dummyCell = [self.tableView dequeueReusableCellWithIdentifier:@"YelpListingCell"];
    }
    return _dummyCell;
    
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[YelpListingCell class]])
    {
        YelpListingCell *textCell = (YelpListingCell *)cell;
        textCell.business = self.businessListingArray[indexPath.row];
    }
}

#pragma mark - tableview delegate methods
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideKeyboard];
}

// takes to movie detailed view
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // go to detailed page view on touch of cell only when no network error
    if (self.businessListingArray!=nil) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        DetailedViewController *dvc = [[DetailedViewController alloc] init];
        Business *selectedBusiness = [self.businessListingArray objectAtIndex:indexPath.row];
        [dvc setSelectedBusiness:selectedBusiness];
        [self.navigationController pushViewController:dvc animated:YES];
    }
    
}

#pragma mark - private methods

- (void) hideKeyboard {
    self.searchBar.text = self.searchTerm;
    [self.searchBar resignFirstResponder];
}

-(void) updateMapData{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(37.774866,-122.394556);
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 2000, 2000);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    
    for (Business *business in self.businessListingArray) {
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = CLLocationCoordinate2DMake(business.lat, business.lng);
        point.title = business.name;
        point.subtitle = business.categories;
        
        [self.mapView addAnnotation:point];
    }

}

- (void) fetchBusinessesWithQuery: (NSString *) query params:(NSDictionary *) params{
    [self.client searchWithTerm:query params:params success:^(AFHTTPRequestOperation *operation, id response) {
        //NSLog(@"response: %@", response);
        
        NSArray *yelpListingDictionaries = response[@"businesses"];
        self.businessListingArray = [Business businessWithDictionaries:yelpListingDictionaries];
        //if currently in map view then reload the map view
        if(![self.mapView isHidden])
            [self updateMapData];
        //else reload the table view
        else
            [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];

}

-(void) onFilterButtonPress {
    
    NSLog(@"Filter button pressed");
    FilterViewController *fc = [[FilterViewController alloc]init];
    
    fc.delegate = self;
    
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:fc];
    [self presentViewController:nc animated:YES completion:nil];
    
}

- (void)onMapButtonPress {
    
    if ([self.mapView isHidden]) {
        self.navigationItem.rightBarButtonItem.title = @"List";
        [self.tableView setHidden:YES];
        [self.mapView setHidden:NO];
        [self updateMapData];
        
       // [self updateMapWithValues];
    } else {
        self.navigationItem.rightBarButtonItem.title = @"Map";
        [self.tableView setHidden:NO];
        [self.mapView setHidden:YES];
        
        [self.tableView reloadData];
    }
    
    
}

#pragma mark - searchBar delegate methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"Searchbar search button is clicked :) with text: %@",searchBar.text);
    self.searchTerm=searchBar.text;
    [self fetchBusinessesWithQuery:self.searchTerm params:nil];
    //searchBar endEditing:YES];
    [searchBar resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText{
    NSLog(@"Searchbar search text changed :)");
}

#pragma mark - MapView delegate methods
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    [self hideKeyboard];

}

#pragma mark - Filter delegate methods

-(void) filterViewController:(FilterViewController *)filterViewController
            didChangeFilters:(NSDictionary *)filters{
    
    NSLog(@"Firing a Network request with the fitlers %@",filters);
    [self fetchBusinessesWithQuery:@"Restaurants" params:filters];
}

@end
