//
//  EFQRCodeRecognizer.swift
//  Pods
//
//  Created by EyreFree on 2017/3/28.
//
//

import Foundation

class EFQRCodeRecognizer {

    public var image: UIImage? {
        didSet {
            contentArray = nil
        }
    }
    var contents: [String]? {
        get {
            if let tryImage = image, nil == contentArray {
                contentArray = getQRString(From: tryImage)
            }
            return contentArray
        }
    }

    private var contentArray: [String]?

    init(image: UIImage) {
        self.image = image
    }

    // Get QRCodes from image
    private func getQRString(From image: UIImage) -> [String]? {
        // 原图
        let result = scanFrom(image: image, options: [CIDetectorAccuracy : CIDetectorAccuracyHigh])
        // 灰度图
        if (result?.count ?? 0) <= 0 {
            return scanFrom(
                image: image.greyScale(), options: [CIDetectorAccuracy : CIDetectorAccuracyLow]
            )
        }
        return result
    }

    private func scanFrom(image: UIImage?, options: [String : Any]? = nil) -> [String]? {
        if let tryCGImage = image?.cgImage {
            var result = [String]()
            let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: options)
            if let features = detector?.features(in: CIImage(cgImage: tryCGImage)) {
                for feature in features {
                    if let tryString = (feature as? CIQRCodeFeature)?.messageString {
                        result.append(tryString)
                    }
                }
            }
            return result
        }
        return nil
    }
}
