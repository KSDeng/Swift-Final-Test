//
//  TableViewController.swift
//  Final
//
//  Created by DKS_mac on 2019/12/23.
//  Copyright © 2019 dks. All rights reserved.
//

import UIKit
import SwiftSoup
import WebKit

class TableViewController: UITableViewController {

    let base_url = "https://hr.nju.edu.cn"          // 南大人事处主页
    
    
    var personInform: [EventData] = []          // 人事通知
    var personNews: [EventData] = []            // 人事新闻
    var publicity: [EventData] = []             // 公示公告
    var hiring: [EventData] = []                // 招聘信息
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return personInform.count
        case 1:
            return personNews.count
        case 2:
            return publicity.count
        case 3:
            return hiring.count
        default:
            fatalError("Unknown section")
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! TableViewCell

        // Configure the cell...
        switch indexPath.section {
        case 0:
            cell.titleLabel.text = personInform[indexPath.row].title
            cell.timeLabel.text = personInform[indexPath.row].time.toString(format: "yyyy-MM-dd")
            if personInform[indexPath.row].read > 1000 {
                cell.emojiLabel.text = "🔥"
            } else {
                cell.emojiLabel.text = ""
            }
        case 1:
            cell.titleLabel.text = personNews[indexPath.row].title
            cell.timeLabel.text = personNews[indexPath.row].time.toString(format: "yyyy-MM-dd")
            if personNews[indexPath.row].read > 1000 {
                cell.emojiLabel.text = "🔥"
            } else {
                cell.emojiLabel.text = ""
            }
        case 2:
            cell.titleLabel.text = publicity[indexPath.row].title
            cell.timeLabel.text = publicity[indexPath.row].time.toString(format: "yyyy-MM-dd")
            if publicity[indexPath.row].read > 1000 {
                cell.emojiLabel.text = "🔥"
            } else {
                cell.emojiLabel.text = ""
            }
        case 3:
            cell.titleLabel.text = hiring[indexPath.row].title
            cell.timeLabel.text = hiring[indexPath.row].time.toString(format: "yyyy-MM-dd")
            if hiring[indexPath.row].read > 1000 {
                cell.emojiLabel.text = "🔥"
            } else {
                cell.emojiLabel.text = ""
            }
        default:
            print("Other sections")
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController: DetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "detailView") as! DetailViewController
        
        switch indexPath.section {
        case 0:
            detailViewController.link = personInform[indexPath.row].href
        case 1:
            detailViewController.link = personNews[indexPath.row].href
        case 2:
            detailViewController.link = publicity[indexPath.row].href
        case 3:
            detailViewController.link = hiring[indexPath.row].href
        default:
            fatalError("Unknown section!")
        }
        
        show(detailViewController, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "人事通知"
        case 1:
            return "人事新闻"
        case 2:
            return "公示公告"
        case 3:
            return "招聘信息"
        default:
            fatalError("Unknown section!")
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
    private func fetchData() {
        
        let url = URL(string: base_url)!
        let task = URLSession.shared.dataTask(with: url){(data, response, error) in
            guard let data = data else{
                fatalError("Data is nil!")
            }
            guard let htmlString = String(data: data, encoding: .utf8) else {
                fatalError("Can not cast data into String!")
            }
            
            self.updateDataSource(htmlString: htmlString)
            // self.tableView.reloadData()
        }
        task.resume()
        
        tableView.reloadData()
    }
    
    
    private func updateDataSource(htmlString: String) {
        self.personInform = parseDataFromHTML(htmlString: htmlString, rootElement: "wp_news_w5")
        self.personNews = parseDataFromHTML(htmlString: htmlString, rootElement: "wp_news_w4")
        self.publicity = parseDataFromHTML(htmlString: htmlString, rootElement: "wp_news_w6")
        self.hiring = parseDataFromHTML(htmlString: htmlString, rootElement: "wp_news_w7")
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    /*
    private func updateDataSource(htmlString: String) {
        // print(htmlString)
        do {
            let doc: Document = try SwiftSoup.parse(htmlString)
            // let personInformElement: Element = try doc.getElementsByClass("mod-h1")[0]
            // print(try person.text())
            let personInformList: Element = try doc.getElementById("wp_news_w5")!
            // print(try news.text())
            
            let personInforms = try personInformList.getElementsByTag("li")
            
            for elem in personInforms {
                // print(try elem.text())
                
                let title = try elem.getElementsByTag("a")[0].attr("title") // 获取标题
                // print("title: \(title)")
                let hrefString = try elem.getElementsByTag("a")[0].attr("href")   // 获取链接
                let dateString = try elem.getElementsByClass("news_meta")[0].text()     // 获取时间字符串
                // print("date: \(dateString)")
                var readString = try elem.getElementsByClass("news_meta1")[0].text()    // 获取阅读量
                
                readString.removeFirst()
                readString.removeLast()
                let read = Int(readString)!
                // print("read: \(read)")

                let href = "\(base_url)\(hrefString)"
                // print("href: \(href)")
                
                let date = dateString.toDate(format: "yyyy-MM-dd")
                // print("date: \(date)")
                
                let event = EventData(title: title, time: date, read: read, href: href)
                personInform.append(event)
            }
            
        } catch Exception.Error(let type, let message) {
            print("\(message) \nError type: \(type)")
        } catch {
            print(error)
        }
        
        // refresh tableview
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    */
    
    // 根据html代码和根元素解析并返回EventData数据
    private func parseDataFromHTML(htmlString: String, rootElement: String) -> [EventData] {
        var data: [EventData] = []
        
        do {
            let doc: Document = try SwiftSoup.parse(htmlString)
            let informList = try doc.getElementById(rootElement)!.getElementsByTag("li")
            
            for elem in informList {
                let title = try elem.getElementsByTag("a")[0].attr("title") // 获取标题
                let hrefString = try elem.getElementsByTag("a")[0].attr("href")   // 获取链接
                let dateString = try elem.getElementsByClass("news_meta")[0].text()     // 获取时间字符串
                var readString = try elem.getElementsByClass("news_meta1")[0].text()    // 获取阅读量
                
                readString.removeFirst()
                readString.removeLast()
                let read = Int(readString)!
                let href = "\(base_url)\(hrefString)"
                let date = dateString.toDate(format: "yyyy-MM-dd")
                
                let event = EventData(title: title, time: date, read: read, href: href)
                data.append(event)
            }
            
        } catch Exception.Error(let type, let message) {
            print("\(message) \nError type: \(type)")
        } catch {
            print(error)
        }
        
        return data
    }
    

}

extension String {
    func toDate(format: String) -> Date {
        let f = DateFormatter()
        f.dateFormat = format
        guard let date = f.date(from: self) else {
            fatalError("Date string invalid!")
        }
        return date
    }
}

extension Date {
    func toString(format: String) -> String {
        let f = DateFormatter()
        f.dateFormat = format
        return f.string(from: self)
    }
}
