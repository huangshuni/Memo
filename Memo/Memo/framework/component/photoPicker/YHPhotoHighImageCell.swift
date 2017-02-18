//
//  YHPhotoHighImageCell.swift
//  YHDevelopFramework_Swift
//
//  Created by 君若见故 on 16/12/15.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

import UIKit

typealias HighImageCellIncident = (Void) -> Void

class YHPhotoHighImageCell: UICollectionViewCell,UIScrollViewDelegate {
    
    var tapAction: HighImageCellIncident?
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var scrollContentView: UIView!
    
    // MARK: - life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        scrollContentView.backgroundColor = UIColor.black
        let sigleTap = UITapGestureRecognizer.init(target: self, action: #selector(sigleTapHandle(_:)))
        contentView.addGestureRecognizer(sigleTap)
        let doubleTap = UITapGestureRecognizer.init(target: self, action: #selector(doubleTapHandle(_:)))
        doubleTap.numberOfTapsRequired = 2
        contentView.addGestureRecognizer(doubleTap)
        sigleTap.require(toFail: doubleTap)
    }
    // MARK: - incident
    func setImage(_ image: UIImage) -> Void {
        imageView.image = image
        scrollView.setZoomScale(1.0, animated: false)
    }
    func sigleTapHandle(_ tap: UITapGestureRecognizer) -> Void {
        tapAction?()
    }
    func doubleTapHandle(_ tap: UITapGestureRecognizer) -> Void {
        
        let point = tap.location(in: imageView)
        if scrollView.zoomScale == 1.0 {
            //zoom big
            scrollView.zoom(to: CGRect.init(x: point.x - 50, y: point.y - 50, width: 100, height: 100), animated: true)
        } else {
            //recover
            scrollView.setZoomScale(1.0, animated: true)
        }
    }
    
    // MARK: - UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

}
