//
//  FilterViewController.m
//  Yelp
//
//  Created by Sai Anudeep Machavarapu on 1/31/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "FilterViewController.h"
#import "SwitchCell.h"
#import "PriceFilterCell.h"
#import "PreferenceCell.h"

@interface FilterViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,readonly) NSDictionary* filters;

@property (nonatomic,strong) NSArray* categories;
@property (nonatomic,strong) NSMutableSet* selectedCategories;

@property(nonatomic,strong) NSArray* mostPopularOptions;
@property(nonatomic,strong) NSMutableSet* selectedMostPopular;

@property(nonatomic,strong) NSArray* distanceOptions;
@property(nonatomic,assign) NSInteger selectedDistanceOption;

@property(nonatomic,strong)NSArray* sortByOptions;
@property(nonatomic,assign) NSInteger selectedSortByOption;

@property(nonatomic,strong) NSMutableArray* isSectionExpanded;



-(void)initCategories;
-(void)initMostPopular;
-(void)initDistanceOptions;
-(void)initSortByOptions;

@end

@implementation FilterViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self =  [super initWithNibName:nibNameOrNil bundle:nil];
    if (self){
        [self initMostPopular];
        [self initCategories];
        [self initDistanceOptions];
        [self initSortByOptions];
        self.selectedCategories = [[NSMutableSet alloc] init];
        self.isSectionExpanded = [[NSMutableArray alloc] initWithArray:@[@NO, @NO, @NO, @NO, @YES ]];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // setup the bar buttons.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(onApplyButton)];
    
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
   
    //set up the table view
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"PriceFilterCell" bundle:nil] forCellReuseIdentifier:@"PriceFilterCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil] forCellReuseIdentifier:@"SwitchCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PreferenceCell" bundle:nil] forCellReuseIdentifier:@"PreferenceCell"];
    
        self.title = @"Filters";
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    BOOL isExpanded = [self.isSectionExpanded[section] boolValue];
    NSLog(@"Section : %ld state expanded:%@",section,self.isSectionExpanded[section]);
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 1;
        case 1:
            return  self.mostPopularOptions.count;
        case 2:
            if (isExpanded){
                NSLog(@"distance has %ld options",self.distanceOptions.count);
                return self.distanceOptions.count;
            }
            else{
                return 1;
            }
        case 3:
            if (isExpanded){
                NSLog(@"sortby has %ld options",self.sortByOptions.count);
                return self.sortByOptions.count;
            }
            else{
                return 1;
            }
        case 4:
            return self.categories.count;
    }
    return 0;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIColor *bgColor = [UIColor colorWithRed:245 green:245 blue:241 alpha:100];
    tableHeaderView.backgroundColor= bgColor;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 320, 44)];
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
    titleLabel.textColor = [UIColor blackColor];
    
    switch (section) {
        case 0:
            titleLabel.text=@"Price";
            break;
        case 1:
            titleLabel.text=@"Most Popular";
            break;
        case 2:
            titleLabel.text= @"Distance";
            break;
        case 3:
            titleLabel.text= @"Sort by";
            break;
        case 4:
            titleLabel.text= @"Categories";
            break;
    }
    [tableHeaderView addSubview:titleLabel];
    return tableHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell=nil;
    
    SwitchCell *switchCell = nil;
    PriceFilterCell *priceFilterCell = nil;
    PreferenceCell *preferenceCell = nil;
    switch (indexPath.section) {
        case 0:
            priceFilterCell = [tableView dequeueReusableCellWithIdentifier:@"PriceFilterCell" forIndexPath:indexPath];
            cell=priceFilterCell;
            return priceFilterCell;
        
        case 1:
            switchCell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell" forIndexPath:indexPath];
            switchCell.titleLabel.text = self.mostPopularOptions[indexPath.row];
            switchCell.delegate = self;
            switchCell.on = [self.selectedMostPopular containsObject:self.mostPopularOptions[indexPath.row]];
            cell=switchCell;
            return switchCell;
        case 2:
            preferenceCell =[tableView dequeueReusableCellWithIdentifier:@"PreferenceCell" forIndexPath:indexPath];
            preferenceCell.titleLabel.text = self.distanceOptions[indexPath.row];
            // if not expanded
            if(![self.isSectionExpanded[indexPath.section] boolValue]){
                preferenceCell.titleLabel.text = self.distanceOptions[self.selectedDistanceOption];
                //if row 0
                if(indexPath.row==0){
                    preferenceCell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"downArrow.png"]];
                }
            }
            // if expanded
            else{
                preferenceCell.titleLabel.text = self.distanceOptions[indexPath.row];
                // if current cell is selected one then use 'selected' image
                if(self.selectedDistanceOption== indexPath.row){
                    preferenceCell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"circleSelected"]];
                }
                else{
                    preferenceCell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"circleUnselected"]];
                }
            }
            
            return preferenceCell;
        
        case 3:
            preferenceCell =[tableView dequeueReusableCellWithIdentifier:@"PreferenceCell" forIndexPath:indexPath];
            // if not expanded
            if(![self.isSectionExpanded[indexPath.section] boolValue]){
                preferenceCell.titleLabel.text = self.sortByOptions[self.selectedSortByOption];
                //if row 0
                if(indexPath.row==0){
                    preferenceCell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"downArrow.png"]];
                }
            }
            // if expanded
            else{
                preferenceCell.titleLabel.text = self.sortByOptions[indexPath.row];
                // if current cell is selected one then use 'selected' image
                if(self.selectedSortByOption== indexPath.row){
                    preferenceCell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"circleSelected"]];
                }
                else{
                    preferenceCell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"circleUnselected"]];
                }
            }
            return preferenceCell;
        case 4:
            NSLog(@"calling for section %ld, row: %ld ",indexPath.section, indexPath.row);
            switchCell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell" forIndexPath:indexPath];
            switchCell.titleLabel.text = self.categories[indexPath.row][@"name"];
            switchCell.on = [self.selectedCategories containsObject:self.categories[indexPath.row]];
            switchCell.delegate = self;
            cell=switchCell;
            return switchCell;

       
    }
    NSLog(@"indexpath is :%@ and row num is :%ld",indexPath,indexPath.row);
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
   if (indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 4)
        return;
    
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:(NSInteger) indexPath.section];
    BOOL isExpanded = [self.isSectionExpanded[(NSInteger) indexPath.section] boolValue];
    self.isSectionExpanded[(NSInteger) indexPath.section] = @(!isExpanded);
    
    switch (indexPath.section) {
        case 2:
            if (isExpanded) {
                self.selectedDistanceOption = indexPath.row;
            }
            break;
        case 3:
            if (isExpanded) {
                self.selectedSortByOption = indexPath.row;
            }
            break;
    }
    
    [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];

}

