//
//  executeOnMain.swift
//  VirtualTourist
//
//  Created by Haya Mousa on 09/07/2019.
//  Copyright © 2019 HayaMousa. All rights reserved.
//

import Foundation
func executeOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
