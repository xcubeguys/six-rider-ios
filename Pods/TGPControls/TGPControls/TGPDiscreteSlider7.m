//    @file:    TGPDiscreteSlider7.m
//    @project: TGPControls
//
//    @history: Created July 4th, 2014 (Independence Day)
//    @author:  Xavier Schott
//              mailto://xschott@gmail.com
//              http://thegothicparty.com
//              tel://+18089383634
//
//    @license: http://opensource.org/licenses/MIT
//    Copyright (c) 2014, Xavier Schott
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in
//    all copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//    THE SOFTWARE.

#import "TGPDiscreteSlider7.h"

static CGFloat iOSThumbShadowRadius = 4.0;
static CGSize iosThumbShadowOffset = (CGSize){0, 3};

@interface TGPDiscreteSlider7 () {
    int _intValue;
    int _intMinimumValue;
}
@property (nonatomic) NSMutableArray * ticksAbscisses;
@property (nonatomic, assign) CGFloat thumbAbscisse;
@property (nonatomic) CALayer * thumbLayer;
@property (nonatomic) CALayer * leftTrackLayer;
@property (nonatomic) CALayer * rightTrackLayer;
@property (nonatomic) CALayer * trackLayer;
@property (nonatomic) CALayer * ticksLayer;
@property (nonatomic) CGRect trackRectangle;
@property (nonatomic) BOOL touchedInside;
@end

@implementation TGPDiscreteSlider7

#pragma mark properties

- (void)setTickStyle:(ComponentStyle)tickStyle {
    _tickStyle = tickStyle;
    [self layoutTrack];
}

- (void)setTickSize:(CGSize)tickSize {
    _tickSize.width = MAX(0, tickSize.width);
    _tickSize.height = MAX(0, tickSize.height);
    [self layoutTrack];
}

- (void)setTickCount:(int)tickCount {
    _tickCount = MAX(2, tickCount);
    [self layoutTrack];
}

- (CGFloat)ticksDistance {
    NSAssert1(self.tickCount > 1, @"2 ticks minimum %d", self.tickCount);
    const unsigned int segments = MAX(1, self.tickCount - 1);
    return (self.trackRectangle.size.width / segments);
}

- (void)setTickImage:(NSString *)tickImage {
    _tickImage = tickImage;
    [self layoutTrack];
}

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    [self layoutTrack];
}

- (void)setTrackStyle:(ComponentStyle)trackStyle {
    _trackStyle = trackStyle;
    [self layoutTrack];
}

- (void)setTrackThickness:(CGFloat)trackThickness {
    _trackThickness = MAX(0, trackThickness);
    [self layoutTrack];
}

- (void)setTrackImage:(NSString *)trackImage {
    _trackImage = trackImage;
    [self layoutTrack];
}

- (void)setMinimumTrackTintColor:(UIColor *)minimumTrackTintColor {
    _minimumTrackTintColor = minimumTrackTintColor;
    [self layoutTrack];
}

- (void)setMaximumTrackTintColor:(UIColor *)maximumTrackTintColor {
    _maximumTrackTintColor = maximumTrackTintColor;
    [self layoutTrack];
}

- (void)setThumbStyle:(ComponentStyle)thumbStyle {
    _thumbStyle = thumbStyle;
    [self layoutTrack];
}

- (void)setThumbSize:(CGSize)thumbSize {
    _thumbSize.width = MAX(1, thumbSize.width);
    _thumbSize.height = MAX(1, thumbSize.height);
    [self layoutTrack];
}

- (void)setThumbTintColor:(UIColor *)thumbTintColor {
    _thumbTintColor = thumbTintColor;
    [self layoutTrack];
}

- (void)setThumbImage:(NSString *)thumbImage {
    _thumbImage = thumbImage;

    // Associate image to layer
    NSString * imageName = self.thumbImage;
    if(imageName.length > 0) {
        UIImage * image = [UIImage imageNamed:imageName]; //[NSBundle bundleForClass:[self class]]
        self.thumbLayer.contents = (id)image.CGImage;
    }

    [self layoutTrack];
}

- (void)setThumbShadowRadius:(CGFloat)thumbShadowRadius {
    _thumbShadowRadius = thumbShadowRadius;
    [self layoutTrack];
}

- (void)setThumbShadowOffset:(CGSize)thumbShadowOffset {
    _thumbShadowOffset = thumbShadowOffset;
    [self layoutTrack];
}

