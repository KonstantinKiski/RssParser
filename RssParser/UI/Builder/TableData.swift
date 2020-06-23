//
//  TableData.swift
//  RssParser
//
//  Created by Константин Киски on 23.06.2020.
//  Copyright © 2020 Константин Киски. All rights reserved.
//

import Foundation
import UIKit

struct TableData {
    
    var sectionHeader : String?
    var rowsIndentifier : [String]? = []
    var indentifier : String?
    var rowsData : [Any]? = []
    
    init(){}
    
    init(sectionHeader : String?) {
        self.sectionHeader = sectionHeader
    }
    
}

class TableDataBuilder: NSObject {
    
    private var tableDataArray : [TableData]! = []
    private var tableData : TableData? = nil
    
    override init() {
    }
    
    func addSection(){
        if (tableData != nil) {
            tableDataArray.append(tableData!)
        }
        tableData = TableData()
    }
    
    func addSection(sectionName : String){
        if(tableData != nil){
            tableDataArray.append(tableData!)
        }
        tableData = TableData(sectionHeader: sectionName)
    }
    
    func addRows(rowsIndentifire : [String]) {
        tableData?.rowsIndentifier?.append(contentsOf: rowsIndentifire)
    }
    
    func addRow(rowIndentifier : String) {
        tableData?.rowsIndentifier?.append(rowIndentifier)
    }
    
    func addRows(indentifier : String? = nil, count : Int = 0){
        guard indentifier != nil else {
            return
        }
        guard count != 0 else {
            tableData?.rowsIndentifier?.append(indentifier!)
            return
        }
        for _ in 1...count {
            tableData?.rowsIndentifier?.append(indentifier!)
        }
    }
    
    func addRows(rowsData : [Any], indentifier : String? = nil) {
        if indentifier != nil {
            self.tableData?.indentifier = indentifier
        }
        tableData?.rowsData?.append(contentsOf: rowsData)
    }
    
    func addRow(rowData : Any, multyIndentifier : String? = nil) {
        guard multyIndentifier != nil else {
            return
        }
        tableData?.rowsIndentifier?.append(multyIndentifier!)
        tableData?.rowsData?.append(rowData)
    }
    
    func addRow(rowData : Any, indentifier : String? = nil) {
         if indentifier != nil {
            self.tableData?.indentifier = indentifier
        }
        tableData?.rowsData?.append(rowData)
    }
    
    func setIndentifier(indentifier : String) {
        tableData?.indentifier = indentifier
    }
    
    func generateTableData() -> [TableData] {
        if(tableData != nil){
            tableDataArray.append(tableData!)
        }
        return tableDataArray
    }
}
