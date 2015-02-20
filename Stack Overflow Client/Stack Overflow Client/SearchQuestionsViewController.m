//
//  SearchQuestionsViewController.m
//  Stack Overflow Client
//
//  Created by John Leonard on 2/17/15.
//  Copyright (c) 2015 John Leonard. All rights reserved.
//

#import "SearchQuestionsViewController.h"
#import "StackOverflowService.h"
#import "Question.h"
#import "QuestionCell.h"

@interface SearchQuestionsViewController () <UISearchBarDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *questions;

@end

@implementation SearchQuestionsViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.searchBar.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.rowHeight = UITableViewAutomaticDimension;

} // viewDidLoad

// user entered a search term for the questions display
- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
  // ask Stack Overflow for the quations containing the search term
  [[StackOverflowService sharedService] fetchQuestionsWithSearchTerm:searchBar.text completionHandler:^(NSArray *results, NSString *error)
  {
    if (!results.count) // nothing matched
    {
      // lifted from StackOverflow - somehow seems appropriate
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Results" message:@"Stack Overflow returned no results for search target - please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
      [alert show];
    }
    self.questions = results;
    if (error) // failed for some reason
    {
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ResultsError" message:@"Received an unspecified error getting questions." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
      [alert show];
    } // if error
    
    // display the questions
    [self.tableView reloadData];
  }];
} // searchBarSearchButtonClicked()

// how many questions are there to display?
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.questions.count;
} // numberOfRowsInSection

// display teh questions one per cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QUESTION_CELL"];
  cell.avatarImageView.image = nil;
  
  Question *question = self.questions[indexPath.row];
  cell.titleTextView.text = question.title;
  
  // only as Stack Overflow for the image if need to
  if (!question.image) // no cached image
  {
    [[StackOverflowService sharedService] fetchUserImage:question.avatarURL completionHandler:^(UIImage *image) {
      question.image = image; // cache for later use, if needed
      cell.avatarImageView.image = image; // set the image in the cell
    }];
  } // if !question.image
  
  else // use the cached image
  {
    cell.avatarImageView.image = question.image;
  }
  
  return cell;
} // cellForRowAtIndexPath

@end
