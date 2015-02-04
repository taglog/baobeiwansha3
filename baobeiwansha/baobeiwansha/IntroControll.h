#import <UIKit/UIKit.h>
#import "IntroView.h"

@protocol IntroDelegate <NSObject>

-(void) IntroFinished;

@end


@interface IntroControll : UIView<UIScrollViewDelegate> {
    UIImageView *backgroundImage1;
    UIImageView *backgroundImage2;
    
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    NSArray *pages;
    
    NSTimer *timer;
    
    int currentPhotoNum;
}

- (id)initWithFrame:(CGRect)frame pages:(NSArray*)pages;

@property (weak) id <IntroDelegate> delegate;

@end
