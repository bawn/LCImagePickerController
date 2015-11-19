//
//  LCImgaeCollectionViewController.m
//  LCPickerControllerDemo
//
//  Created by bawn on 11/4/15.
//  Copyright © 2015 bawn. All rights reserved.
//

#import "LCImgaeCollectionViewController.h"
#import "LCImagePickerController.h"
#import "LCImageCollectionViewCell.h"
#import "LCImagePickerViewController+Internal.h"
#import "LCImageCollectionBackgroundView.h"
#import "Masonry.h"

static NSString *const kImageCollectionCellIdentifier = @"imageCollectionCell";

@interface LCImgaeCollectionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) LCImagePickerController *imagePicker;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, assign) BOOL didLayoutSubviews;
@property (nonatomic, assign) BOOL didImagePickerShow;
@property (nonatomic, strong) NSMutableArray *assets;



@end

@implementation LCImgaeCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self setupAssets];
    [self addNotificationObserver];
}

// 滚动到底部
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (!self.didLayoutSubviews && self.assets.count > 0){
        [self scrollToBottomIfNeeded];
        self.didLayoutSubviews = YES;
    }
}

- (void)setupButtons{
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
    if (self.imagePicker.delegate && [self.imagePicker.delegate respondsToSelector:@selector(backButtonForImagePicker:)]) {
        UIButton *backButton = [self.imagePicker.delegate backButtonForImagePicker:self.imagePicker];
        [backButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}


- (void)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [self removeNotificationObserver];

}


- (void)initUI{
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.collectionView.allowsMultipleSelection = self.imagePicker.allowsMultipleSelection;
    self.flowLayout.minimumInteritemSpacing = 0;
    self.flowLayout.minimumLineSpacing = 1;
    CGFloat size = ([UIScreen mainScreen].bounds.size.width - 3.0f)/4;
    self.flowLayout.itemSize = CGSizeMake(size, size);
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView.backgroundColor = [LCImageCollectionBackgroundView appearance].collectionBackgroundColor;
    [self setupButtons];
}
     

- (void)setupAssets{
    self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    if (!_assets){
        self.assets = [[NSMutableArray alloc] init];
    }
    else{
        return;
    }
    
    [self.assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            [self.assets addObject:result];
        }
    }];
    if (self.imagePicker.defaultGroupType && !self.didImagePickerShow) {
        if (self.imagePicker.delegate && [self.imagePicker.delegate respondsToSelector:@selector(imagePickerDidShow:)]) {
            [self.imagePicker.delegate imagePickerDidShow:self.imagePicker];
        }
        self.didImagePickerShow = YES;
    }
}


#pragma mark - Scroll to bottom

- (void)scrollToBottomIfNeeded{
    BOOL shouldScrollToBottom;
    
    if ([self.imagePicker.delegate respondsToSelector:@selector(imagePickerController:shouldScrollToBottomForAssetCollection:)]){
        shouldScrollToBottom = [self.imagePicker.delegate imagePickerController:self.imagePicker shouldScrollToBottomForAssetCollection:self.collectionView];
    }
    else{
        shouldScrollToBottom = YES;
    }
    
    if (shouldScrollToBottom){
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.assets.count - 1 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    }
}


#pragma mark - Notifications

- (void)addNotificationObserver{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self
               selector:@selector(assetsLibraryChanged:)
                   name:ALAssetsLibraryChangedNotification
                 object:nil];
    
    [center addObserver:self
               selector:@selector(selectedAssetsChanged:)
                   name:LCImagePickerSelectedAssetsDidChangeNotification
                 object:nil];
    
    [center addObserver:self
               selector:@selector(assetsPickerDidSelectAsset:)
                   name:LCImagePickerDidSelectAssetNotification
                 object:nil];
    
    [center addObserver:self
               selector:@selector(assetsPickerDidDeselectAsset:)
                   name:LCImagePickerDidDeselectAssetNotification
                 object:nil];
    
}

- (void)removeNotificationObserver{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:ALAssetsLibraryChangedNotification object:nil];
    [center removeObserver:self name:LCImagePickerSelectedAssetsDidChangeNotification object:nil];
    [center removeObserver:self name:LCImagePickerDidSelectAssetNotification object:nil];
    [center removeObserver:self name:LCImagePickerDidDeselectAssetNotification object:nil];
}


#pragma mark - Assets Library Changed

- (void)assetsLibraryChanged:(NSNotification *)notification{
    // 重置所有的专辑
    if (notification.userInfo == nil)
        [self performSelectorOnMainThread:@selector(reloadAssets) withObject:nil waitUntilDone:NO];
    
    // 重置受影响的专辑
    if (notification.userInfo.count > 0)
        [self reloadAssetsGroupForUserInfo:notification.userInfo];
}


#pragma mark - Reload Assets Group

