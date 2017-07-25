//
//  EDropdownList.swift
//  EDropdownList
//
//  Created by Lucy Nguyen on 11/10/15.
//  Copyright © 2015 econ. All rights reserved.
//
//  This class is used for creating custom dropdown list in iOS.

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


@objc protocol EdropdownListDelegate {
    func didSelectItem(_ selectedItem: String, index: Int)
}

class EDropdownList: UIView {
    var dropdownButton: UIButton!
    var listTable: UITableView!
    var arrowImage: UIImageView!
    var valueList: [String]!
    var delegate: EdropdownListDelegate!
    var isShown: Bool! = false
    var selectedValue: String!
    
    var maxHeight: CGFloat = 200.0
    var cellSelectedColor = UIColor(hex: "#6F511F")
    var textColor = UIColor.black
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
        setupArrowImage()
        setupListTable()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupButton()
        setupArrowImage()
        setupListTable()
    }
    
    // MARK: - Create interface.
    
    func setupButton() {
        dropdownButton = UIButton(type: UIButtonType.custom)
       // dropdownButton.backgroundColor = UIColor(red: 102.0 / 255.0, green: 102.0 / 255.0, blue: 255.0 / 255.0, alpha: 1)
        dropdownButton.backgroundColor = UIColor.clear
        dropdownButton.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
       // dropdownButton.setTitle("Select", for: UIControlState())
        dropdownButton.setTitle("0", for: UIControlState())
        dropdownButton.titleLabel?.textColor = UIColor.black
        dropdownButton.titleLabel?.tintColor = UIColor.black
        dropdownButton.addTarget(self, action: #selector(EDropdownList.showHideDropdownList(_:)), for: UIControlEvents.touchUpInside)
        
        self.addSubview(self.dropdownButton)
    }
    
    func setupArrowImage() {
        arrowImage = UIImageView(image: UIImage(named: "DownArrow"))
        arrowImage.frame = CGRect(x: self.frame.width - 3 * self.frame.height / 4, y: self.frame.height / 4, width: self.frame.height / 2, height: self.frame.height / 2)
        
        // Add the arrow image at the end of the button.
        self.addSubview(arrowImage)
    }
    
    func setupListTable() {
      //  let yLocation = self.frame.minY + dropdownButton.frame.height
        let yLocation = -200 + dropdownButton.frame.height
        listTable = UITableView(frame: CGRect(x: self.frame.minX, y: yLocation, width: self.frame.width, height: 0))
        listTable.dataSource = self
        listTable.delegate = self
        listTable.isUserInteractionEnabled = true
        
        // Disable scrolling the tableview after it reach the top or bottom.
        listTable.bounces = false
    }
    
    // MARK: - User setting
    
    func dropdownColor(_ backgroundColor: UIColor, selectedColor: UIColor, textColor: UIColor) {
        listTable.backgroundColor = backgroundColor
        cellSelectedColor = selectedColor
        self.textColor = textColor
    }
    
    func dropdownColor(_ backgroundColor: UIColor, buttonColor: UIColor, selectedColor: UIColor, textColor: UIColor) {
        dropdownColor(backgroundColor, selectedColor: selectedColor, textColor: textColor)
        dropdownButton.backgroundColor = buttonColor
    }
    
    func dropdownMaxHeight(_ height: CGFloat) {
        maxHeight = height
    }
    
    // MARK: - Action
    
    func showHideDropdownList(_ sender: AnyObject) {
        if selectedValue != nil {
            dropdownButton.setTitle(selectedValue, for: UIControlState())
        }
        
        if !isShown {
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.superview?.addSubview(self.listTable)
                
                var height = self.tableviewHeight()
                
                if height > self.maxHeight {
                    height = self.maxHeight
                }
                
                var frame = self.listTable.frame
                frame.size.height = CGFloat(height)
                
                self.listTable.frame = frame
                }, completion: { (animated) -> Void in
                    self.arrowImage.image = UIImage(named: "UpArrow")
            })
        }
        else {
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    let height = 0
                    var frame = self.listTable.frame
                    frame.size.height = CGFloat(height)
                
                    self.listTable.frame = frame
                }, completion: { (animated) -> Void in
                    self.listTable.removeFromSuperview()
                    self.arrowImage.image = UIImage(named: "DownArrow")
            })
        }
        
        isShown = !isShown
    }
}

// MARK: - UITableViewDataSource
extension EDropdownList: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = valueList?.count
        
        if count > 0 {
            return count!
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
        }
        
        // Set selected background color.
        let colorView = UIView()
        colorView.backgroundColor = cellSelectedColor
        cell.selectedBackgroundView = colorView
        
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.black
        
        cell.textLabel?.text = valueList?[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            tableView.separatorInset = UIEdgeInsets.zero
        }
        
        if tableView.responds(to: #selector(setter: UIView.layoutMargins)) {
            tableView.layoutMargins = UIEdgeInsets.zero
        }
        
        if cell.responds(to: #selector(setter: UIView.layoutMargins)) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
    }
    
    func tableviewHeight() -> CGFloat {
        listTable.layoutIfNeeded()
        return listTable.contentSize.height
    }
}

// MARK: - UITableViewDelegate
extension EDropdownList: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get selected value.
        let selectedCell = tableView.cellForRow(at: indexPath)
        selectedValue = selectedCell?.textLabel?.text
        selectedCell?.textLabel?.textColor = UIColor.black
        selectedCell?.textLabel?.tintColor = UIColor.black
        
        // Hide the dropdown table and pass the selected value.
        showHideDropdownList(dropdownButton)
        delegate?.didSelectItem((selectedCell?.textLabel?.text)!, index: indexPath.row)
    }
}

