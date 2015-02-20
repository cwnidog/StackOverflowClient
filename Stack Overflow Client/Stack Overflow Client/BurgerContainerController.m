//
//  BurgerContainerController.m
//  Stack Overflow Client
//
//  Created by John Leonard on 2/16/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

#import "BurgerContainerController.h"
#import "MenuTableViewController.h"
#import "ProfileViewController.h"

@interface BurgerContainerController() <MenuPressedDelegate>

@property (strong, nonatomic) UIViewController *topViewController;
@property (strong, nonatomic) UIButton *burgerButton;
@property (strong, nonatomic) UITapGestureRecognizer *tapToClose;
@property (strong, nonatomic) UIPanGestureRecognizer *slideRecognizer;
@property (strong, nonatomic) UINavigationController *searchVC;
@property (strong, nonatomic) ProfileViewController *profileVC;
@property (nonatomic)         NSInteger selectedRow;
@property (strong, nonatomic) MenuTableViewController *menuVC;

@end

@implementation BurgerContainerController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Put the child VC onto the screen
  [self addChildViewController:self.searchVC];
  self.searchVC.view.frame = self.view.frame;
  [self.view addSubview:self.searchVC.view];
  [self.searchVC didMoveToParentViewController:self];
  self.topViewController = self.searchVC;
  
  // add the burger button
  UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
  [button setBackgroundImage:[UIImage imageNamed:@"BurgerImage"] forState:UIControlStateNormal];
  [button addTarget:self action:@selector(burgerButtonPressed) forControlEvents:UIControlEventTouchUpInside];
  [self.searchVC.view addSubview:button];
  self.burgerButton = button;
  
  // want to close the panel when it's tapped
  self.tapToClose = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePanel)];
  
  // also want to be able to slide the panel
  self.slideRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slidePanel:)];
  [self.topViewController.view addGestureRecognizer:self.slideRecognizer];
}

// when we selct the burger button, want to open the panel
- (void) burgerButtonPressed
{
  NSLog(@"Burger button pressed.");
  
  self.burgerButton.userInteractionEnabled = false; // don't want to be able to double tap
  __weak BurgerContainerController *weakSelf = self;
  
  // slide the panel open
  [UIView animateWithDuration:.3 animations:^{
    weakSelf.topViewController.view.center = CGPointMake(weakSelf.topViewController.view.center.x + 300, weakSelf.topViewController.view.center.y);
  } completion:^(BOOL finished){
    [weakSelf.topViewController.view addGestureRecognizer:weakSelf.tapToClose]; // allow tapping the panel to cose it
  }];
  
} // burgerButtonPressed

// close the panel, i.e. put it back in its original position
-(void) closePanel
{
  NSLog(@"Closing panel");
  
  [self.topViewController.view removeGestureRecognizer:self.tapToClose];
  __weak BurgerContainerController *weakSelf = self;
  
  // slide the panel closed
  [UIView animateWithDuration:.3 animations:^{
    weakSelf.topViewController.view.center = weakSelf.view.center;
  } completion:^(BOOL finished) {
    weakSelf.burgerButton.userInteractionEnabled = true; // re-enable theburger button
  }];
} // closePanel

