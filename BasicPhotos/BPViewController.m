//
//  BPViewController.m
//  BasicPhotos
//
//  Created by James Border on 6/26/13.
//  Copyright (c) 2013 James Border. All rights reserved.
//

#import "BPViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface BPViewController () <UIPopoverControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate> {

    UIPopoverController *popoverCameraRoll;

}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *buttonAdd;

@property BOOL isNewImage;

@end

@implementation BPViewController

#pragma mark -
#pragma mark Get Image

- (IBAction)getImageFrom:(NSInteger)source {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setMediaTypes:@[(NSString *) kUTTypeImage]];
    [imagePicker setAllowsEditing:NO];
    [imagePicker setDelegate:self];
    
    if (source == 0) {

        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {

            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            
            [self presentViewController:imagePicker animated:YES completion:nil];
            
            _isNewImage = YES;

        }

    } else {

        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {

            [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                
                [self presentViewController:imagePicker animated:YES completion:nil];
                
            } else {
                
                popoverCameraRoll = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
                [popoverCameraRoll presentPopoverFromRect:_buttonAdd.frame
                                                   inView:self.view
                                 permittedArrowDirections:0
                                                 animated:NO];
            }
            
            _isNewImage = NO;

        }

    }

}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
	NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
	
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
		
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        [_imageView setImage:image];

        if (_isNewImage) UIImageWriteToSavedPhotosAlbum(image,
													  self,
													  @selector(image:finishedSavingWithError:contextInfo:),
													  nil);
		
	} else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
		// video support here if required
	}
	
}

-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
	
	if (error) {
		
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle: @"Error"
							  message: @"Image was not saved"
							  delegate: nil
							  cancelButtonTitle:@"OK"
							  otherButtonTitles:nil];

        [alert show];
		
	}
	
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [self dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark -
#pragma mark ACTION SHEET

- (IBAction)actionPhoto:(id)sender {

    NSArray *array = @[@"Take New Photo", @"Choose Existing Photo"];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    for (int i = 0; i < [array count]; i++) {
        
        [actionSheet addButtonWithTitle:[array objectAtIndex:i]];
        
    }
    
    [actionSheet addButtonWithTitle:@"Cancel"];
    actionSheet.cancelButtonIndex = array.count;
    
    [actionSheet showInView:self.view];
    
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex < 2) {
        [self getImageFrom:buttonIndex];
    }

}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	NSLog(@"didDismissWithButtonIndex:%i",buttonIndex);
}

-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
	NSLog(@"willDismissWithButtonIndex:%i",buttonIndex);
}

-(void)actionSheetCancel:(UIActionSheet *)actionSheet {
	
}

#pragma mark -
#pragma mark

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
