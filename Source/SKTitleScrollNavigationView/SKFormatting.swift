//
//  SKFormatting.swift
//  Example
//
//  Created by ShevaKuilin on 2019/4/2.
//  Copyright © 2019 ShevaKuilin. All rights reserved.
//

import UIKit

/** Format UIFont size
 *
 *  @param  x        Size value
 *  @param  bold     Bold face
 *
 *  @return UIFont   An UIFont instance
 *
 */
public func kFont(_ x: CGFloat,
                   _ bold: Bool = false) -> UIFont {
    return bold ? UIFont.boldSystemFont(ofSize: x):UIFont.systemFont(ofSize: x)
}

/** Format CGRect
 *
 *  @param x        x coordinate
 *  @param y        y coordinate
 *  @param width    The width
 *  @param height   The height
 *
 */
public func kFrame(_ x: CGFloat,
                    _ y: CGFloat,
                    _ width: CGFloat,
                    _ height: CGFloat) -> CGRect {
    return CGRect(x: x, y: y, width: width, height: height)
}


/** Format UIColor RGB value
 *
 *  @param  r        Rea color RGB value molecule
 *  @param  g        Green color RGB value molecule
 *  @param  blue     Blue color RGB value molecule
 *  @param  a        Alpha value. Default 1.0
 *
 *  @return UIColor  An UIColor instance
 *
 */
public func kColor(_ r: CGFloat,
                    _ g: CGFloat,
                    _ b: CGFloat,
                    _ a: CGFloat = 1.0) -> UIColor {
    let denominatorRGB: CGFloat = 255.0
    return UIColor(red: r/denominatorRGB, green: g/denominatorRGB, blue: b/denominatorRGB, alpha: a)
}

/** Format print
 *
 *  @param  message             The text message you want to output
 *  @param  file                The file name. Automatic reading
 *  @param  method              The method name. Automatic reading
 *  @param  line                This print message appears in the first few lines of this file. Automatic reading
 *
 */
public func printLog<T>(_ message: T,
                         file: String = #file,
                         method: String = #function,
                         line: Int = #line) {
    #if DEBUG
    print("File => [\((file as NSString).lastPathComponent) \(method):] - [Line \(line)], Message => 「 \(message) 」")
    #endif
}