// slide the panel when the user swipes, this only works for horizontal swipes (pans)
- (void) slidePanel: (id)sender
{
  UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *) sender;
  CGPoint translatedPoint = [pan translationInView:self.view];
  CGPoint velocity = [pan velocityInView:self.view];
  
  // if the user is swiping the panel, move it
  if ([pan state] == UIGestureRecognizerStateChanged)
  {
    // can move panel if we're swiping to the right (velocity > 0) or if the panel
    // has already moved to the right from its original position (origin.x > 0)
    if (velocity.x > 0 || self.topViewController.view.frame.origin.x > 0)
    {
      self.topViewController.view.center = CGPointMake(self.topViewController.view.center.x + translatedPoint.x, self.topViewController.view.center.y);
      
      // translation keeps track of total movement, not incremental, so we need to reset after moving the view to make it incremental
      [pan setTranslation:CGPointZero inView:self.view];
    } // if velocity
  } // if pan state UIGestureRecognizerStateChanged
  
  if ([pan state] == UIGestureRecognizerStateEnded) // done swiping
  {
    __weak BurgerContainerController *weakSelf = self;
    
    // if the user has swiped the panel more than 1/3 of the way across the screen, they meant to open it
    if (self.topViewController.view.frame.origin.x > self.view.frame.size.width / 3)
    {
      NSLog(@"They meant to open it");
      self.burgerButton.userInteractionEnabled = false; // no double-taps
      // open the panel
      [UIView animateWithDuration:.3 animations:^{
        self.topViewController.view.center = CGPointMake(weakSelf.view.frame.size.width * 1.25, weakSelf.view.center.y);
      } completion: ^(BOOL finished)
      {
        // set up so if user taps the panel, it closes
        [weakSelf.topViewController.view addGestureRecognizer:weakSelf.tapToClose];
      }];
    }
    else // finish any remaining movement
    {
      [UIView animateWithDuration:.2 animations:^{
        weakSelf.topViewController.view.center = weakSelf.view.center;
      } completion:^(BOOL finished)
      {
        // reenable the tap to close feature and make teh burger button active again
        [self.topViewController.view removeGestureRecognizer:self.tapToClose];
        weakSelf.burgerButton.userInteractionEnabled = true;
      }];
    } // else
  } // if pan state UIGestureRecognizerStateEnded
  
} // slidePanel

// View controller getters - overriden for lazy loading

- (UINavigationController *) searchVC
{
  if (!_searchVC)
  {
    _searchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SEARCH_VC"];
  }
  
  return _searchVC;
} // searchVC

- (ProfileViewController *) profileVC
{
  if (!_profileVC)
  {
    _profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PROFILE_VC"];
  }
  return _profileVC;
} // profileVC

// our initial viw is the container view, we immediately move to the menu
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"EMBED_MENU"]) // moving to the menu
  {
    MenuTableViewController *destinationVC = segue.destinationViewController;
    destinationVC.delegate = self;
    self.menuVC = destinationVC;
  }
} // prepareForSegue()

// switch between the menu views; "Questions" or "My Profiles"
- (void) switchToViewController:(UIViewController *) destinationVC
{
  __weak BurgerContainerController *weakSelf;
  
  [UIView animateWithDuration:0.2 animations:^{
    weakSelf.topViewController.view.frame = CGRectMake(weakSelf.view.frame.size.width, 0, weakSelf.view.frame.size.width, weakSelf.view.frame.size.height);
  } completion:^(BOOL finished) {
    destinationVC.view.frame = self.topViewController.view.frame; // keep the same frame size
    
    // take the current top view down and put the selected view in its place
    // take down the current displayed VC
    [self.topViewController.view removeGestureRecognizer:self.slideRecognizer];
    [self.burgerButton removeFromSuperview];
    [self.topViewController willMoveToParentViewController:nil];
    [self.topViewController.view removeFromSuperview];
    [self.topViewController removeFromParentViewController];
    
    self.topViewController = destinationVC; // change the displayed VC
    
    //display the chosen VC with the same buttons and gestures
    [self addChildViewController:self.topViewController];
    [self.view addSubview:self.topViewController.view];
    [self.topViewController didMoveToParentViewController:self];
    [self.topViewController.view addSubview:self.burgerButton];
    [self.topViewController.view addGestureRecognizer:self.slideRecognizer];
    
    [self closePanel];
  }];
} // switchToViewController()

- (void) menuOptionSelected:(NSInteger)selectedRow
{
  NSLog(@" Selected row: %ld", (long)selectedRow);
  
  if (self.selectedRow == selectedRow)
  {
    // we've clicked on the current view - close it
    [self closePanel];
  }
  
  else
  {
    // determine which VC is of interest, based on which menu row was clicked.
    self.selectedRow = selectedRow;
    UIViewController *destinationVC;
    
    switch (selectedRow) {
      case 0:
        destinationVC = self.searchVC;
        break;
      case 1:
        destinationVC = self.profileVC;
        break;

        break;
    } // switch on selectedRow
    [self switchToViewController:destinationVC];
  }
  
} // menuOptionSelected()

@end
