#import "IntroControll.h"

@implementation IntroControll


- (id)initWithFrame:(CGRect)frame pages:(NSArray*)pagesArray
{
    self = [super initWithFrame:frame];
    if(self != nil) {
        
        //Initial Background images
        
        self.backgroundColor = [UIColor blackColor];
        
        backgroundImage1 = [[UIImageView alloc] initWithFrame:frame];
        [backgroundImage1 setContentMode:UIViewContentModeScaleAspectFill];
        [backgroundImage1 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        [self addSubview:backgroundImage1];

        backgroundImage2 = [[UIImageView alloc] initWithFrame:frame];
        [backgroundImage2 setContentMode:UIViewContentModeScaleAspectFill];
        [backgroundImage2 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        [self addSubview:backgroundImage2];
        
//        //Initial shadow
//        UIImageView *shadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow.png"]];
//        shadowImageView.contentMode = UIViewContentModeScaleToFill;
//        shadowImageView.frame = CGRectMake(0, frame.size.height-300, frame.size.width, 300);
//        [self addSubview:shadowImageView];
        
        //Initial ScrollView
        scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        
        //Initial PageView
        pageControl = [[UIPageControl alloc] init];
        pageControl.numberOfPages = pagesArray.count;
        //[pageControl sizeToFit];
        [pageControl setCenter:CGPointMake(frame.size.width/2.0, frame.size.height-20)];
        [self addSubview:pageControl];
        
        //Create pages
        pages = pagesArray;
        
        scrollView.contentSize = CGSizeMake(pages.count * frame.size.width, frame.size.height);
        
        currentPhotoNum = -1;
        
        //insert TextViews into ScrollView
        for(int i = 0; i <  pages.count; i++) {
            IntroView *view = [[IntroView alloc] initWithFrame:frame model:[pages objectAtIndex:i]];
            view.frame = CGRectOffset(view.frame, i*frame.size.width, 0);
            [scrollView addSubview:view];
        }
        
        
        //insert start button into scrollview
        
        if (YES) {
            UIButton *startButton = [UIButton buttonWithType:UIButtonTypeSystem];
            [startButton setTitle:@"立即开始" forState:UIControlStateNormal];
            UIColor *fontSelectColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
            UIColor *fontNoSelectColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.9];
            UIColor *bgColor = [UIColor colorWithRed:190.0 green:20.0 blue:20.0 alpha:0.5];
            [startButton setBackgroundColor:bgColor];
            [startButton setTitleColor:fontNoSelectColor forState:UIControlStateNormal];
            [startButton setTitleColor:fontSelectColor forState:UIControlStateSelected];
            [startButton addTarget:self action:@selector(handleStartButtonClick) forControlEvents:UIControlEventTouchUpInside];
            startButton.frame = CGRectMake((self.frame.size.width-160.0)/2, self.frame.size.height-60, 160.0, 30.0);
            [self addSubview:startButton];
        }
        
            
        //start timer

        timer =  [NSTimer scheduledTimerWithTimeInterval:4.0
                        target:self
                        selector:@selector(tick)
                        userInfo:nil
                        repeats:YES];
        
        [self initShow];
    }
    
    return self;
}

- (void) tick {
    if (currentPhotoNum+1 == pages.count) {
        [timer invalidate];
        timer = nil;
    } else {
        [scrollView setContentOffset:CGPointMake((currentPhotoNum+1)*self.frame.size.width, 0) animated:YES];
    }
}

- (void) initShow {
    int scrollPhotoNumber = MAX(0, MIN((int)(pages.count-1), (int)(scrollView.contentOffset.x / self.frame.size.width)));
    
    if(scrollPhotoNumber != currentPhotoNum) {
        currentPhotoNum = scrollPhotoNumber;
        
        //backgroundImage1.image = currentPhotoNum != 0 ? [(IntroModel*)[pages objectAtIndex:currentPhotoNum-1] image] : nil;
        backgroundImage1.image = [(IntroModel*)[pages objectAtIndex:currentPhotoNum] image];
        backgroundImage2.image = currentPhotoNum+1 != [pages count] ? [(IntroModel*)[pages objectAtIndex:currentPhotoNum+1] image] : nil;
    }
    
    float offset =  scrollView.contentOffset.x - (currentPhotoNum * self.frame.size.width);
    
    
    //left
    if(offset < 0) {
        pageControl.currentPage = 0;
        
        offset = self.frame.size.width - MIN(-offset, self.frame.size.width);
        backgroundImage2.alpha = 0;
        backgroundImage1.alpha = (offset / self.frame.size.width);
    
    //other
    } else if(offset != 0) {
        //last
        if(scrollPhotoNumber == pages.count-1) {
            //pageControl.currentPage = pages.count-1;
            
            backgroundImage1.alpha = 1.0 - (offset / self.frame.size.width);
            if(offset > self.frame.size.width/2) {
                if([self.delegate respondsToSelector:@selector(IntroFinished)]) {
                    [self.delegate IntroFinished];
                }
            }
        } else {
            
            pageControl.currentPage = (offset > self.frame.size.width/2) ? currentPhotoNum+1 : currentPhotoNum;
            
            backgroundImage2.alpha = offset / self.frame.size.width;
            backgroundImage1.alpha = 1.0 - backgroundImage2.alpha;
        }
    //stable
    } else {
        pageControl.currentPage = currentPhotoNum;
        backgroundImage1.alpha = 1;
        backgroundImage2.alpha = 0;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scroll {
    [self initShow];
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scroll {
    if(timer != nil) {
        [timer invalidate];
        timer = nil;
    }
    [self initShow];
}


- (void) handleStartButtonClick {
    //NSLog(@"handlerstartbutton click!");
    if ([self.delegate respondsToSelector:@selector(IntroFinished)]) {
        [self.delegate IntroFinished];
    }
}

@end
