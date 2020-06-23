//
//  NewsTableViewCell.swift
//  RssParser
//
//  Created by Константин Киски on 18.06.2020.
//  Copyright © 2020 Константин Киски. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    // MARK: - Structure
    
    struct NewsCellData {
        var title: String
        var pubDate: String
    }
    
    // MARK: - UI Elements
    
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var pubDate: UILabel!
    
    // MARK: - Set data
    
    func setData(data: NewsCellData) {
        title.text = data.title
        pubDate.text = data.pubDate
    }
}