- (void)setTicksListener:(NSObject<TGPControlsTicksProtocol> *)ticksListener {
    _ticksListener = ticksListener;
    [self.ticksListener tgpTicksDistanceChanged:self.ticksDistance sender:self];
}

- (void)setIncrementValue:(int)incrementValue {
    _incrementValue = incrementValue;
    if(0 == incrementValue) {
        _incrementValue = 1;  // nonZeroIncrement
    }
    [self layoutTrack];
}

// AKA: UISlider value (as CGFloat for compatibility with UISlider API, but expected to contain integers)
- (void)setMinimumValue:(CGFloat)minimumValue {
    _intMinimumValue = minimumValue;
    [self layoutTrack];
}

- (CGFloat)minimumValue {
    return _intMinimumValue;    // calculated property, with a float-to-int adapter
}

- (void)setValue:(CGFloat)value {
    const unsigned int nonZeroIncrement = ((0 == _incrementValue) ? 1 : _incrementValue);
    const int rootValue = ((value - self.minimumValue) / nonZeroIncrement);
    _intValue = self.minimumValue + (int)(rootValue * nonZeroIncrement);
    [self layoutTrack];
}

- (CGFloat)value {
    return _intValue;           // calculated property, with a float-to-int adapter
}

// When bounds change, recalculate layout
- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    [self layoutTrack];
}

#pragma mark UIControl

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self != nil) {
        [self initProperties];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        [self initProperties];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [self drawTrack];
    [self drawTicks];
    [self drawThumb];
}

- (void)sendActionsForControlEvents {
    // Automatic UIControlEventValueChanged notification
    if([self.ticksListener respondsToSelector:@selector(tgpValueChanged:)]) {
        [self.ticksListener tgpValueChanged:self.value];
    }
}

#pragma mark TGPDiscreteSlider7

- (void)initProperties {
    _tickStyle = ComponentStyleRectangular;
    _tickSize = (CGSize) {1.0, 4.0};
    _tickCount = 11;
    _trackStyle = ComponentStyleIOS;
    _trackThickness = 2.0;
    _minimumTrackTintColor = nil;
    _maximumTrackTintColor = [UIColor colorWithWhite:0.71 alpha:1];
    _thumbStyle = ComponentStyleIOS;
    _thumbSize = (CGSize) {10.0, 10.0};
    _thumbTintColor = nil;
    _thumbShadowRadius = 0.0;
    _thumbShadowOffset = CGSizeZero;
    _intMinimumValue = -5;
    _incrementValue = 1;
    _intValue = 0;
    _ticksAbscisses = [NSMutableArray array];
    _thumbAbscisse = 0.0;
    _trackRectangle = CGRectZero;

    // Track is a clear clipping layer, and left + right sublayers, which brings in free animation
    _trackLayer = [CALayer layer];
    _trackLayer.masksToBounds = YES;
    _trackLayer.backgroundColor = [[UIColor clearColor] CGColor];
    [self.layer addSublayer:self.trackLayer];
    _leftTrackLayer = [CALayer layer];
    _leftTrackLayer.backgroundColor = [self.tintColor CGColor];
    [self.trackLayer addSublayer:self.leftTrackLayer];
    _rightTrackLayer = [CALayer layer];
    _rightTrackLayer.backgroundColor = [self.maximumTrackTintColor CGColor];
    [self.trackLayer addSublayer:self.rightTrackLayer];

    // Ticks in between track and thumb
    _ticksLayer = [CALayer layer];
    [self.layer addSublayer:self.ticksLayer];

    // The thumb is its own CALayer, which brings in free animation
    _thumbLayer = [CALayer layer];
    [self.layer addSublayer:self.thumbLayer];

    self.multipleTouchEnabled = NO;
    [self layoutTrack];
}

