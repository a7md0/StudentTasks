import UIKit

struct CodableColor: Codable {
    var rgb: Int
    
    var color: UIColor {
        return UIColor(rgb: rgb)
    }
    
    init?(color: UIColor) {
        guard let rgb = color.rgb() else { return nil }
        
        self.rgb = rgb
    }
}

// Source: https://stackoverflow.com/a/28645384/1738413
// Author: Martin R
extension UIColor {
    func rgb() -> Int? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)

            //  (Bits 24-31 are alpha, 16-23 are red, 8-15 are green, 0-7 are blue).
            let rgb = (iAlpha << 24) + (iRed << 16) + (iGreen << 8) + iBlue
            return rgb
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
}

// Source: https://stackoverflow.com/a/28645384/1738413
// Author: Martin R
extension UIColor {
    convenience init(rgb: Int) {
        let iBlue = rgb & 0xFF
        let iGreen =  (rgb >> 8) & 0xFF
        let iRed =  (rgb >> 16) & 0xFF
        let iAlpha =  (rgb >> 24) & 0xFF
        self.init(red: CGFloat(iRed)/255, green: CGFloat(iGreen)/255,
                  blue: CGFloat(iBlue)/255, alpha: CGFloat(iAlpha)/255)
    }
}

