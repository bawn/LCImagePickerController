//
//  LCImageGroupViewController.m
//  LCPickerControllerDemo
//
//  Created by bawn on 11/4/15.
//  Copyright © 2015 bawn. All rights reserved.
//

#import "LCImageGroupViewController.h"
#import "LCImagePickerController.h"
#import "LCImageGroupTableViewCell.h"
#import "LCImgaeCollectionViewController.h"
#import "LCImagePickerDefines.h"
#import "LCImagePickerViewController+Internal.h"
#import "NSBundle+LCImagePickerController.h"

static NSString *const kImageGroupCellIdentifier = @"imageGroupCell";

@interface LCImageGroupViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) LCImagePickerController *imagePicker;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *assetsGroups;
@property (nonatomic, strong) ALAssetsGroup *defaultGroup;


@end

@implementation LCImageGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self setupGroups];
    [self setupButtons];

}

- (void)setupViews{
    self.tableView.rowHeight = LCImageGroupCellHeight;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupButtons{
    
    if (self.imagePicker.delegate && [self.imagePicker.delegate respondsToSelector:@selector(cancleButtonForImagePicker:)]) {
        UIButton *cancleButton = [self.imagePicker.delegate cancleButtonForImagePicker:self.imagePicker];
        [cancleButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancleButton];
        [cancleButton addTarget:self.imagePicker action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        if (self.imagePicker.showsCancelButton){
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self.imagePicker action:@selector(dismiss:)];
        }
    }
    
    if (self.imagePicker.delegate && [self.imagePicker.delegate respondsToSelector:@selector(doneButtonForImagePicker:)]) {
        UIButton *doneButton = [self.imagePicker.delegate doneButtonForImagePicker:self.imagePicker];
        [doneButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
        [doneButton addTarget:self.imagePicker action:@selector(finishPickingAssets:) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self.imagePicker action:@selector(finishPickingAssets:)];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
}

- (void)setupGroups{
    if (!_assetsGroups) {
        self.assetsGroups = [NSMutableArray array];
    }
    else{
        [self.assetsGroups removeAllObjects];
    }
    
    // 列出所有相册
    __block NSInteger numberOfGroup = 0;
    NSUInteger type =  ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces | ALAssetsGroupSavedPhotos;
    [self.imagePicker.assetsLibrary enumerateGroupsWithTypes:type usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            numberOfGroup ++;
        }
    } failureBlock:^(NSError *error) {
        // 失败处理
    }];
    
    ALAssetsLibraryGroupsEnumerationResultsBlock resultsBlock = ^(ALAssetsGroup *group, BOOL *stop){
        if (group) {
            [self.assetsGroups addObject:group];
            if (--numberOfGroup == 0) {
                [self.tableView reloadData];
                [self.assetsGroups enumerateObjectsUsingBlock:^(ALAssetsGroup * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([[obj valueForProperty:ALAssetsGroupPropertyType] integerValue] == self.imagePicker.defaultGroupType) {
                        [self pushDefaultAssetsGroup:obj];
                    }
                }];
            }
        }
    };

    // Camera roll排在第一个
    [self.imagePicker.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                             usingBlock:resultsBlock
                                           failureBlock:NULL];
    
    type = ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces;
    
    [self.imagePicker.assetsLibrary enumerateGroupsWithTypes:type
                                             usingBlock:resultsBlock
                                           failureBlock:NULL];
    
}

#pragma mark - Default Assets Group

- (void)pushDefaultAssetsGroup:(ALAssetsGroup *)group{
    if (group){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LCImagePicker" bundle:[NSBundle lcAssetsPickerControllerBundle]];
        LCImgaeCollectionViewController *vc = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([LCImgaeCollectionViewController class])];
        vc.assetsGroup = group;
        self.navigationController.viewControllers = @[self, vc];
    }
}


#pragma mark - Accessors

- (LCImagePickerController *)imagePicker{
    
    return (LCImagePickerController *)self.navigationController.parentViewController;
}


#pragma mark - UITableView Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _assetsGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LCImageGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kImageGroupCellIdentifier forIndexPath:indexPath];
    [cell configWithItem:_assetsGroups[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LCImagePicker" bundle:[NSBundle lcAssetsPickerControllerBundle]];
    LCImgaeCollectionViewController *vc = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([LCImgaeCollectionViewController class])];
    vc.assetsGroup = _assetsGroups[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
