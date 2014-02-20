//
//  MessageViewController.m
//  HU Keccak App
//
//  Created by Philip J Browning II on 11/4/13.
//  Copyright (c) 2013 Philip Browning. All rights reserved.
//

#import "DetailViewController.h"
#import "EditSettingsViewController.h"
#import "MessageViewController.h"
#import "Message.h"
#import "KeccakMessage.h"
#import "PlainTextCell.h"
#import "CypherTextCell.h"

@interface MessageViewController () <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) NSUInteger keccakCapacity;
@property (nonatomic) NSUInteger keccakRate;
@property (nonatomic) NSUInteger keccakOutputLength;
@property (nonatomic) BOOL keccakFixedOutputLength;
@property (nonatomic) BOOL saveRoundState;

- (void)encryptMessage:(NSString*)message;
- (void)updateUserDefaults:(NSNotification *)notification;

@end

@implementation MessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (!_messageList) {
        _messageList = [[MessageList alloc] init];
    }
    
    [self loadUserDefaults];
    self.messageIndexList = [[NSMutableArray alloc] init];
    
    [self registerForKeyboardNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserDefaults:) name:@"HUKeccakUpdatedUserDefaults" object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)encryptMessage:(NSString*)message
{
    NSString *somePlainText = self.userInputMessage.text;
    
    // Add to our model
    [_messageList insertMessage:[[Message alloc] initWithString:somePlainText]];
    
    // Update collection view
    // Change to [self messageCollectionView] insertItemsAtIndexPaths:arrayWithIndexPaths];
    [self.messageCollectionView reloadData];
    
    // Clear input text
    [self.userInputMessage setText:@""];
    
    // Create Keccak Object
    KeccakMessage *newMessage = [[KeccakMessage alloc] initWithPlainText:somePlainText withCapacity:self.keccakCapacity withRate:self.keccakRate withOutputLength:self.keccakOutputLength andFixedOutputLength:self.keccakFixedOutputLength];
    
    // Set cypher message and log data
    CypherMessage *cypherMessage = [[CypherMessage alloc] init];
    cypherMessage.log.capacity = _keccakCapacity;
    cypherMessage.log.rate = _keccakRate;
    cypherMessage.log.outputLength = _keccakOutputLength;
    cypherMessage.log.fixedOutputLength = _keccakFixedOutputLength;
    cypherMessage.text = [newMessage encryptMessage];
    
    // Add to our model
    [_messageList insertCypherMessage:cypherMessage];
    
    // Update collection view
    // Change to [self messageCollectionView] insertItemsAtIndexPaths:arrayWithIndexPaths];
    [self.messageCollectionView reloadData];
}

- (IBAction)encryptButtonPressed:(id)sender
{
    [self.userInputMessage resignFirstResponder];
    
    // Start Keccak if empty string is not in the user input
    if ([self messageIsNotEmpty]) {
        [self encryptMessage:self.userInputMessage.text];
    }
}

- (BOOL)messageIsNotEmpty
{
    // Start Keccak if empty string is not in the user input
    if (![self.userInputMessage.text isEqualToString:@""]) {
        return YES;
    } else {
        UIAlertView *noTextEnteredAlert = [[UIAlertView alloc] initWithTitle:@"Empty Message" message:@"You must type a plain text message for it to be encrypted." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [noTextEnteredAlert show];
        return NO;
    }
}

#pragma mark - Keyboard Functionality

- (IBAction)textFieldDidEndEditing:(UITextField *)sender {
    [sender resignFirstResponder];
    // Start Keccak if empty string is not in the user input
    if ([self messageIsNotEmpty]) {
        [self encryptMessage:self.userInputMessage.text];
    }
}

- (void)dismissKeyboard {
    [self.userInputMessage resignFirstResponder];
}


// Call this method somewhere in your view controller setup code.

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}


// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    // If active text field is hidden by keyboard, scroll it so it's visible
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:[[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:[self view] cache:YES];
    [self.inputMessageView setFrame:CGRectMake(self.inputMessageView.frame.origin.x, (self.inputMessageView.frame.origin.y - kbSize.height), self.inputMessageView.frame.size.width, (self.inputMessageView.frame.size.height + kbSize.height))];
    [UIView commitAnimations];
}


// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:[[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:[self view] cache:YES];
    [self.inputMessageView setFrame:CGRectMake(self.inputMessageView.frame.origin.x, (self.inputMessageView.frame.origin.y + kbSize.height), self.inputMessageView.frame.size.width, (self.inputMessageView.frame.size.height - kbSize.height))];
    [UIView commitAnimations];
}

#pragma mark - CollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.messageList numberOfTotalMessages];
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    if ([[self.messageList getMessageAtIndex:indexPath.row] isKindOfClass:[CypherMessage class]]) {
        CypherMessage* currentMessage = (CypherMessage*)[_messageList getMessageAtIndex:indexPath.row];
        cell = [self.messageCollectionView dequeueReusableCellWithReuseIdentifier:@"CypherTextCell" forIndexPath:indexPath];
        [self updateCell:cell usingMessage:currentMessage atIndexPath:indexPath];
    }
    else if ([[self.messageList getMessageAtIndex:indexPath.row] isKindOfClass:[Message class]]) {
        Message* currentMessage = (Message*)[_messageList getMessageAtIndex:indexPath.row];
        cell = [self.messageCollectionView dequeueReusableCellWithReuseIdentifier:@"PlainTextCell" forIndexPath:indexPath];
        [self updateCell:cell usingMessage:currentMessage atIndexPath:indexPath];
    } else {
        [NSException raise:NSInternalInconsistencyException
                    format:@"The type of cell in %@ can only be of class Message or CypherMessage. Please refer to MessageList.h", NSStringFromSelector(_cmd)];
    }
    
    /*
    Message* currentMessage = [[Message alloc] initWithMessage:[self.messageList getMessageAtIndex:indexPath.row]];
    [self.messageIndexList addObject:indexPath];
    */
    
    /*
    if (currentMessage.getType == PLAIN_TEXT) {
        cell = [self.messageCollectionView dequeueReusableCellWithReuseIdentifier:@"PlainTextCell" forIndexPath:indexPath];
    } else if (currentMessage.getType == CYPHER_TEXT) {
        cell = [self.messageCollectionView dequeueReusableCellWithReuseIdentifier:@"CypherTextCell" forIndexPath:indexPath];
        // phoneButton.tag = 80
    } else {
        [NSException raise:NSInternalInconsistencyException
                    format:@"The type of cell in %@ can only be PLAIN_TEXT or CYPHER_TEXT. Please refer to MessageType.h", NSStringFromSelector(_cmd)];
    }
    [self updateCell:cell usingMessage:currentMessage atIndexPath:indexPath];
     */
    return cell;
}

- (void)updateCell:(UICollectionViewCell*)cell usingMessage:(id)aMessage atIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[PlainTextCell class]]) {
        Message *message = (Message*)aMessage;
        PlainTextCell *plainTextMessageCell = (PlainTextCell *)cell;
        plainTextMessageCell.messageTextLabel.text = message.text;
    }
    else if([cell isKindOfClass:[CypherTextCell class]]) {
        CypherMessage *cypherMessage = (CypherMessage*)aMessage;
        CypherTextCell *cypherTextMessageCell = (CypherTextCell *)cell;
        cypherTextMessageCell.messageTextLabel.text = cypherMessage.text;
        cypherTextMessageCell.detailViewButton.tag = indexPath.row;
    }
}

#pragma mark - Navigation
 
// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"DetailViewSegue"])
    {
        // Get reference to the destination view controller
        DetailViewController *dvc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        NSUInteger index = [(UIButton *)sender tag];
        dvc.itemIndex = index;
        dvc.plainTextMessage = [self.messageList getMessageAtIndex:(index - 1)];
        dvc.cypherTextMessage = [self.messageList getMessageAtIndex:index];
        dvc.c = dvc.cypherTextMessage.log.capacity;
        dvc.r = dvc.cypherTextMessage.log.rate;
        
        
        // Figure out how to send objects above
        UIButton *button = (UIButton *)sender;
        // NSLog(@"%ld", (long)[button tag]);
        // NSDictionary *item = list[sender.tag];
        
        // dvc.plainTextLabel.text = [[self.messageList getMessageAtIndex:([(UIButton *)sender tag] - 1)] text];
        // dvc.cypherTextLabel.text = [[self.messageList getMessageAtIndex:[(UIButton *)sender tag]] text];
        
    }
    else if ([[segue identifier] isEqualToString:@"EditSettingsSegue"])
    {
        // Get reference to the destination view controller
        EditSettingsViewController *esvc = [segue destinationViewController];
        
        esvc.capacity = self.keccakCapacity;
        esvc.rate = self.keccakRate;
        esvc.saveRoundState = self.saveRoundState;
        esvc.outputLength = self.keccakOutputLength;
        esvc.fixedOutputLength = self.keccakFixedOutputLength;
    }
}

#pragma mark - NSUserDefaults

- (void)loadUserDefaults
{
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    
    // Loading Keccak Capacity
    if ([standardDefaults stringForKey:@"keccakCapacity"] == nil) {
        [standardDefaults setObject:@"160" forKey:@"keccakCapacity"];
        self.keccakCapacity = 160;
    } else {
        self.keccakCapacity = [[standardDefaults objectForKey:@"keccakCapacity"] integerValue];
    }
    
    // Loading Keccak Rate
    if ([standardDefaults stringForKey:@"keccakRate"] == nil) {
        [standardDefaults setObject:@"40" forKey:@"keccakRate"];
        self.keccakRate = 40;
    } else {
        self.keccakRate = [[standardDefaults objectForKey:@"keccakRate"] integerValue];
    }
    
    // Load and Save Kecak Output Length
    if ([standardDefaults stringForKey:@"keccakOutputLength"] == nil) {
        self.keccakOutputLength = self.keccakCapacity + self.keccakRate;
        [standardDefaults setObject:[NSString stringWithFormat:@"%lu", self.keccakOutputLength] forKey:@"keccakOutputLength"];
    } else {
        self.keccakOutputLength = [[standardDefaults objectForKey:@"keccakOutputLength"] integerValue];
    }
    
    // Loading Fixed Output Length
    if ([standardDefaults stringForKey:@"keccakFixedOutputLength"] == nil) {
        [standardDefaults setObject:@"NO" forKey:@"keccakFixedOutputLength"];
        self.keccakFixedOutputLength = NO;
    } else {
        self.keccakFixedOutputLength = [[standardDefaults objectForKey:@"keccakFixedOutputLength"] boolValue];
    }
    
    // Loading Keccak Round State Saving
    if ([standardDefaults stringForKey:@"saveRoundState"] == nil) {
        [standardDefaults setObject:@"NO" forKey:@"saveRoundState"];
        self.saveRoundState = NO;
    } else {
        self.saveRoundState = [[standardDefaults objectForKey:@"saveRoundState"] boolValue];
    }
}

#pragma mark - NSNotificationCenter

- (void)updateUserDefaults:(NSNotification *)notification
{    
    NSMutableDictionary *dictionary =(NSMutableDictionary*) [notification object];
    // NSLog(@"Notification Method Call.And object content is :%@", dictionary);
    if ([dictionary objectForKey:@"keccakRate"]) {
        self.keccakRate = [[dictionary objectForKey:@"keccakRate"] integerValue];
    }
    if ([dictionary objectForKey:@"keccakCapacity"]) {
        self.keccakCapacity = [[dictionary objectForKey:@"keccakCapacity"] integerValue];
    }
    if ([dictionary objectForKey:@"keccakOutputLength"]) {
        self.keccakOutputLength = [[dictionary objectForKey:@"keccakOutputLength"] integerValue];
    }
}

@end