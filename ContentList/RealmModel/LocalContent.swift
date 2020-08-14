//
//  LocalContent.swift
//  ContentList
//
//  Created by Sagar Kumar on 13/08/20.
//  Copyright © 2020 Sagar Kumar. All rights reserved.
//

import Foundation
import RealmSwift

class LocalContent: Object {
    
    @objc dynamic var id = ""
    @objc dynamic var type = ""
    @objc dynamic var date = ""
    @objc dynamic var data = ""
}
