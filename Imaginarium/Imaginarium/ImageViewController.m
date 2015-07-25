//
//  ImageViewController.m
//  Imaginarium
//
//  Created by Gang Wu on 7/23/15.
//  Copyright (c) 2015 Gang Wu. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation ImageViewController

-(void)setScrollView:(UIScrollView *)scrollView{
    _scrollView = scrollView;
    _scrollView.minimumZoomScale = 0.2;
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.delegate = self;
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
}


// whici view to zoom
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

-(void)setImageURL:(NSURL *)imageURL{
    _imageURL = imageURL;
    
    
    // will block main queue
    // self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.imageURL]];
    
    [self startDownloadingImage];
}

-(void)startDownloadingImage{
    self.image = nil;
    if(self.imageURL){
        [self.indicator startAnimating];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:self.imageURL];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
                                                        completionHandler:^(NSURL *localfile, NSURLResponse *response, NSError *error) {
                                                            if(!error){
                                                                if([request.URL isEqual:self.imageURL]){
                                                                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localfile]];
                                                                    
                                                                    // UI operation should be on main queue **********
                                                                    dispatch_async(dispatch_get_main_queue(), ^{self.image = image;});
                                                                    //[self performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
                                                                    
                                                                }
                                                            }
                                                        }];
        [task resume];
    }
}

-(UIImageView *)imageView {
    if(!_imageView) _imageView = [[UIImageView alloc] init];
    return _imageView;
}

// no need to synthesize this instance
//@synthesize image = _image;

-(UIImage *)image {
    return self.imageView.image;
}

-(void)setImage:(UIImage *)image{
    self.imageView.image = image;
    [self.imageView sizeToFit];
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;       //MUST
    [self.indicator stopAnimating];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
}

@end
