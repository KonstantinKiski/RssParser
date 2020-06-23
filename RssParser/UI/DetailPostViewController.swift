//
//  DetailPostViewController.swift
//  RssParser
//
//  Created by Константин Киски on 23.06.2020.
//  Copyright © 2020 Константин Киски. All rights reserved.
//

import Foundation
import UIKit

class DetailPostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Enums
    
    /// Идентификаторы ячеек экрана с детальным описанием поста
    ///
    /// - imageCell: ячейка с изображением
    /// - titleCell: ячейка с заголовком
    /// - descriptionCell: ячейка с описанием
    enum DetailPostCells: String {
        case imageCell = "imageCell"
        case titleCell = "titleCell"
        case descriptionCell = "descriptionCell"
    }
    
    // MARK: - UI Elements

    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Variables
    
    public var currentPost: Post!
    private var tableData = [TableData]()

    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
    }
    
    // MARK: - Set table view
    
    /// Обновление TableData
    private func update() {
        let tableDataBuilder : TableDataBuilder = TableDataBuilder()
        tableData.removeAll()
                
        tableDataBuilder.addSection(sectionName: "")
        if currentPost.enclosure != "" {
            tableDataBuilder.addRows(rowsIndentifire: [DetailPostCells.imageCell.rawValue])
        }
        tableDataBuilder.addRows(rowsIndentifire: [DetailPostCells.titleCell.rawValue, DetailPostCells.descriptionCell.rawValue])
        
        tableData = tableDataBuilder.generateTableData()
    }
    
    private func setData(to cell: UITableViewCell, by indexPath: IndexPath) -> UITableViewCell? {
        let cellType = DetailPostCells(rawValue: cell.reuseIdentifier ?? "")
        switch cellType {
        case .imageCell?:
            let imageCell = cell as? DefaultTableViewCell

            if let url = URL(string: currentPost.enclosure) {
                let data = try? Data(contentsOf: url)

                if let imageData = data {
                    let image = UIImage(data: imageData)
                    imageCell?.imageCell?.image = image
                }

            }
            
            return imageCell
        case .titleCell?:
            let titleCell = cell as? DefaultTableViewCell
            titleCell?.titleCell?.text = currentPost.title
            return titleCell
        case .descriptionCell?:
            let descriptionCell = cell as? DefaultTableViewCell
            descriptionCell?.titleCell?.text = currentPost.fullDescription
            return descriptionCell
        default:
            return cell
        }
    }
    
    private func getIdentifireCellByIndexPath(path: IndexPath) -> String? {
        return tableData.filter({ $0.rowsData!.count > 0 || ($0.rowsIndentifier?.count)! > 0})[path.section].rowsIndentifier?[path.row]
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: (getIdentifireCellByIndexPath(path: indexPath))!, for: indexPath)
        return setData(to: cell, by: indexPath) ?? cell
    }
}
