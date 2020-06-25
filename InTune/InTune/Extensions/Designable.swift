//
//  Designable.swift
//  InTune
//
//  Created by Maitree Bain on 5/29/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit
import AVFoundation

@IBDesignable

class DesignableView: UIView {
  @IBInspectable var cornerRadius: CGFloat = 0
  @IBInspectable var borderWidth: CGFloat = 0
  @IBInspectable var borderColor: CGColor = UIColor.black.cgColor
  
  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = cornerRadius
    layer.borderWidth = borderWidth
    layer.borderColor = borderColor
  }
}

class DesignableButton: UIButton {
  @IBInspectable var cornerRadius: CGFloat = 0
  @IBInspectable var borderWidth: CGFloat = 0
  @IBInspectable var borderColor: CGColor = UIColor.black.cgColor
  
  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = cornerRadius
    layer.borderWidth = borderWidth
    layer.borderColor = borderColor
  }
}

class DesignableTextField: UITextField {
  @IBInspectable var cornerRadius: CGFloat = 0
  @IBInspectable var borderWidth: CGFloat = 0
  @IBInspectable var borderColor: CGColor = UIColor.black.cgColor
  
  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = cornerRadius
    layer.borderWidth = borderWidth
    layer.borderColor = borderColor
  }
}

class DesignableImageView: UIImageView {
  @IBInspectable var cornerRadius: CGFloat = 0
  @IBInspectable var borderWidth: CGFloat = 0
  @IBInspectable var borderColor: CGColor = UIColor.black.cgColor
  
  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = cornerRadius
    layer.borderWidth = borderWidth
    layer.borderColor = borderColor
  }
}

class DesignableLabel: UILabel {
    @IBInspectable var cornerRadius: CGFloat = 0
   @IBInspectable var borderWidth: CGFloat = 0
   @IBInspectable var borderColor: CGColor = UIColor.black.cgColor
   
   override func layoutSubviews() {
     super.layoutSubviews()
     layer.cornerRadius = cornerRadius
     layer.borderWidth = borderWidth
     layer.borderColor = borderColor
   }}

extension UIImage {
  static func resizeImage(originalImage: UIImage, rect: CGRect) -> UIImage {
    let rect = AVMakeRect(aspectRatio: originalImage.size, insideRect: rect)
    let size = CGSize(width: rect.width, height: rect.height)
    let renderer = UIGraphicsImageRenderer(size: size)
    return renderer.image { (context) in
      originalImage.draw(in: CGRect(origin: .zero, size: size))
    }
  }
}

extension UITableViewCell {
func addShadow() {
    let radius: CGFloat = 10
    contentView.layer.cornerRadius = radius
    contentView.layer.borderWidth = 1
    contentView.layer.borderColor = UIColor.clear.cgColor
    contentView.layer.masksToBounds = true

//    layer.shadowColor = UIColor.black.cgColor
    layer.shadowColor = #colorLiteral(red: 0.3429883122, green: 0.02074946091, blue: 0.7374325991, alpha: 1)
    layer.shadowOffset = CGSize(width: 1.0, height: 4.0)
    layer.shadowRadius = 4.0
    layer.shadowOpacity = 0.8
    layer.masksToBounds = false
    layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
    layer.cornerRadius = radius
}
}

extension UICollectionViewCell {
    func shadow() {
    let radius: CGFloat = 10
    contentView.layer.cornerRadius = radius
    contentView.layer.borderWidth = 1
    contentView.layer.borderColor = UIColor.clear.cgColor
    contentView.layer.masksToBounds = true

    layer.shadowColor = #colorLiteral(red: 0.3867273331, green: 0.8825651407, blue: 0.8684034944, alpha: 1)
    layer.shadowOffset = CGSize(width: 1.0, height: 4.0)
    layer.shadowRadius = 4.0
    layer.shadowOpacity = 0.8
    layer.masksToBounds = false
    layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
    layer.cornerRadius = radius
}
}
