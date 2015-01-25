//
//  CategoryListTVC.m
//  KKBooK
//
//  Created by PromptNow on 11/28/2557 BE.
//  Copyright (c) 2557 GLive. All rights reserved.
//

#import "CategoryListTVC.h"
#import "CategoryModel.h"
#import "BaseNavigationController.h"

@interface CategoryListTVC ()

@end

@implementation CategoryListTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
    ((BaseNavigationController*)self.navigationController).navigationBar.barTintColor = [UIColor colorWithRed:3/255.0 green:166/255.0 blue:130/255.0 alpha:1.0];
    [self addButtonNavigation];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addButtonNavigation{
    UIBarButtonItem *categoryBtn = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(close:)];
    self.navigationItem.rightBarButtonItem = categoryBtn;
}

-(void)close:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^(){
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_categories count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryCell" forIndexPath:indexPath];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CategoryCell"];
    CategoryModel *model = _categories[indexPath.row];
    cell.textLabel.text = model.categoryName;
    
    // Configure the cell...
    
    return cell;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSelectCategoryList) {
        CategoryModel *model = _categories[indexPath.row];
        
        if (![Utility isPad]) {
            [self dismissViewControllerAnimated:YES completion:^(){
                self.didSelectCategoryList(model.categoryID, model.categoryName);
            }];
        }else{
            self.didSelectCategoryList(model.categoryID, model.categoryName);
        }
    }
}


@end
