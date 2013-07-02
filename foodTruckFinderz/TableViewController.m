//
//  TableViewController.m
//  foodTruckFinderz
//
//  Created by Oski on 3/3/13.
//  Copyright (c) 2013 Oscar Edmond. All rights reserved.
//

#import "TableViewController.h"
#import "FoodTruckViewController.h"
#import "MapViewController.h"
#import "FoodTruck.h"
#import "DetailViewController.h"
#import "foodTruckTableCell.h"

@interface TableViewController ()
@property (weak, nonatomic) IBOutlet UIButton *barButton;

@end
static NSString *cellIdentifier = @"Cell";

@implementation TableViewController






- (IBAction)homeButton:(id)sender {
    
    
    FoodTruckViewController  *destVC = (FoodTruckViewController *)self.navigationController.viewControllers[0];
    
    [UIView transitionFromView:self.view
                        toView:destVC.view
                      duration:1
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    completion:^(BOOL finished) {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }];
    
}
- (IBAction)mapButton:(id)sender {
    
    
    
    MapViewController *destVC = (MapViewController *)self.navigationController.viewControllers[1];
    
    [UIView transitionFromView:self.view
                        toView:destVC.view
                      duration:1
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    completion:^(BOOL finished) {
                        [self.navigationController popViewControllerAnimated:NO];
                                 }];
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    //read from the database to check if saving works
    NSFetchRequest *dataFetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *dataEntity = [NSEntityDescription entityForName:@"FoodTruck" inManagedObjectContext:_context];
    NSPredicate *dist = [NSPredicate predicateWithBlock:^BOOL(FoodTruck *foodTruck, NSDictionary *bindings) {
        NSLog(@"distance: %@", foodTruck.distance);
        return ((foodTruck.distance.floatValue * 0.000621371192) < 500.0f);
    }];
    NSSortDescriptor *truckDist = [NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES];
        //[dataFetchRequest setPredicate:dist];
        //[dataFetchRequest setSortDescriptors:@[truckDist]];
    
    
    [dataFetchRequest setEntity:dataEntity];
    
    NSError *error;
    _foodtruckList = [_context executeFetchRequest:dataFetchRequest error:&error];
    _foodtruckList = [_foodtruckList filteredArrayUsingPredicate:dist];
    _foodtruckList = [_foodtruckList sortedArrayUsingDescriptors:@[truckDist]];
    
    
    //self.foodtruckList = [NSArray array];

    [self.tableView reloadData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_foodtruckList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    foodTruckTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    
    FoodTruck *tempObject = [_foodtruckList objectAtIndex:indexPath.row];
    cell.titleLabel.font = [UIFont fontWithName:@"DistrictPro-Thin" size:35];
    cell.titleLabel.text = tempObject.title;

    cell.distanceLabel.text = [NSString stringWithFormat:@"%.02f miles", (tempObject.distance.floatValue*0.000621371)];
    cell.truckImage.image = [UIImage imageNamed:tempObject.fileName];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *dvc;
    [self performSegueWithIdentifier:@"toDetailViewTable" sender:self];
    dvc = (DetailViewController*)[self.navigationController.viewControllers lastObject];
    FoodTruck *tempObject = [_foodtruckList objectAtIndex:indexPath.row];
    
    dvc.incomingFoodTruckObject = tempObject;
}

@end
