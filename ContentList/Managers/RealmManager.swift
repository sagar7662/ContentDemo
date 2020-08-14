//
//  RealmManager.swift
//  ContentList
//
//  Created by Sagar Kumar on 13/08/20.
//  Copyright © 2020 Sagar Kumar. All rights reserved.
//

import Foundation
import RealmSwift

struct RealmManager {
    
    static func addContents(_ contents: [Content]) {
        do {
            let realm = try Realm()
            for content in contents {
                let localContents = realm.objects(LocalContent.self).filter("id == '\(content.id ?? "")'")
                if localContents.isEmpty {
                    let localContent = LocalContent()
                    localContent.id = content.id ?? ""
                    localContent.type = content.type ?? ""
                    localContent.data = content.data ?? ""
                    localContent.date = content.date ?? ""
                    try! realm.write {
                        realm.add(localContent)
                    }
                } else {
                    if let updateContet = localContents.first {
                        try! realm.write {
                            updateContet.type = content.type ?? ""
                            updateContet.data = content.data ?? ""
                            updateContet.date = content.date ?? ""
                        }
                    }
                }
            }
            print(realm.objects(LocalContent.self))
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    static func allContents() -> [Content] {
        do {
            let realm = try Realm()
            let localContents = realm.objects(LocalContent.self)
            return Content.contents(localContents: localContents)
        } catch let error {
            print(error.localizedDescription)
        }
        return []
    }
}
