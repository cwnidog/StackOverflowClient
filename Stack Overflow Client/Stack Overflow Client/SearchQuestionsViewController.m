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

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
  [[StackOverflowService sharedService] fetchQuestionsWithSearchTerm:searchBar.text completionHandler:^(NSArray *results, NSString *error) {
    if ([results count] == 0)
    {
      // lifted from StackOverflow - somehow seems appropriate
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Results" message:@"Stack Overflow returned no results for search target - please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
      [alert show];
    }
    self.questions = results;
    if (error)
    {
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ResultsError" message:@"Received an unspecified error getting questions." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
      [alert show];
    } // if error
    [self.tableView reloadData];
  }];
} // searchBarSearchButtonClicked()

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.questions.count;
} // numberOfRowsInSection

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QUESTION_CELL"];
  cell.avatarImageView.image = nil;
  Question *question = self.questions[indexPath.row];
  cell.titleTextView.text = question.title;
  if (!question.image)
  {
    [[StackOverflowService sharedService] fetchUserImage:question.avatarURL completionHandler:^(UIImage *image) {
      question.image = image;
      cell.avatarImageView.image = image;
    }];
  } // if !question.image
  else
  {
    cell.avatarImageView.image = question.image;
  }
  
  return cell;
} // cellForRowAtIndexPath



@end
