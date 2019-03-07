//
//  Extensions.swift
//  TestTaskSibintek-soft_EreskinVA
//
//  Created by Vladimir Ereskin on 07/03/2019.
//  Copyright © 2019 Vladimir Ereskin. All rights reserved.
//

import Foundation

extension String {
    
    func formatedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: self)
        
        formatter.dateFormat = "dd MMM yyyy"
        
        return formatter.string(from: date!)
    }
    
    func formatedTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: self)
        
        formatter.dateFormat = "HH:mm"
        
        return formatter.string(from: date!)
    }
}
