//
//  ViewController.m
//  firstProj_arKit_2
//
//  Created by interns on 04/07/18.
//  Copyright © 2018 CommScope Inc. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "firstProj_arKit_2-Bridging-Header.h"
#import "firstProj_arKit_2-Swift.h"

@interface ViewController () <ARSCNViewDelegate>

@property (nonatomic, strong) IBOutlet  SceneLocationView *sceneView;
@property (nonatomic, strong) AppDelegate *appDelegate;

@end

    
@implementation ViewController

#define M_PI        3.14159265358979323846264338327950288

- (void) afterRouteLegUpdate : (float) angle distance: distance {
    
}

SCNNode * nodeArray [10] ;
SCNNode * node1 ;
SCNNode * node2 ;
SCNNode * node3 ;
SCNNode * node4 ;

SCNScene * scene ;


- (void) initNodes{
    for(int i = 0 ; i < 10 ; i++){
        NSString *index = [NSString stringWithFormat: @"%d", i+1];
        NSString *arrow = @"arrow";
        NSString *mainNode = [arrow stringByAppendingString:index];

        nodeArray[i]  = [(scene).rootNode childNodeWithName:mainNode recursively:true];
//        nodeArray[i].hidden = true ;
    }
    
}

- (void) hideArrow{
    for(int i =0 ; i < 10 ; i++)
    nodeArray[i].hidden = true ;
}


- (void) updateArrows:(float) distance angle: (float) angle {
   
    
   // float distanceBetweenArrows = distance/10 ; // kitne arrows call karne honge
    
    for(int i = 0; i < 10 ; i++){
            nodeArray[i].hidden = false ;
//        if(i == 1)
//            nodeArray[i].hidden = false ;
        
        nodeArray[i].transform = [self transformRotation:GLKMathDegreesToRadians(angle + 90) distance:10 ];
        nodeArray[i].position = SCNVector3Make( 0,-1 , 0);
//        if(i == 1)
//            nodeArray[i].position = SCNVector3Make(0,-1 ,-0.2) ;
    }
 
}

- (void) animateArrow
{
    //Start playing an audio file.
    
    //NSTimer calling Method B, as long the audio file is playing, every 5 seconds.
    [NSTimer scheduledTimerWithTimeInterval:0.5f
                                     target:self selector:@selector(methodB:) userInfo:nil repeats:YES];
}

- (void) methodB:(NSTimer *)timer
{
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    //self.appDelegate.detectedBarcode
    // Set the view's delegate
    //self.sceneView =  [[SceneLocationView alloc]init];
    
    
    self.sceneView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    
    self.sceneView.delegate = self;
    
    scene = [SCNScene sceneNamed:@"arrow9.dae"];
    
    
    
    
    /////swift part convert to objective c///////
    
//    @available(iOS 11.0, *)
//    private extension ViewController {
//        func buildDemoData() -> [LocationAnnotationNode] {
//            var nodes: [LocationAnnotationNode] = []
//
//            // TODO: add a few more demo points of interest.
//            // TODO: use more varied imagery.
//
//           let spaceNeedle = buildNode(latitude: self.AppDelegate.currentDestinationLatitude, longitude: self.AppDelegate.currentDestinationLongitude, altitude: 225, imageName: "pin")
//            nodes.append(spaceNeedle)
//
//            let empireStateBuilding = buildNode(latitude: self.AppDelegate.currentDestinationLatitude, longitude: self.AppDelegate.currentDestinationLongitude, altitude: 14.3, imageName: "pin")
//            nodes.append(empireStateBuilding)
//
//            let canaryWharf = buildNode(latitude: self.AppDelegate.currentDestinationLatitude, longitude:self.AppDelegate.currentDestinationLongitude, altitude: 236, imageName: "pin")
//            nodes.append(canaryWharf)
//
//            return nodes
//        }
//
//        func buildNode(latitude: CLLocationDegrees, longitude: CLLocationDegrees, altitude: CLLocationDistance, imageName: String) -> LocationAnnotationNode {
//            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//            let location = CLLocation(coordinate: coordinate, altitude: altitude)
//            let image = UIImage(named: imageName)!
//            return LocationAnnotationNode(location: location, image: image)
//        }
//    }
    //////////end swift part convert to objective c/////////////
    
    
    [self initNodes ];/// making all the arrows hidden
    [self hideArrow] ;
    [self animateArrow] ;
    [self updateArrows:5 angle:0] ;
    [self addObservers];
     self.sceneView.scene = scene;
    LocationAnnotationNode *spaceNeedle = [self buildNodeforLatitude:17.44825568 longitude:78.38314542 altitude:225 pinImage:@"pin.png"];
    
    [self.sceneView addLocationNodeWithConfirmedLocationWithLocationNode:spaceNeedle];
   
}

