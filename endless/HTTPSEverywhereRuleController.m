#import "AppDelegate.h"
#import "HTTPSEverywhere.h"
#import "HTTPSEverywhereRule.h"
#import "HTTPSEverywhereRuleController.h"

@implementation HTTPSEverywhereRuleController

AppDelegate *appDelegate;
NSMutableArray *sortedRuleNames;

UISearchBar *searchBar;
NSMutableArray *searchResult;
UISearchDisplayController *searchDisplayController;

- (id)initWithStyle:(UITableViewStyle)style
{
	self = [super initWithStyle:style];
	if (self) {
		appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
		
		sortedRuleNames = [NSMutableArray arrayWithArray:[[[HTTPSEverywhere rules] allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
		
		searchResult = [NSMutableArray arrayWithCapacity:[sortedRuleNames count]];
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	
	searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
	searchDisplayController.delegate = self;
	searchDisplayController.searchResultsDataSource = self;
	
	[[self tableView] setTableHeaderView:searchBar];
	
	self.title = @"HTTPS Everywhere Rules";
}

- (void)viewWillDisappear:(BOOL)animated
{
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (tableView == searchDisplayController.searchResultsTableView) {
		return [searchResult count];
	}
	else {
		return [sortedRuleNames count];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rule"];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rule"];
	}
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	if (tableView == searchDisplayController.searchResultsTableView) {
		cell.textLabel.text = [searchResult objectAtIndex:indexPath.row];
	}
	else {
		cell.textLabel.text = [sortedRuleNames objectAtIndex:indexPath.row];
	}
	
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
	NSLog(@"here");
	
	[searchResult removeAllObjects];
	
	for (NSString *ruleName in sortedRuleNames) {
		NSRange range = [ruleName rangeOfString:searchString options:NSCaseInsensitiveSearch];
			
		if (range.length > 0) {
			[searchResult addObject:ruleName];
		}
	}
	
	NSLog(@"ended with %@", searchResult);
	
	return YES;
}

@end