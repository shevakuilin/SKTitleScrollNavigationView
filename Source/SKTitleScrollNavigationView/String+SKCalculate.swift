//
//  String+SKCalculate.swift
//  Example
//
//  Created by ShevaKuilin on 2019/4/2.
//  Copyright © 2019 ShevaKuilin. All rights reserved.
//

import UIKit

extension String {
    public func width(fontSize: CGFloat) -> CGFloat {
        let attribute = [NSAttributedStringKey.font: kFont(fontSize)]
        let convertStr = self as NSString
        let size = convertStr.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 30), options: [.truncatesLastVisibleLine, .usesLineFragmentOrigin, .usesFontLeading], attributes: attribute, context: nil).size
        return size.width
    }
}
