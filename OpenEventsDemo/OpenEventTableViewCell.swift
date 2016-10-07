//
//  OpenEventTableViewCell.swift
//  OpenEventsDemo
//
//  Created by Jon on 10/6/16.
//  Copyright © 2016 jm. All rights reserved.
//

import UIKit
import SDWebImage

class OpenEventTableViewCell: UITableViewCell {
    static let reuseIdentifier = "OpenEventTableViewCell"
    @IBOutlet var photo: UIImageView!
    @IBOutlet var eventName: UILabel!
    @IBOutlet var hostName: UILabel!
    @IBOutlet var locationInfo: UILabel!
    @IBOutlet var urlLink: UITextView!
    var openEvent : OpenEvent? {
        didSet {
            eventName.text = openEvent!.eventName
            hostName.text = "Hosted by \(openEvent!.groupName)"
            locationInfo.text = "\(openEvent!.distance) miles away - \(openEvent!.venueAddress.address) \(openEvent!.venueAddress.city) \(openEvent!.venueAddress.state)"

            let attributedString = NSMutableAttributedString(string: openEvent!.eventURL)
            attributedString.addAttribute(NSLinkAttributeName, value:openEvent!.eventURL, range: NSMakeRange(0, (openEvent!.eventURL as NSString).length))
            urlLink.attributedText = attributedString
            
            urlLink.text = openEvent!.eventURL
            
            // Expected images...
            //photo.sd_setImage(with: NSURL(string: openEvent!.photoURL) as URL!)
        }
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL, options: [:])
        return false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        urlLink.textContainerInset = .zero
        urlLink.textContainer.lineFragmentPadding = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
