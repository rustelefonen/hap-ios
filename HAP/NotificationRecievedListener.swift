//
//  NotificationRecievedListener.swift
//  HAP
//
//  Created by Simen Fonnes on 10.02.2016.
//  Copyright © 2016 Rustelefonen. All rights reserved.
//

import Foundation

@objc
protocol NotificationRecievedListener {
    
    func onRecieveNotification()
    func syncTabBadgeWithApplicationIconBadge()
}