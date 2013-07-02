//
//  MapViewController.m
//  foodTruckFinderz
//
//  Created by Oski on 3/3/13.
//  Copyright (c) 2013 Oscar Edmond. All rights reserved.
//

#import "MapViewController.h"
#import "FoodTruckViewController.h"
#import "DetailViewController.h"
#import "TableViewController.h"
#import "FoodTruck.h"

@interface MapViewController ()<MKMapViewDelegate, MKAnnotation, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *distance;

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)geoCoder
{
    NSLog(@"%@", self.zipCode);
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:self.zipCode
                 completionHandler:^(NSArray *placemarks, NSError *error) {
                     if (error)
                     {
                         NSLog(@"Geocode failed with error:%@", error);
                         // [self displayError: error];
                         return ;
                     }
                     NSLog(@"Recieved placemarks: %@", placemarks);
                     //[placemarks objectAtIndex:(NSUInteger)]
                     //[self setCenterCoordinate:placemarks animated:YES];
                     //[self displayPlacemarks:placemarks];
                     
                     if ([placemarks count] >0) {
                         CLPlacemark *placemarkObject = placemarks[0];
                         CLLocation *location = placemarkObject.location;
                         CLRegion *theRadius =placemarkObject.region;
                         
                         
                         CLLocationCoordinate2D coord = location.coordinate;
                         
                         [self.mapView setCenterCoordinate:coord animated:YES];
                         
                         MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, theRadius.radius ,theRadius.radius);
                         [self.mapView setRegion:region];
                         
                     }
                 }];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self geoCoder];
    
    NavigationController   *parentNav;
    parentNav = (NavigationController *)self.parentViewController;
    
    _context = parentNav.context;
    
    
    NSFetchRequest *dataFetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *dataEntity = [NSEntityDescription entityForName:@"FoodTruck" inManagedObjectContext:_context];
    [dataFetchRequest setEntity:dataEntity];
    
    NSError *error;
    NSArray *foodtruckList = [_context executeFetchRequest:dataFetchRequest error:&error];
    for (int counter = 0; counter <[foodtruckList count]; counter++)
    {
        FoodTruck *tempObject;
        tempObject = [foodtruckList objectAtIndex:counter];
    }
    
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    MKUserLocation *userLocation = self.mapView.userLocation;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 500, 500);
    [self.mapView setRegion:region animated:NO];
    [self.mapView addAnnotations:foodtruckList];
    
    [self pinDistance];
}

- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if(annotation ==self.mapView.userLocation)
    {
        return nil;
    }
    
    MKAnnotationView *customPin = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
    UIImage *pinImage = [UIImage imageNamed:@"truck.png"];
    [customPin setImage:pinImage];
    
    customPin.canShowCallout = YES;
    
    
    UIImageView *leftIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"foodtruck1.png"]];
    customPin.leftCalloutAccessoryView = leftIcon;
    
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    customPin.rightCalloutAccessoryView = rightButton;
    
    CLLocationDistance distance = [[(FoodTruck *)annotation distance] doubleValue]* 0.0006213711928;
    NSString *foodtruckDistance = [NSString stringWithFormat:@"%.02f miles", distance];
    [(FoodTruck *)annotation setSubtitle:foodtruckDistance];
    NSLog(@"the distance is %f in miles", distance);

    return customPin;
}

- (void)pinDistance
{
    [self.mapView.annotations enumerateObjectsUsingBlock:^(id<MKAnnotation> annotation, NSUInteger idx, BOOL *stop) {
        CLLocation *pinLocation = [[CLLocation alloc]initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
        
        CLLocation *userlocation = [[CLLocation alloc]initWithLatitude:self.mapView.userLocation.coordinate.latitude longitude:self.mapView.userLocation.coordinate.longitude];
        
        CLLocationDistance distance = (([pinLocation distanceFromLocation:userlocation])*0.000621371192);
        [(FoodTruck *)annotation setDistance:@(distance)];
    }];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    DetailViewController *dvc;
    [self performSegueWithIdentifier:@"toDetailFromMap" sender:self];
    
    dvc = (DetailViewController *)[self.navigationController.viewControllers lastObject];
    
    FoodTruck *clickedAnnotation;
    clickedAnnotation = (FoodTruck*)view.annotation;
    
    dvc.incomingFoodTruckObject = clickedAnnotation;

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