-(LocationAnnotationNode*)buildNodeforLatitude:(CLLocationDegrees) latitude longitude:(CLLocationDegrees)longitude altitude : (CLLocationDistance) altitude pinImage :(NSString*) imagename
{
    
    CLLocationCoordinate2D  cooridates  =  CLLocationCoordinate2DMake(latitude, longitude);
    CLLocation * location = [[CLLocation alloc]initWithCoordinate:cooridates altitude:altitude horizontalAccuracy:kCLLocationAccuracyBestForNavigation verticalAccuracy:kCLLocationAccuracyBestForNavigation timestamp:[NSDate date]];
    UIImage * image  = [UIImage imageNamed:imagename];
    return  [[LocationAnnotationNode alloc]initWithLocation:location image:image];
    
//    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//    let location = CLLocation(coordinate: coordinate, altitude: altitude)
//    let image = UIImage(named: imageName)!
//    return LocationAnnotationNode(location: location, image: image)
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Create a session configuration
    AROrientationTrackingConfiguration *configuration = [AROrientationTrackingConfiguration new];
    
    configuration.worldAlignment = ARWorldAlignmentGravityAndHeading; // make y as the gravity axis
    // Run the view's session
    [self.sceneView run];
    [self.sceneView.session runWithConfiguration:configuration];
    
    
}


-(SCNMatrix4)transformRotation:(float)rotationY distance:(float) distance
{
    SCNMatrix4 translation = SCNMatrix4MakeTranslation(1, 1, -0.3);
    SCNMatrix4 rotation = SCNMatrix4MakeRotation(-1 * rotationY, 0, 1, 0);
    SCNMatrix4 transform = SCNMatrix4Mult(translation,rotation);
    
    return transform;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Pause the view's session
    [self.sceneView.session pause];
    [self removeObservers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - ARSCNViewDelegate

/*
// Override to create and configure nodes for anchors added to the view's session.
- (SCNNode *)renderer:(id<SCNSceneRenderer>)renderer nodeForAnchor:(ARAnchor *)anchor {
    SCNNode *node = [SCNNode new];
 
    // Add geometry to the node...
 
    return node;
}
*/

- (void)session:(ARSession *)session didFailWithError:(NSError *)error {
    // Present an error message to the user
    
}

- (void)sessionWasInterrupted:(ARSession *)session {
    // Inform the user that the session has been interrupted, for example, by presenting an overlay
    
}

- (void)sessionInterruptionEnded:(ARSession *)session {
    // Reset tracking and/or remove existing anchors if consistent tracking is required
    
}
-(void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRouteArrows:) name:@"ArrowsUpdated" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDestLabel:) name:@"DestReachedUpdated" object:nil];
}

-(void) updateRouteArrows:(NSNotification*)notification
{
    NSLog(@"BBBB");
    NSArray *arrowParams = [notification object];
    float distance = [[arrowParams objectAtIndex:0] floatValue];
    float direction = [[arrowParams objectAtIndex:1] floatValue];
//    NSLog(@"%f" , direction)
    NSLog(@"distance %f direction %f", distance, direction);
    [self hideArrow] ;
    [self updateArrows:distance angle:direction];
    //NSLog(@"Destination:   %f",self.appDelegate.currentDestinationLongitude);
    /////////my edit//////////
//    double length = self.appDelegate.currentRoutingLeg.length;
//    NSNumber *DoubleNumber = [NSNumber numberWithDouble:length];
//    NSString * text=[DoubleNumber stringValue];
//    UIFont * customFont = [UIFont fontWithName:@"HelveticaNeue-bold" size:50];
//    CGSize labelSize = [text sizeWithFont:customFont constrainedToSize:CGSizeMake(380, 20) lineBreakMode:NSLineBreakByTruncatingTail];
//
//    UILabel *fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 500, labelSize.width, labelSize.height)];
//    fromLabel.text = text;
//    fromLabel.numberOfLines = 1;
//    fromLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines; // or UIBaselineAdjustmentAlignCenters, or UIBaselineAdjustmentNone
//    fromLabel.adjustsFontSizeToFitWidth = YES;
//    fromLabel.adjustsLetterSpacingToFitWidth = YES;
//    fromLabel.minimumScaleFactor = 10.0f/12.0f;
//    fromLabel.clipsToBounds = YES;
//    fromLabel.backgroundColor = [UIColor whiteColor];
//    fromLabel.textColor = [UIColor blackColor];
//    fromLabel.textAlignment = NSTextAlignmentLeft;
//    [self.view addSubview:fromLabel];
    /////////my edit////////////
}

-(void) updateDestLabel:(NSNotification*)notification
{
    NSString *msg = [notification object];
    NSString * text = msg;
    UIFont * customFont = [UIFont fontWithName:@"HelveticaNeue-bold" size:50];
    CGSize labelSize = [text sizeWithFont:customFont constrainedToSize:CGSizeMake(380, 20) lineBreakMode:NSLineBreakByTruncatingTail];
    
    UILabel *fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 500, labelSize.width, labelSize.height)];
    fromLabel.text = text;
    fromLabel.numberOfLines = 1;
    fromLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines; // or UIBaselineAdjustmentAlignCenters, or UIBaselineAdjustmentNone
    fromLabel.adjustsFontSizeToFitWidth = YES;
    fromLabel.adjustsLetterSpacingToFitWidth = YES;
    fromLabel.minimumScaleFactor = 10.0f/12.0f;
    fromLabel.clipsToBounds = YES;
    fromLabel.backgroundColor = [UIColor whiteColor];
    fromLabel.textColor = [UIColor blackColor];
    fromLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:fromLabel];
    nodeArray[0].opacity = 0.0 ;
}

-(void)removeObservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ArrowsUpdated" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"DestReachedUpdated" object:nil];
}

@end
