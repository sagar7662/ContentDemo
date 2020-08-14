//
//  Content.swift
//  ContentList
//
//  Created by Sagar Kumar on 12/08/20.
//  Copyright © 2020 Sagar Kumar. All rights reserved.
//

import Foundation
import RealmSwift

struct Content: Codable {
    
    var id: String?
    var type: String?
    var date: String?
    var data: String?
    
    init() {
        
    }
    
    static func contents(localContents: Results<LocalContent>) -> [Content] {
        var contents = [Content]()
        for localContent in localContents {
            var content = Content()
            content.id = localContent.id
            content.type = localContent.type
            content.date = localContent.date
            content.data = localContent.data
            contents.append(content)
        }
        
        return contents
    }
}