- (void)drawTicks {
    self.ticksLayer.frame = self.bounds;
    self.ticksLayer.backgroundColor = [self.tintColor CGColor];

    UIBezierPath *path = [UIBezierPath bezierPath];

    switch (self.tickStyle) {
        case ComponentStyleRounded:
        case ComponentStyleRectangular:
        case ComponentStyleImage: {
            NSAssert(nil != self.ticksAbscisses, @"ticksAbscisses");
            if(nil != self.ticksAbscisses) {

                for(NSValue * originValue in self.ticksAbscisses) {
                    CGPoint originPoint = [originValue CGPointValue];
                    CGRect rectangle = CGRectMake(originPoint.x-(self.tickSize.width/2),
                                                  originPoint.y-(self.tickSize.height/2),
                                                  self.tickSize.width, self.tickSize.height);
                    switch(self.tickStyle) {
                        case ComponentStyleRounded: {
                            [path appendPath:[UIBezierPath bezierPathWithRoundedRect:rectangle
                                                                                 cornerRadius:rectangle.size.height/2]];
                            break;
                        }

                        case ComponentStyleRectangular:
                            [path appendPath:[UIBezierPath bezierPathWithRect:rectangle]];
                            break;

                        case ComponentStyleImage: {
                            // Draw image if exists
                            NSString * imageName = self.tickImage;
                            if(imageName.length > 0) {
                                UIImage * image = [UIImage imageNamed:imageName]; //[NSBundle bundleForClass:[self class]]
                                if(image) {
                                    CGRect centered = CGRectMake(rectangle.origin.x + (rectangle.size.width/2) - (image.size.width/2),
                                                                 rectangle.origin.y + (rectangle.size.height/2) - (image.size.height/2),
                                                                 image.size.width,
                                                                 image.size.height);
                                    const CGContextRef ctx = UIGraphicsGetCurrentContext();
                                    CGContextDrawImage(ctx, centered, image.CGImage);
                                }
                            }
                            break;
                        }

                        case ComponentStyleInvisible:
                        case ComponentStyleIOS:
                        default:
                            NSAssert(FALSE, @"ComponentStyleInvisible, ComponentStyleIOS, default");
                            break;
                    }
                }
            }
            break;
        }

        case ComponentStyleInvisible:
        case ComponentStyleIOS:
        default:
            // Nothing to draw
            break;
    }

    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.trackLayer.bounds;
    maskLayer.path = path.CGPath;
    self.ticksLayer.mask = maskLayer;
}

- (void)drawTrack {
    switch(self.trackStyle) {
        case ComponentStyleRectangular:
            self.trackLayer.frame = self.trackRectangle;
            self.trackLayer.cornerRadius = 0.0;
            break;

        case ComponentStyleInvisible:
            self.trackLayer.frame = CGRectZero;
            break;

        case ComponentStyleImage: {
            self.trackLayer.frame = CGRectZero;

            // Draw image if exists
            NSString * imageName = self.trackImage;
            if(imageName.length > 0) {
                UIImage * image = [UIImage imageNamed:imageName]; //[NSBundle bundleForClass:[self class]]
                if(image) {
                    CGRect centered = CGRectMake((self.frame.size.width/2) - (image.size.width/2),
                                                (self.frame.size.height/2) - (image.size.height/2),
                                                image.size.width,
                                                image.size.height);
                    const CGContextRef ctx = UIGraphicsGetCurrentContext();
                    CGContextDrawImage(ctx, centered, image.CGImage);
                }
            }
            break;
        }

        case ComponentStyleRounded:
        case ComponentStyleIOS:
        default:
            self.trackLayer.frame = self.trackRectangle;
            self.trackLayer.cornerRadius = CGRectGetHeight(self.trackRectangle)/2.0;
            break;
    }

    self.leftTrackLayer.frame = ({
        CGRect frame = self.trackLayer.bounds;
        frame.size.width = self.thumbAbscisse - CGRectGetMinX(self.trackRectangle);
        frame;
    });
    self.leftTrackLayer.backgroundColor = ((nil == self.minimumTrackTintColor)
                                           ? [self.tintColor CGColor]
                                           : [self.minimumTrackTintColor CGColor]);

    self.rightTrackLayer.frame = ({
        CGRect frame = self.trackLayer.bounds;
        frame.size.width = CGRectGetWidth(self.trackRectangle) - CGRectGetWidth(self.leftTrackLayer.frame);
        frame.origin.x = CGRectGetMaxX(self.leftTrackLayer.frame);
        frame;
    });
    self.rightTrackLayer.backgroundColor = [self.maximumTrackTintColor CGColor];
}

