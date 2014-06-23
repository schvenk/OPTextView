//
//  OPTextView.m
//  OPTextView: https://github.com/schvenk/OPTextView
//
//  Created by Dave Feldman on 5/18/14.
//
//

#import "OPTextView.h"

@interface OPTextView ()
@property (nonatomic, readonly) UILabel *placeholderLabel;
@end

@implementation OPTextView
@synthesize placeholderLabel = _placeholderLabel;

#define TextChangedAnimationDuration 0.15

- (id)initWithFrame:(CGRect)frame {
    if( (self = [super initWithFrame:frame]) ) {
        [self setPlaceholder:@""];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Use Interface Builder User Defined Runtime Attributes to set
    // placeholder and placeholderColor in Interface Builder.
    if (!self.placeholder) {
        self.placeholder = @"";
    }
    
    if (!self.placeholderColor) {
        self.placeholderColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
}

- (void)dealloc {
    if (_placeholderLabel) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}




#pragma mark - Listening for changes

- (void)textChanged:(NSNotification *)notification {
    if ([[self placeholder] length] == 0) {
        return;
    }
    
    [UIView animateWithDuration:TextChangedAnimationDuration animations:^{
        self.placeholderLabel.alpha = self.text.length ? 0 : 1;
    }];
}




#pragma mark - Properties

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
}

- (UILabel*)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _placeholderLabel.numberOfLines = 0;
        _placeholderLabel.font = self.font;
        _placeholderLabel.backgroundColor = [UIColor clearColor];
        _placeholderLabel.textColor = self.placeholderColor;
        _placeholderLabel.alpha = 0;
        [self addSubview:_placeholderLabel];
        
        NSDictionary* bindings = NSDictionaryOfVariableBindings(_placeholderLabel);
        NSDictionary* insetValues = @{@"leftInset": @(self.textContainerInset.left + self.textContainer.lineFragmentPadding),
                                      @"topInset": @(self.textContainerInset.top),
                                      @"rightInset": @(self.textContainerInset.right + self.textContainer.lineFragmentPadding)};
        NSArray* constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-(leftInset)-[_placeholderLabel]-(rightInset)-|"
                                                                       options:0
                                                                       metrics:insetValues
                                                                         views:bindings];
        [self addConstraints:constraints];
        
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(topInset)-[_placeholderLabel]"
                                                              options:0
                                                              metrics:insetValues
                                                                views:bindings];
        [self addConstraints:constraints];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:self];
    }
    
    return _placeholderLabel;
}

- (void)setPlaceholder:(NSString *)placeholder {
    self.placeholderLabel.text = placeholder;
    [self.placeholderLabel sizeToFit];
    [self sendSubviewToBack:self.placeholderLabel];

    if (self.text.length == 0 && self.placeholder.length > 0) {
        self.placeholderLabel.alpha = 1;
    }
}
- (NSString *)placeholder {
    return self.placeholderLabel.text;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    self.placeholderLabel.textColor = placeholderColor;
}
- (UIColor *)placeholderColor {
    return self.placeholderLabel.textColor;
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [_placeholderLabel setFont:font];
}
@end