#pragma mark -SwitchCell Delegate
-(void) switchCell:(SwitchCell *)switchCell didUpdatevalue:(BOOL)value{
    //when switch state is changed update the selected categories set accordingly
    NSLog(@"Switch cell toggled to  %i", value);
    NSIndexPath *indexPath = [self.tableView indexPathForCell:switchCell];
    
    switch (indexPath.section) {
        //for most popular
        case 2:
            if(value == 1){
                NSLog(@"Switch cell switched ON for %@",switchCell.titleLabel.text);
                [self.selectedMostPopular addObject:self.mostPopularOptions[indexPath.row]];
            }
            if(value==0){
                NSLog(@"Switch cell switched OFF for  %@",switchCell.titleLabel.text);
                [self.selectedMostPopular removeObject:self.mostPopularOptions[indexPath.row]];
            }
            break;
            //for categories
        case 4:
            if(value == 1){
                NSLog(@"Switch cell switched ON for %@",switchCell.titleLabel.text);
                [self.selectedCategories addObject:self.categories[indexPath.row]];
            }
            if(value==0){
                NSLog(@"Switch cell switched OFF for  %@",switchCell.titleLabel.text);
                [self.selectedCategories removeObject:self.categories[indexPath.row]];
            }
            break;

    }
    
}


#pragma -mark private methods

- (NSDictionary *) filters{
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];
    if (self.selectedCategories.count > 0) {
        NSMutableArray *names = [NSMutableArray array];
        for (NSDictionary *category in self.selectedCategories) {
            [names addObject:category[@"code"]];
        }
        
        NSString *categoryFilter = [names componentsJoinedByString:@","];
        filters[@"category_filter"] = categoryFilter;
    }
    return filters;

}

- (void) onCancelButton{

    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void) onApplyButton{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    // pass the dictionary to the delegate method so that who ever implements this delegate can handle it accordingly
    [self.delegate filterViewController:self didChangeFilters:self.filters];
}

