//
//  Notifiers.swift
//  Rebellion
//
//  Created by Djibril Bathily Coly on 07/06/2022.
//

import UIKit
import NotificationBannerSwift

var banner : GrowingNotificationBanner?

struct Notifiers {

    static func fireNotification(title:String, body:String, style:BannerStyle) {
        banner?.dismiss()
        banner = GrowingNotificationBanner(title: title, subtitle: body, style: style)
        banner?.show()
    }

    
}