- (void)drawThumb {
    if( self.value >= self.minimumValue) {  // Feature: hide the thumb when below range

        const CGSize thumbSizeForStyle = [self thumbSizeIncludingShadow];
        const CGFloat thumbWidth = thumbSizeForStyle.width;
        const CGFloat thumbHeight = thumbSizeForStyle.height;
        const CGRect rectangle = CGRectMake(self.thumbAbscisse - (thumbWidth / 2),
                                            (self.frame.size.height - thumbHeight)/2,
                                            thumbWidth,
                                            thumbHeight);
        
        const CGFloat shadowRadius = ((self.thumbStyle == ComponentStyleIOS)
                                      ? iOSThumbShadowRadius
                                      : self.thumbShadowRadius);
        const CGSize shadowOffset = ((self.thumbStyle == ComponentStyleIOS)
                                     ? iosThumbShadowOffset
                                     : self.thumbShadowOffset);
        
        self.thumbLayer.frame = ((shadowRadius != 0.0)  // Ignore offset if there is no shadow
                                 ? CGRectInset(rectangle,
                                               shadowRadius + shadowOffset.width,
                                               shadowRadius + shadowOffset.height)
                                 : CGRectInset(rectangle, shadowRadius, shadowRadius));
        
        switch(self.thumbStyle) {
            case ComponentStyleRounded: // A rounded thumb is circular
                self.thumbLayer.backgroundColor = ((nil == self.thumbTintColor)
                                                   ? [[UIColor lightGrayColor] CGColor]
                                                   : [self.thumbTintColor CGColor]);
                self.thumbLayer.borderColor = [[UIColor clearColor] CGColor];
                self.thumbLayer.borderWidth = 0.0;
                self.thumbLayer.cornerRadius = self.thumbLayer.frame.size.width/2;
                self.thumbLayer.allowsEdgeAntialiasing = YES;
                break;
                
            case ComponentStyleImage: {
                // image is set using layer.contents
                self.thumbLayer.backgroundColor = [[UIColor clearColor] CGColor];
                self.thumbLayer.borderColor = [[UIColor clearColor] CGColor];
                self.thumbLayer.borderWidth = 0.0;
                self.thumbLayer.cornerRadius = 0.0;
                self.thumbLayer.allowsEdgeAntialiasing = NO;
                break;
            }

            case ComponentStyleRectangular:
                self.thumbLayer.backgroundColor = ((nil == self.thumbTintColor)
                                                   ? [[UIColor lightGrayColor] CGColor]
                                                   : [self.thumbTintColor CGColor]);
                self.thumbLayer.borderColor = [[UIColor clearColor] CGColor];
                self.thumbLayer.borderWidth = 0.0;
                self.thumbLayer.cornerRadius = 0.0;
                self.thumbLayer.allowsEdgeAntialiasing = NO;
                break;
                
            case ComponentStyleInvisible:
                self.thumbLayer.backgroundColor = [[UIColor clearColor] CGColor];
                self.thumbLayer.cornerRadius = 0.0;
                break;
                
            case ComponentStyleIOS:
            default: {
                UIColor * backgroundColor = ((nil == self.thumbTintColor)
                                             ? [UIColor whiteColor]
                                             : self.thumbTintColor);
                self.thumbLayer.backgroundColor = [backgroundColor CGColor];
                // Only default iOS thumb has a border
                if(nil == self.thumbTintColor) {
                    const UIColor * borderColor = [UIColor colorWithWhite:0.5 alpha: 1];
                    self.thumbLayer.borderColor = [borderColor CGColor];
                    self.thumbLayer.borderWidth = 0.25;
                } else {
                    self.thumbLayer.borderWidth = 0;
                }
                self.thumbLayer.cornerRadius = self.thumbLayer.frame.size.width/2;
                self.thumbLayer.allowsEdgeAntialiasing = YES;
                break;
            }
        }
        
        // Shadow
        if(shadowRadius != 0.0) {
#if TARGET_INTERFACE_BUILDER
            self.thumbLayer.shadowOffset = CGSizeMake(shadowOffset.width, -shadowOffset.height);
#else // !TARGET_INTERFACE_BUILDER
            self.thumbLayer.shadowOffset = shadowOffset;
#endif // TARGET_INTERFACE_BUILDER
            
            self.thumbLayer.shadowRadius = shadowRadius;
            self.thumbLayer.shadowColor = [[UIColor blackColor] CGColor];
            self.thumbLayer.shadowOpacity = 0.15;
        } else {
            self.thumbLayer.shadowRadius = 0.0;
            self.thumbLayer.shadowOffset = CGSizeZero;
            self.thumbLayer.shadowColor = [[UIColor clearColor] CGColor];
            self.thumbLayer.shadowOpacity = 0.0;
        }
    }
}

