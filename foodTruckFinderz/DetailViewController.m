//
//  DetailViewController.m
//  foodTruckFinderz
//
//  Created by Oski on 3/3/13.
//  Copyright (c) 2013 Oscar Edmond. All rights reserved.
//

#import "DetailViewController.h"
#import "FoodTruck.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIButton *selectFavoriteButton;

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NavigationController *parentnav;
    parentnav = (NavigationController*)self.parentViewController;
    _context = parentnav.context;
    
    
    
}
- (IBAction)favoriteButton:(id)sender {
    //allows user to select button to choose favorite truck
    if ([_incomingFoodTruckObject.isFavorite boolValue]==0) {
        _incomingFoodTruckObject.isFavorite = [[NSNumber alloc]initWithBool:YES];
        [self.selectFavoriteButton setImage:[UIImage imageNamed:@"heart.png"] forState:UIControlStateNormal];
    } else {
        _incomingFoodTruckObject.isFavorite = [[NSNumber alloc]initWithBool:NO];
        [self.selectFavoriteButton setImage:[UIImage imageNamed:@"unselected_heart.png"] forState:UIControlStateNormal];
    }
    
    
    [self saveFoodTruck:[_incomingFoodTruckObject.isFavorite boolValue]];
    
}

- (void)saveFoodTruck:(BOOL)favorite
{
    
    NSError *error = nil;
    if(![self.context save:&error]) {
        NSLog(@"Error saving object: %@", [error description]);
        abort();
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    self.textLabel.font = [UIFont fontWithName:@"DistrictPro-Thin" size:35];
    self.textLabel.text = _incomingFoodTruckObject.title;
    self.imageView.image = [UIImage imageNamed:self.incomingFoodTruckObject.fileName];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    if ([_incomingFoodTruckObject.isFavorite boolValue] == YES)
    {
        [self.selectFavoriteButton setImage:[UIImage imageNamed:@"heart.png"] forState:UIControlStateNormal];
    } else {
        [self.selectFavoriteButton setImage:[UIImage imageNamed:@"unselected_heart.png"] forState:UIControlStateNormal];
    }
    
}
- (void)setIncomingFoodTruckObject:(FoodTruck *)incomingFoodTruckObject
{
    _incomingFoodTruckObject =incomingFoodTruckObject;
    self.textLabel.text = self.incomingFoodTruckObject.title;
    NSLog(@"textLabel should read %@",self.incomingFoodTruckObject.title);
    self.imageView.image = [UIImage imageNamed:self.incomingFoodTruckObject.fileName];
    NSLog(@"image should be this %@", self.incomingFoodTruckObject.fileName);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Core Data

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FoodTruck" inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

@end
