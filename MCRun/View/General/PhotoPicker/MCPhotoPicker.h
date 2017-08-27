//
//  MCPhotoPicker.h
//  MCRun
//
//  Created by moshuqi on 15/10/30.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol MCPhotoPickerDelegate <NSObject>

- (void)imagePickerController:(UIImagePickerController *)picker didSelectImage:(UIImage *)image;

@end

@interface MCPhotoPicker : NSObject

@property (nonatomic, weak) id<MCPhotoPickerDelegate> delegate;

- (id)initWithViewController:(UIViewController *)viewController;
- (void)showPickerChoice;

@end
