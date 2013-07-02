//
//  FoodTruckViewController.m
//  foodTruckFinderz
//
//  Created by Oski on 3/3/13.
//  Copyright (c) 2013 Oscar Edmond. All rights reserved.
//

#import "foodTruckFinderzAppDelegate.h"
#import "FoodTruckViewController.h"
#import "MapViewController.h"
#import "FoodTrucksCollectionView.h"
#import "FoodTruck.h"
#import "ftfCollectionViewCell.h"
#import "DetailViewController.h"
#import "foodTruckHeaderView.h"



@interface FoodTruckViewController ()<UITextFieldDelegate, CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource> {
    NSMutableArray *_objectChanges;
    NSMutableArray *_sectionChanges;
}
@property (weak, nonatomic) IBOutlet UILabel *addTrucksLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet FoodTrucksCollectionView *collectionView;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (weak, nonatomic) IBOutlet UILabel *findLabel;
@property (weak, nonatomic) IBOutlet UIButton *buttonLabel;
@property (weak, nonatomic) IBOutlet UILabel *searchLabel;
@end

@implementation FoodTruckViewController


- (IBAction)buttonDrag:(id)sender withEvent: (UIEvent *)event
{
    CGPoint point = [[[event allTouches] anyObject]locationInView:self.view];
    UIControl *control = sender;
    control.center = CGPointMake(point.x, 162);
    [self.searchLabel setAlpha:.40];
}