- (void)reloadAssetsGroupForUserInfo:(NSDictionary *)userInfo{
    NSSet *URLs = [userInfo objectForKey:ALAssetLibraryUpdatedAssetGroupsKey];
    NSURL *URL  = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyURL];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF == %@", URL];
    NSArray *matchedGroups = [URLs.allObjects filteredArrayUsingPredicate:predicate];
    
    if (matchedGroups.count > 0)
        [self performSelectorOnMainThread:@selector(reloadAssets) withObject:nil waitUntilDone:NO];
}


#pragma mark - Selected Assets Changed

- (void)selectedAssetsChanged:(NSNotification *)notification{
//    NSArray *selectedAssets = (NSArray *)notification.object;
    
//    [[self.toolbarItems objectAtIndex:1] setTitle:[self.picker toolbarTitle]];
//    
//    [self.navigationController setToolbarHidden:(selectedAssets.count == 0) animated:YES];
    
    // Reload assets for calling de/selectAsset method programmatically
//    [self.collectionView reloadData];
}

- (void)assetsPickerDidSelectAsset:(NSNotification *)notification{
    ALAsset *asset = (ALAsset *)notification.object;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self.assets indexOfObject:asset] inSection:0];
    [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    if (self.imagePicker.allowsMultipleSelection) {
        [self updateSelectionOrderLabels];
    }
    else{
        if (self.imagePicker.delegate && [self.imagePicker.delegate respondsToSelector:@selector(viewControllerForImagePickerSelected:selectAsset:)]){
            UIViewController *vc = [self.imagePicker.delegate viewControllerForImagePickerSelected:self.imagePicker selectAsset:asset];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            [self.imagePicker finishPickingAssets:nil];

        }
    }
}

- (void)assetsPickerDidDeselectAsset:(NSNotification *)notification{
    ALAsset *asset = (ALAsset *)notification.object;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self.assets indexOfObject:asset] inSection:0];
    [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    [self updateSelectionOrderLabels];
}


#pragma mark - Reload Assets

- (void)reloadAssets{
    [self.assets removeAllObjects];
    self.assets = nil;
    [self setupAssets];
    [self.collectionView reloadData];
}


#pragma mark - Update Selection Order Labels

- (void)updateSelectionOrderLabels{
    for (NSIndexPath *indexPath in [self.collectionView indexPathsForSelectedItems]){
        ALAsset *asset = [self assetAtIndexPath:indexPath];
        LCImageCollectionViewCell *cell = (LCImageCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        cell.selectionIndex = [self.imagePicker.selectedAssets indexOfObject:asset];
    }
}


#pragma mark - Accessors

- (LCImagePickerController *)imagePicker{
    return (LCImagePickerController *)self.navigationController.parentViewController;
}

- (ALAsset *)assetAtIndexPath:(NSIndexPath *)indexPath{
    return (self.assets.count > 0) ? self.assets[indexPath.item] : nil;
}


#pragma mark - UICollectionView Method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LCImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kImageCollectionCellIdentifier forIndexPath:indexPath];
    cell.showsSelectionIndex = self.imagePicker.allowsMultipleSelection;
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
    if ([self.imagePicker.selectedAssets containsObject:asset]){
        cell.selected = YES;
        cell.selectionIndex = [self.imagePicker.selectedAssets indexOfObject:asset];
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    
    [cell configWithItem:_assets[indexPath.row]];
    return cell;
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
    if ([self.imagePicker.delegate respondsToSelector:@selector(imagePickerController:shouldSelectAsset:)]){
        return [self.imagePicker.delegate imagePickerController:self.imagePicker shouldSelectAsset:asset];
    }
    else{
        return YES;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
    [self.imagePicker selectAsset:asset];
    if ([self.imagePicker.delegate respondsToSelector:@selector(imagePickerController:didSelectAsset:)]){
        [self.imagePicker.delegate imagePickerController:self.imagePicker didSelectAsset:asset];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
    [self.imagePicker deselectAsset:asset];
    
    if ([self.imagePicker.delegate respondsToSelector:@selector(imagePickerController:didDeselectAsset:)]){
        [self.imagePicker.delegate imagePickerController:self.imagePicker didDeselectAsset:asset];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
    
    if ([self.imagePicker.delegate respondsToSelector:@selector(imagePickerController:shouldHighlightAsset:)]){
        return [self.imagePicker.delegate imagePickerController:self.imagePicker shouldHighlightAsset:asset];
    }
    else{
        return YES;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
    
    if ([self.imagePicker.delegate respondsToSelector:@selector(imagePickerController:didHighlightAsset:)]){
        [self.imagePicker.delegate imagePickerController:self.imagePicker didHighlightAsset:asset];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
    
    if ([self.imagePicker.delegate respondsToSelector:@selector(imagePickerController:didUnhighlightAsset:)]){
        [self.imagePicker.delegate imagePickerController:self.imagePicker didUnhighlightAsset:asset];
    }
}

@end