- (void)layoutTrack {
    NSAssert1(self.tickCount > 1, @"2 ticks minimum %d", self.tickCount);
    const unsigned int segments = MAX(1, self.tickCount - 1);
    const CGFloat thumbWidth = [self thumbSizeIncludingShadow].width;

    // Calculate the track ticks positions
    const CGFloat trackHeight = ((ComponentStyleIOS == self.trackStyle)
                                 ? 2.0
                                 : self.trackThickness);
    CGSize trackSize = CGSizeMake(self.frame.size.width - thumbWidth, trackHeight);
    if(ComponentStyleImage == self.trackStyle) {
        NSString * imageName = self.trackImage;
        if(imageName.length > 0) {
            UIImage * image = [UIImage imageNamed:imageName]; //[NSBundle bundleForClass:[self class]]
            if(image) {
                trackSize.width = image.size.width - thumbWidth;
            }
        }
    }

    self.trackRectangle = CGRectMake((self.frame.size.width - trackSize.width)/2,
                                     (self.frame.size.height - trackSize.height)/2,
                                     trackSize.width,
                                     trackSize.height);
    const CGFloat trackY = self.frame.size.height / 2;
    [self.ticksAbscisses removeAllObjects];
    for( int iterate = 0; iterate <= segments; iterate++) {
        const double ratio = (double)iterate / (double)segments;
        const CGFloat originX = self.trackRectangle.origin.x + (CGFloat)(trackSize.width * ratio);
        [self.ticksAbscisses addObject: [NSValue valueWithCGPoint:CGPointMake(originX, trackY)]];
    }
    [self layoutThumb];
    
    // If we have a TGPDiscreteSliderTicksListener (such as TGPCamelLabels), broadcast new spacing
    [self.ticksListener tgpTicksDistanceChanged:self.ticksDistance sender:self];
    [self setNeedsDisplay];
}

- (void)layoutThumb {
    NSAssert1(self.tickCount > 1, @"2 ticks minimum %d", self.tickCount);
    const unsigned int segments = MAX(1, self.tickCount - 1);

    // Calculate the thumb position
    const unsigned int nonZeroIncrement = ((0 == self.incrementValue) ? 1 : self.incrementValue);
    double thumbRatio = (double)(self.value - self.minimumValue) / (double)(segments * nonZeroIncrement);
    thumbRatio = MAX(0.0, MIN(thumbRatio, 1.0)); // Normalized
    self.thumbAbscisse = self.trackRectangle.origin.x + (self.trackRectangle.size.width * thumbRatio);
}

- (CGSize)thumbSizeIncludingShadow {
    switch (self.thumbStyle) {
        case ComponentStyleInvisible:
        case ComponentStyleRectangular:
        case ComponentStyleRounded:
            return ((self.thumbShadowRadius != 0.0)
                    ? CGSizeMake(self.thumbSize.width
                                 + (self.thumbShadowRadius * 2)
                                 + (self.thumbShadowOffset.width * 2),
                                 self.thumbSize.height
                                 + (self.thumbShadowRadius * 2)
                                 + (self.thumbShadowOffset.height * 2))
                    : self.thumbSize);

        case ComponentStyleIOS:
            return CGSizeMake(28.0
                              + (iOSThumbShadowRadius * 2)
                              + (iosThumbShadowOffset.width * 2),
                              28.0
                              + (iOSThumbShadowRadius * 2)
                              + (iosThumbShadowOffset.height * 2));

        case ComponentStyleImage: {
            NSString * imageName = self.thumbImage;
            if (imageName.length > 0) {
                return [UIImage imageNamed:imageName].size;
            }
            // Fall through
        }

        default:
            return (CGSize){33.0, 33.0};
    }
}

