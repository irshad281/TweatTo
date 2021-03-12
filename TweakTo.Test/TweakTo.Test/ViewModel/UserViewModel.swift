//
//  UserViewModel.swift
//  TweakTo.Test
//
//  Created by Irshad Ahmed on 11/03/21.
//

import Foundation


import UIKit

typealias UserCellConfig         =  TableCellConfigurator<UserTableCell, Users>
typealias NoteCellConfig         =  TableCellConfigurator<NotedTableCell, Users>
typealias InvertedCellConfig     =  TableCellConfigurator<InvertedTableCell, Users>

class UserViewModel {
   var list = [CellConfigurator]()
}
