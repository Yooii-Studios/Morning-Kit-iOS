//
//  MNAlarmPreferenceRepeatController.m
//  Morning Kit
//
//  Created by 김우성 on 12. 11. 8..
//  Copyright (c) 2012년 Yooii. All rights reserved.
//

#import "MNAlarmPreferenceRepeatController.h"
#import "MNAlarmRepeatDayOfWeekStringMaker.h"

@interface MNAlarmPreferenceRepeatController ()

@end

@implementation MNAlarmPreferenceRepeatController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    NSLog(@"viewDidLoad");
    
    self.title = MNLocalizedString(@"alarm_pref_repeat", @"반복");
    
    // alarmRepeatDayOfWeek creation
    if (!self.alarmRepeatDayOfWeek) {
        self.alarmRepeatDayOfWeek = [NSMutableArray arrayWithObjects:
                                     [NSNumber numberWithBool:NO],          // Mon
                                     [NSNumber numberWithBool:NO],          // Tue
                                     [NSNumber numberWithBool:NO],          // Wed
                                     [NSNumber numberWithBool:NO],          // Thu
                                     [NSNumber numberWithBool:NO],          // Fri
                                     [NSNumber numberWithBool:NO],          // Sat
                                     [NSNumber numberWithBool:NO], nil];    // Sun
    }
    
    /*
    for (NSNumber *repeatDayOfWeek in self.alarmRepeatDayOfWeek) {
        NSLog(@"repeat : %@", [repeatDayOfWeek boolValue]? @"YES" : @"NO");
    }
     */
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

// 네비게이션 백 버튼을 클릭할 경우 발생
- (void)viewWillDisappear:(BOOL)animated {
    [self.delegate MNAlarmPreferenceRepeatControllerDidSelectingRepeat:self];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = [MNAlarmRepeatDayOfWeekStringMaker makeEveryRepeatStringWithRow:indexPath.row];
    
    if ([[self.alarmRepeatDayOfWeek objectAtIndex:indexPath.row] boolValue] == YES) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    // Check YES
    if (cell.accessoryType == UITableViewCellAccessoryNone) {

        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.alarmRepeatDayOfWeek replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:YES]];
    }
        
    // Check NO
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.alarmRepeatDayOfWeek replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:NO]];
    }
    
    /*
    for (NSNumber *repeatDayOfWeek in self.alarmRepeatDayOfWeek) {
        NSLog(@"repeat : %@", [repeatDayOfWeek boolValue]? @"YES" : @"NO");
    }
    */
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