- (IBAction)buttondragEnded:(id)sender withEvent:(UIEvent *)event
{
    CGPoint point = [[[event allTouches] anyObject]locationInView:self.view];
    UIControl *control = sender;
    control.center = CGPointMake(point.x, point.y);
    
    if (control.center.x > 280) {
        //[self performSegueWithIdentifier:@"toMapView" sender:self];
        [self.buttonLabel setFrame:CGRectMake(4, 140, 90, 44)];
        [self.searchLabel setAlpha:1.0];
        
    }else {
        [UIView animateWithDuration:0.5 animations:^{
            [self.buttonLabel setFrame:CGRectMake(4, 142, 90, 44)];
            [self.searchLabel setAlpha:1.0];
            
        }];
    }
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusAuthorized)
    {
        // permission denied
        [self performSegueWithIdentifier:@"toMapView" sender:self];
    } else if (status == kCLAuthorizationStatusDenied){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


-(void) universalKeyDismisser:(id)sender;

{
    [self.textField resignFirstResponder];   
}

- (IBAction)dismisskeyboardButto:(UIButton *)sender {
    [self universalKeyDismisser:sender];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toMapView"])
    {
        if ([segue.destinationViewController isKindOfClass:[MapViewController class]]) {
            MapViewController *MVC = (MapViewController *)segue.destinationViewController;
            
            [MVC setZipCode:self.textField.text];
            [self resignFirstResponder];
        }
    }else if ([segue.identifier isEqualToString:@"toDetailView"]){            
            NSIndexPath *selectedCell = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
            

            FoodTruck *favoriteObject = [self.fetchedResultsController objectAtIndexPath:selectedCell];
            NSLog(@"this cell was selected:%ld", (long)selectedCell.item);
            
            DetailViewController *dvc = (DetailViewController*)segue.destinationViewController;
             dvc.incomingFoodTruckObject.title = favoriteObject.title;
            NSLog(@"favorite title: %@", favoriteObject.title);
            dvc.incomingFoodTruckObject.fileName =favoriteObject.fileName;
            NSLog(@"favorite image:%@", favoriteObject.fileName);
            [dvc setIncomingFoodTruckObject:favoriteObject];
        
        }
    

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([self.textField.text length] ==5 && ![string isEqualToString:@""]) {
        return NO;
    }
    [self resignFirstResponder];
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    [self.collectionView reloadData];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Food Truck Finderz";
    //self.view.backgroundColor = [UIColor redColor];
    self.findLabel.font = [UIFont fontWithName:@"DistrictPro-Thin" size:30];
    self.findLabel.text = @"Find Your Favorite Food Truck!";
    self.searchLabel.font = [UIFont fontWithName:@"DistrictPro-Thin" size:25];
    self.searchLabel.text = @"Slide to Search!";
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chalkboardbackground.jpeg"]];
    // Do any additional setup after loading the view.
    
    _objectChanges = [NSMutableArray array];
    _sectionChanges = [NSMutableArray array];
    
    foodTruckFinderzAppDelegate *delegate = (foodTruckFinderzAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = delegate.managedObjectContext;
    
    
    [self.textField setDelegate:self];
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    NavigationController *parentController;
    parentController = (NavigationController *)self.parentViewController;
    
    _context = parentController.context;
    
    NSFetchRequest *fetchFavorite = [[NSFetchRequest alloc] init];
    [fetchFavorite setEntity:[NSEntityDescription entityForName:@"FoodTruck"  inManagedObjectContext:_context]];
    NSPredicate *favoritesFilter = [NSPredicate predicateWithFormat:@"isFavorite == YES"];
    self.favoritesList = [[_context executeFetchRequest:fetchFavorite error:nil] filteredArrayUsingPredicate:favoritesFilter];
    NSLog(@"this contains %@", self.favoritesList);
    
    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(0, 18, 0, 0);
    
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FoodTruck" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFavorite == 1"];
    
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
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



- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    NSMutableDictionary *change = [NSMutableDictionary new];
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            change [@(type)]  = @[@(sectionIndex)];
            break;
            
        case NSFetchedResultsChangeDelete:
            change [@(type)] = @[@(sectionIndex)];
            break;
    }
    [_sectionChanges addObject:change];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    NSMutableDictionary *change = [NSMutableDictionary new];
    switch(type) {
        case NSFetchedResultsChangeInsert:
            change[@(type)] = newIndexPath;
            break;
            
        case NSFetchedResultsChangeDelete:
            change[@(type)] = indexPath;
            break;
            
        case NSFetchedResultsChangeUpdate:
            change[@(type)] = indexPath;
            break;
            
        case NSFetchedResultsChangeMove:
            change[@(type)] = @[indexPath, newIndexPath];
            break;
    }
    [_objectChanges addObject:change];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if ([_sectionChanges count] > 0)
    {
        [self.collectionView performBatchUpdates:^{
            for (NSDictionary *change in _sectionChanges) {
                [change enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, id obj, BOOL *stop) {
                    NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                    switch (type) {
                        case NSFetchedResultsChangeInsert:
                            [self.collectionView insertSections:
                             [NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                            break;
                        case NSFetchedResultsChangeDelete:
                            [self.collectionView insertSections:
                             [NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                            break;
                        case NSFetchedResultsChangeUpdate:
                            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                            
                        default:
                            break;
                    }
                }];
            }
        } completion:nil];
    }
    if([_objectChanges count] > 0 && [_sectionChanges count] == 0)
    {
        [self.collectionView performBatchUpdates:^{
            for (NSDictionary *change in _objectChanges){
                [change enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, id obj, BOOL *stop)
                 {
                     NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                     switch (type) {
                         case NSFetchedResultsChangeInsert:
                             [self.collectionView insertItemsAtIndexPaths:@[obj]];
                             break;
                         case NSFetchedResultsChangeDelete:
                             [self.collectionView deleteItemsAtIndexPaths:@[obj]];
                             break;
                         case NSFetchedResultsChangeUpdate:
                             [self.collectionView reloadItemsAtIndexPaths:@[obj]];
                             break;
                         case NSFetchedResultsChangeMove:
                             [self.collectionView moveItemAtIndexPath:obj[0] toIndexPath:obj[1]];
                             break;
                     }
                 }];
            }
        } completion:nil];
        
    }
    [_sectionChanges removeAllObjects];
    [_objectChanges removeAllObjects];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (kind ==UICollectionElementKindSectionHeader)
    {
        foodTruckHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        headerView.Title.text = @"Add your favorite foodtrucks";
        reusableview = headerView;
    }
    return reusableview;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [[self.fetchedResultsController sections] count];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];

}
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if ([cell isKindOfClass:[ftfCollectionViewCell class]]) {
        ftfCollectionViewCell *ftfcvc = (ftfCollectionViewCell*)cell;
        
        [self configureCell:ftfcvc atindexPath:indexPath];
        
    }
    return cell;
}

-(void)configureCell:(ftfCollectionViewCell *)cell atindexPath: (NSIndexPath*)indexPath
{
    FoodTruck *favoriteObject =  (FoodTruck *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
  
    UILabel *favoriteLabel;
    favoriteLabel= (UILabel *)[cell.favoriteTruckView viewWithTag:100];
    favoriteLabel.font = [UIFont fontWithName:@"DistrictPro-Thin" size:20];
    favoriteLabel.text= favoriteObject.title;
    
    UIImageView *favoriteImage;
    favoriteImage = (UIImageView*)[cell.favoriteTruckView viewWithTag:200];
    favoriteImage.image = [UIImage imageNamed:favoriteObject.fileName];
     
}

@end
