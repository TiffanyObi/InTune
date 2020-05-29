//
//  Designable.swift
//  InTune
//
//  Created by Maitree Bain on 5/29/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit

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