#pragma mark - initializations

- (void) initSortByOptions{
    self.sortByOptions = @[@"Best Match", @"Distance", @"Rating", @"Most Reviewed"];
}

- (void) initDistanceOptions{
    self.distanceOptions = @[@"Best Match", @"0.3 miles", @"1 mile", @"5 miles", @"20 miles"];
}
-(void) initMostPopular{
    self.mostPopularOptions= @[@"Open Now", @"Hot & New", @"Offering a Deal", @"Delivery"];

}
-(void) initCategories{
    self.categories = @[@{@"name" : @"Afghan", @"code": @"afghani" },
                        @{@"name" : @"African", @"code": @"african" },
                        @{@"name" : @"American, New", @"code": @"newamerican" },
                        @{@"name" : @"American, Traditional", @"code": @"tradamerican" },
                        @{@"name" : @"Arabian", @"code": @"arabian" },
                        @{@"name" : @"Argentine", @"code": @"argentine" },
                        @{@"name" : @"Armenian", @"code": @"armenian" },
                        @{@"name" : @"Asian Fusion", @"code": @"asianfusion" },
                        @{@"name" : @"Asturian", @"code": @"asturian" },
                        @{@"name" : @"Australian", @"code": @"australian" },
                        @{@"name" : @"Austrian", @"code": @"austrian" },
                        @{@"name" : @"Baguettes", @"code": @"baguettes" },
                        @{@"name" : @"Bangladeshi", @"code": @"bangladeshi" },
                        @{@"name" : @"Barbeque", @"code": @"bbq" },
                        @{@"name" : @"Basque", @"code": @"basque" },
                        @{@"name" : @"Bavarian", @"code": @"bavarian" },
                        @{@"name" : @"Beer Garden", @"code": @"beergarden" },
                        @{@"name" : @"Beer Hall", @"code": @"beerhall" },
                        @{@"name" : @"Beisl", @"code": @"beisl" },
                        @{@"name" : @"Belgian", @"code": @"belgian" },
                        @{@"name" : @"Bistros", @"code": @"bistros" },
                        @{@"name" : @"Black Sea", @"code": @"blacksea" },
                        @{@"name" : @"Brasseries", @"code": @"brasseries" },
                        @{@"name" : @"Brazilian", @"code": @"brazilian" },
                        @{@"name" : @"Breakfast & Brunch", @"code": @"breakfast_brunch" },
                        @{@"name" : @"British", @"code": @"british" },
                        @{@"name" : @"Buffets", @"code": @"buffets" },
                        @{@"name" : @"Bulgarian", @"code": @"bulgarian" },
                        @{@"name" : @"Burgers", @"code": @"burgers" },
                        @{@"name" : @"Burmese", @"code": @"burmese" },
                        @{@"name" : @"Cafes", @"code": @"cafes" },
                        @{@"name" : @"Cafeteria", @"code": @"cafeteria" },
                        @{@"name" : @"Cajun/Creole", @"code": @"cajun" },
                        @{@"name" : @"Cambodian", @"code": @"cambodian" },
                        @{@"name" : @"Canadian", @"code": @"New)" },
                        @{@"name" : @"Canteen", @"code": @"canteen" },
                        @{@"name" : @"Caribbean", @"code": @"caribbean" },
                        @{@"name" : @"Catalan", @"code": @"catalan" },
                        @{@"name" : @"Chech", @"code": @"chech" },
                        @{@"name" : @"Cheesesteaks", @"code": @"cheesesteaks" },
                        @{@"name" : @"Chicken Shop", @"code": @"chickenshop" },
                        @{@"name" : @"Chicken Wings", @"code": @"chicken_wings" },
                        @{@"name" : @"Chilean", @"code": @"chilean" },
                        @{@"name" : @"Chinese", @"code": @"chinese" },
                        @{@"name" : @"Comfort Food", @"code": @"comfortfood" },
                        @{@"name" : @"Corsican", @"code": @"corsican" },
                        @{@"name" : @"Creperies", @"code": @"creperies" },
                        @{@"name" : @"Cuban", @"code": @"cuban" },
                        @{@"name" : @"Curry Sausage", @"code": @"currysausage" },
                        @{@"name" : @"Cypriot", @"code": @"cypriot" },
                        @{@"name" : @"Czech", @"code": @"czech" },
                        @{@"name" : @"Czech/Slovakian", @"code": @"czechslovakian" },
                        @{@"name" : @"Danish", @"code": @"danish" },
                        @{@"name" : @"Delis", @"code": @"delis" },
                        @{@"name" : @"Diners", @"code": @"diners" },
                        @{@"name" : @"Dumplings", @"code": @"dumplings" },
                        @{@"name" : @"Eastern European", @"code": @"eastern_european" },
                        @{@"name" : @"Ethiopian", @"code": @"ethiopian" },
                        @{@"name" : @"Fast Food", @"code": @"hotdogs" },
                        @{@"name" : @"Filipino", @"code": @"filipino" },
                        @{@"name" : @"Fish & Chips", @"code": @"fishnchips" },
                        @{@"name" : @"Fondue", @"code": @"fondue" },
                        @{@"name" : @"Food Court", @"code": @"food_court" },
                        @{@"name" : @"Food Stands", @"code": @"foodstands" },
                        @{@"name" : @"French", @"code": @"french" },
                        @{@"name" : @"French Southwest", @"code": @"sud_ouest" },
                        @{@"name" : @"Galician", @"code": @"galician" },
                        @{@"name" : @"Gastropubs", @"code": @"gastropubs" },
                        @{@"name" : @"Georgian", @"code": @"georgian" },
                        @{@"name" : @"German", @"code": @"german" },
                        @{@"name" : @"Giblets", @"code": @"giblets" },
                        @{@"name" : @"Gluten-Free", @"code": @"gluten_free" },
                        @{@"name" : @"Greek", @"code": @"greek" },
                        @{@"name" : @"Halal", @"code": @"halal" },
                        @{@"name" : @"Hawaiian", @"code": @"hawaiian" },
                        @{@"name" : @"Heuriger", @"code": @"heuriger" },
                        @{@"name" : @"Himalayan/Nepalese", @"code": @"himalayan" },
                        @{@"name" : @"Hong Kong Style Cafe", @"code": @"hkcafe" },
                        @{@"name" : @"Hot Dogs", @"code": @"hotdog" },
                        @{@"name" : @"Hot Pot", @"code": @"hotpot" },
                        @{@"name" : @"Hungarian", @"code": @"hungarian" },
                        @{@"name" : @"Iberian", @"code": @"iberian" },
                        @{@"name" : @"Indian", @"code": @"indpak" },
                        @{@"name" : @"Indonesian", @"code": @"indonesian" },
                        @{@"name" : @"International", @"code": @"international" },
                        @{@"name" : @"Irish", @"code": @"irish" },
                        @{@"name" : @"Island Pub", @"code": @"island_pub" },
                        @{@"name" : @"Israeli", @"code": @"israeli" },
                        @{@"name" : @"Italian", @"code": @"italian" },
                        @{@"name" : @"Japanese", @"code": @"japanese" },
                        @{@"name" : @"Jewish", @"code": @"jewish" },
                        @{@"name" : @"Kebab", @"code": @"kebab" },
                        @{@"name" : @"Korean", @"code": @"korean" },
                        @{@"name" : @"Kosher", @"code": @"kosher" },
                        @{@"name" : @"Kurdish", @"code": @"kurdish" },
                        @{@"name" : @"Laos", @"code": @"laos" },
                        @{@"name" : @"Laotian", @"code": @"laotian" },
                        @{@"name" : @"Latin American", @"code": @"latin" },
                        @{@"name" : @"Live/Raw Food", @"code": @"raw_food" },
                        @{@"name" : @"Lyonnais", @"code": @"lyonnais" },
                        @{@"name" : @"Malaysian", @"code": @"malaysian" },
                        @{@"name" : @"Meatballs", @"code": @"meatballs" },
                        @{@"name" : @"Mediterranean", @"code": @"mediterranean" },
                        @{@"name" : @"Mexican", @"code": @"mexican" },
                        @{@"name" : @"Middle Eastern", @"code": @"mideastern" },
                        @{@"name" : @"Milk Bars", @"code": @"milkbars" },
                        @{@"name" : @"Modern Australian", @"code": @"modern_australian" },
                        @{@"name" : @"Modern European", @"code": @"modern_european" },
                        @{@"name" : @"Mongolian", @"code": @"mongolian" },
                        @{@"name" : @"Moroccan", @"code": @"moroccan" },
                        @{@"name" : @"New Zealand", @"code": @"newzealand" },
                        @{@"name" : @"Night Food", @"code": @"nightfood" },
                        @{@"name" : @"Norcinerie", @"code": @"norcinerie" },
                        @{@"name" : @"Open Sandwiches", @"code": @"opensandwiches" },
                        @{@"name" : @"Oriental", @"code": @"oriental" },
                        @{@"name" : @"Pakistani", @"code": @"pakistani" },
                        @{@"name" : @"Parent Cafes", @"code": @"eltern_cafes" },
                        @{@"name" : @"Parma", @"code": @"parma" },
                        @{@"name" : @"Persian/Iranian", @"code": @"persian" },
                        @{@"name" : @"Peruvian", @"code": @"peruvian" },
                        @{@"name" : @"Pita", @"code": @"pita" },
                        @{@"name" : @"Pizza", @"code": @"pizza" },
                        @{@"name" : @"Polish", @"code": @"polish" },
                        @{@"name" : @"Portuguese", @"code": @"portuguese" },
                        @{@"name" : @"Potatoes", @"code": @"potatoes" },
                        @{@"name" : @"Poutineries", @"code": @"poutineries" },
                        @{@"name" : @"Pub Food", @"code": @"pubfood" },
                        @{@"name" : @"Rice", @"code": @"riceshop" },
                        @{@"name" : @"Romanian", @"code": @"romanian" },
                        @{@"name" : @"Rotisserie Chicken", @"code": @"rotisserie_chicken" },
                        @{@"name" : @"Rumanian", @"code": @"rumanian" },
                        @{@"name" : @"Russian", @"code": @"russian" },
                        @{@"name" : @"Salad", @"code": @"salad" },
                        @{@"name" : @"Sandwiches", @"code": @"sandwiches" },
                        @{@"name" : @"Scandinavian", @"code": @"scandinavian" },
                        @{@"name" : @"Scottish", @"code": @"scottish" },
                        @{@"name" : @"Seafood", @"code": @"seafood" },
                        @{@"name" : @"Serbo Croatian", @"code": @"serbocroatian" },
                        @{@"name" : @"Signature Cuisine", @"code": @"signature_cuisine" },
                        @{@"name" : @"Singaporean", @"code": @"singaporean" },
                        @{@"name" : @"Slovakian", @"code": @"slovakian" },
                        @{@"name" : @"Soul Food", @"code": @"soulfood" },
                        @{@"name" : @"Soup", @"code": @"soup" },
                        @{@"name" : @"Southern", @"code": @"southern" },
                        @{@"name" : @"Spanish", @"code": @"spanish" },
                        @{@"name" : @"Steakhouses", @"code": @"steak" },
                        @{@"name" : @"Sushi Bars", @"code": @"sushi" },
                        @{@"name" : @"Swabian", @"code": @"swabian" },
                        @{@"name" : @"Swedish", @"code": @"swedish" },
                        @{@"name" : @"Swiss Food", @"code": @"swissfood" },
                        @{@"name" : @"Tabernas", @"code": @"tabernas" },
                        @{@"name" : @"Taiwanese", @"code": @"taiwanese" },
                        @{@"name" : @"Tapas Bars", @"code": @"tapas" },
                        @{@"name" : @"Tapas/Small Plates", @"code": @"tapasmallplates" },
                        @{@"name" : @"Tex-Mex", @"code": @"tex-mex" },
                        @{@"name" : @"Thai", @"code": @"thai" },
                        @{@"name" : @"Traditional Norwegian", @"code": @"norwegian" },
                        @{@"name" : @"Traditional Swedish", @"code": @"traditional_swedish" },
                        @{@"name" : @"Trattorie", @"code": @"trattorie" },
                        @{@"name" : @"Turkish", @"code": @"turkish" },
                        @{@"name" : @"Ukrainian", @"code": @"ukrainian" },
                        @{@"name" : @"Uzbek", @"code": @"uzbek" },
                        @{@"name" : @"Vegan", @"code": @"vegan" },
                        @{@"name" : @"Vegetarian", @"code": @"vegetarian" },
                        @{@"name" : @"Venison", @"code": @"venison" },
                        @{@"name" : @"Vietnamese", @"code": @"vietnamese" },
                        @{@"name" : @"Wok", @"code": @"wok" },
                        @{@"name" : @"Wraps", @"code": @"wraps" },
                        @{@"name" : @"Yugoslav", @"code": @"yugoslav" }];
}
@end
