//
//  PhotosViewController.swift
//  CustomGallery
//
//  Created by Pavle Pesic on 7/14/18.
//  Copyright © 2018 Pavle Pesic. All rights reserved.
//

import UIKit
import Photos

class PhotosViewController: UIViewController {

    // MARK: - Vars & Lets
    
    var selectedCollection: PHAssetCollection?
    private var photos: PHFetchResult<PHAsset>!
    private var numbeOfItemsInRow = 4
    
    // MARK: - Outelts
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var previewImageView: UIImageView!
    
    // MARK: - Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareCollectionView()
        self.fetchImagesFromGallery(collection: self.selectedCollection)
    }
    
    // MARK: - Private methods
    
    private func prepareCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UINib.init(nibName: "PhoteoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhoteoCollectionViewCell")
    }
    
    private func fetchImagesFromGallery(collection: PHAssetCollection?) {
        DispatchQueue.main.async {
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            if let collection = collection {
                self.photos = PHAsset.fetchAssets(in: collection, options: fetchOptions)
            } else {
                self.photos = PHAsset.fetchAssets(with: fetchOptions)
            }
            self.collectionView.reloadData()
        }
    }

}

// MARK: - Exteinsions
// MARK: - UICollectionViewDataSource

extension PhotosViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let photos = photos {
            return photos.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhoteoCollectionViewCell", for: indexPath) as? PhoteoCollectionViewCell
        cell?.setImage(photos.object(at: indexPath.row))
        
        return cell!
    }
}

extension PhotosViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard previewImageView != nil else {
            return;
        }
        
        let photo: PHAsset = photos.object(at: indexPath.row)
        photo.getOrginalImage { (image) in
            self.previewImageView.image = image
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(1,1,1,1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (Int(UIScreen.main.bounds.size.width) / numbeOfItemsInRow) - 2
        return CGSize(width: width, height: width)
    }

}
