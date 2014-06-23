//
//  OPTextView.h
//  OPTextView: https://github.com/schvenk/OPTextView
//
//  Created by Dave Feldman on 5/18/14. MIT License
//
//  OPTextView is a simple subclass of UITextView that supports a placeholder.
//  To set the placeholder text in IB, use custom properties.
//  To set the placeholder color in IB, use the tint color.
//

#import <UIKit/UIKit.h>

@interface OPTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

- (void)setPlaceholder:(NSString *)placeholder animated:(BOOL)animated;
@end