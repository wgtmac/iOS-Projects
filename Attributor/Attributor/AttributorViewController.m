//
//  ViewController.m
//  Attributor
//
//  Created by Gang Wu on 7/22/15.
//  Copyright (c) 2015 Gang Wu. All rights reserved.
//

#import "AttributorViewController.h"

@interface AttributorViewController ()
@property (weak, nonatomic) IBOutlet UITextView *body;
@property (weak, nonatomic) IBOutlet UILabel *headline;
@property (weak, nonatomic) IBOutlet UIButton *outlineButton;

@end

@implementation AttributorViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(preferredFontChanged:)
                                               name:UIContentSizeCategoryDidChangeNotification
                                             object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIContentSizeCategoryDidChangeNotification
                                                  object:nil];
}

-(void)preferredFontChanged:(NSNotification *)notification{
    [self usePreferredFonts];
}

-(void)usePreferredFonts{
    
}

- (IBAction)changeColorFromButtonBackgroundColor:(UIButton *)sender {
    //[self.body setBackgroundColor:sender.backgroundColor];
    [self.body.textStorage addAttribute:NSForegroundColorAttributeName value:sender.backgroundColor range:self.body.selectedRange];
}

- (IBAction)addOutlineToSelectedText {
    [self.body.textStorage addAttributes:@{ NSStrokeWidthAttributeName : @-3, NSStrokeColorAttributeName : [UIColor blackColor]} range:self.body.selectedRange];
}

- (IBAction)removeOutlineToSelectedText {
    [self.body.textStorage removeAttribute:NSStrokeWidthAttributeName range:self.body.selectedRange];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:self.outlineButton.currentTitle];
    [title setAttributes:@{ NSStrokeWidthAttributeName : @3,
                            NSStrokeColorAttributeName : self.outlineButton.tintColor}
                   range:NSMakeRange(0, [title length])];
    [self.outlineButton setAttributedTitle:title forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