#pragma mark UIResponder

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.touchedInside = YES;

    [self touchDown:touches animationDuration:0.1];
    [self sendActionForControlEvent:UIControlEventValueChanged forEvent:event];
    [self sendActionForControlEvent:UIControlEventTouchDown forEvent:event];

    const UITouch * touch = [touches anyObject];
    if(nil != touch) {
        if(touch.tapCount > 1) {
            [self sendActionForControlEvent:UIControlEventTouchDownRepeat forEvent:event];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchDown:touches animationDuration:0.0];

    BOOL inside = [self touchesAreInside:touches];

    [self sendActionForControlEvent:UIControlEventValueChanged forEvent:event];
    // Crossing boundary
    if(inside != self.touchedInside) {
        [self sendActionForControlEvent:((inside)
                                         ? UIControlEventTouchDragEnter
                                         : UIControlEventTouchDragExit)
                               forEvent:event];
        self.touchedInside = inside;
    }
    // Drag
    [self sendActionForControlEvent:((inside)
                                     ? UIControlEventTouchDragInside
                                     : UIControlEventTouchDragOutside)
                           forEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchUp:touches];

    [self sendActionForControlEvent:UIControlEventValueChanged forEvent:event];
    [self sendActionForControlEvent:(([self touchesAreInside:touches])
                                     ? UIControlEventTouchUpInside
                                     : UIControlEventTouchUpOutside)
                           forEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchUp:touches];

    [self sendActionForControlEvent:UIControlEventValueChanged forEvent:event];
    [self sendActionForControlEvent:UIControlEventTouchCancel forEvent:event];
}

#pragma mark Touches

- (void)touchDown:(NSSet *)touches animationDuration:(NSTimeInterval)duration {
    const UITouch * touch = [touches anyObject];
    if(nil != touch) {
        const CGPoint location = [touch locationInView:touch.view];
        [self moveThumbTo:location.x animationDuration:duration];
    }
}

- (void)touchUp:(NSSet *)touches {
    const UITouch * touch = [touches anyObject];
    if(nil != touch) {
        const CGPoint location = [touch locationInView:touch.view];
        const unsigned int tick = [self pickTickFromSliderPosition:location.x];
        [self moveThumbToTick:tick];
    }
}

- (BOOL)touchesAreInside:(NSSet *)touches {
    BOOL inside = NO;
    const UITouch * touch = [touches anyObject];
    if(nil != touch) {
        const CGPoint location = [touch locationInView:touch.view];
        inside = CGRectContainsPoint(touch.view.bounds, location);
    }
    return inside;
}

#pragma mark Notifications

- (void)moveThumbToTick:(unsigned int)tick {
    const unsigned int nonZeroIncrement = ((0 == self.incrementValue) ? 1 : self.incrementValue);
    int intValue = self.minimumValue + (tick * nonZeroIncrement);
    if( intValue != _intValue) {
        _intValue = intValue;
        [self sendActionsForControlEvents];
    }

    [self layoutThumb];
    [self setNeedsDisplay];
}

- (void)moveThumbTo:(CGFloat)abscisse animationDuration:(CFTimeInterval)duration {
    const CGFloat leftMost = CGRectGetMinX(self.trackRectangle);
    const CGFloat rightMost = CGRectGetMaxX(self.trackRectangle);

    self.thumbAbscisse = MAX(leftMost, MIN(abscisse, rightMost));
    [CATransaction setAnimationDuration:duration];

    const unsigned int tick = [self pickTickFromSliderPosition:self.thumbAbscisse];
    const unsigned int nonZeroIncrement = ((0 == self.incrementValue) ? 1 : self.incrementValue);
    int intValue = self.minimumValue + (tick * nonZeroIncrement);
    if( intValue != _intValue) {
        _intValue = intValue;
        [self sendActionsForControlEvents];
    }

    [self setNeedsDisplay];
}

- (unsigned int)pickTickFromSliderPosition:(CGFloat)abscisse {
    const CGFloat leftMost = CGRectGetMinX(self.trackRectangle);
    const CGFloat rightMost = CGRectGetMaxX(self.trackRectangle);
    const CGFloat clampedAbscisse = MAX(leftMost, MIN(abscisse, rightMost));
    const double ratio = (double)(clampedAbscisse - leftMost) / (double)(rightMost - leftMost);
    const unsigned int segments = MAX(1, self.tickCount - 1);
    return (unsigned int) round( (double)segments * ratio);
}

- (void)sendActionForControlEvent:(UIControlEvents)controlEvent forEvent:(UIEvent *)event {
    //  Interface builder hides the IBInspectable for UIControl
#if !TARGET_INTERFACE_BUILDER
    for (id target in self.allTargets) {
        NSArray *actions = [self actionsForTarget:target forControlEvent:controlEvent];
        for (NSString *action in actions) {
            [self sendAction:NSSelectorFromString(action)
                          to:target
                    forEvent:event];

        }
    }
#endif // !TARGET_INTERFACE_BUILDER
}

#pragma mark - Interface Builder

#if TARGET_INTERFACE_BUILDER
//  Interface builder hides the IBInspectable for UIControl
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {}
#endif // TARGET_INTERFACE_BUILDER

@end
