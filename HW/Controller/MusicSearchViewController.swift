//
//  ViewController.swift
//  HW
//
//  Created by ＬＥＯ on 2023/3/20.
//

import UIKit




class MusicSearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var pageSizeText: UITextField! {
        didSet {
            pageSizeText?.addDoneCancelToolbar(onDone: (target: self, action: #selector(doneButtonTappedForMyNumericTextField)))
        }
    }
    @IBOutlet var dataLoadingLabel: UILabel!
    
    var offset = 0
    
    
    @objc func doneButtonTappedForMyNumericTextField() {
        //print("Done");
        updatePageSize((Any).self)
        pageSizeText.resignFirstResponder()
        
    }
    
    var musicList: [Music] = []
    var pageSize = 10
    var currentPage = 1
    var isLoading = false
    var trackID = Int(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 120
        dataLoadingLabel.text = "請在搜尋欄輸入關鍵字"
        searchBar.delegate = self
        self.pageSize = Int(pageSizeText.text!)!
    }
    
    
    @IBAction func updatePageSize(_ sender: Any) {
        if let text = pageSizeText.text, let pageSize = Int(text) {
            // 將使用者輸入的文字轉換成 Int，並儲存到 pageSize 變數中
            self.pageSize = pageSize
            // 重新載入 UITableView，以顯示新的分頁數量
            tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange  text: String) -> Bool {
        if text.isEmpty {
            //清除按鈕時執行相應的操作
            print("使用者點擊了SearchBar的清除按鈕")
            self.offset = 0
            musicList = []
            tableView.reloadData()
        }
        return true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //滑到最底
        let position = scrollView.contentOffset.y
        if position >= (tableView.contentSize.height - scrollView.frame.size.height) {
            guard let query = searchBar.text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)else {
                return
            }
            if !isLoading {
                isLoading = true
                // 滑到最底執行的事件，例如載入更多資料等等
                self.dataLoadingLabel.text = "加載新資料中，已載入\(self.musicList.count)筆資料"
                //print("偵測滑到底部,尚未載入調整前offset = \(self.offset)")
                self.offset = self.offset +  self.pageSize
                //print("調整後、未載入新資料前offset = \(self.offset)")
                searchMusicWithOffset(query: query,offset: self.offset,limit: self.pageSize) { [weak self] musicList in
                    self?.musicList += musicList
                    
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                        
                        if self!.musicList.count != 0{
                            self?.dataLoadingLabel.text = "新資料加載完成，已載入\(self!.musicList.count)筆資料"
                        }
                        else{
                            self?.dataLoadingLabel.text = "請在搜尋欄輸入關鍵字"
                        }
                        
                    }
                }
                // 設定一定時間後可以再次觸發事件
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.isLoading = false
                }
            }
        }
    }
    
}
class MusicCell: UITableViewCell {
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var songLabel: UILabel!
    var height: CGFloat = 0
    var trackID = Int(0)
    override func prepareForReuse() {
        super.prepareForReuse()
        
        coverImageView.image = nil
        artistLabel.text = nil
        albumLabel.text = nil
        songLabel.text = nil
        
    }
    
    func configure(with music: Music) {
        artistLabel.text = music.artist
        albumLabel.text = music.album
        songLabel.text = music.song
        height = 120
        trackID = music.trackId
        
        // 加载封面图像
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = try? Data(contentsOf: music.coverURL),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.coverImageView.image = image
                }
            }
        }
    }
}







extension MusicSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("musicList.count=\(musicList.count)")
        return musicList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MusicCell", for: indexPath) as? MusicCell else {
            fatalError("Unable to dequeue MusicCell")
        }
        let music = musicList[indexPath.row]
        cell.configure(with: music)
        return cell
    }
    
    
    
    
    
}


extension MusicSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //選中musicCell對應執行動作
        let cell = tableView.cellForRow(at: indexPath) as! MusicCell
        trackID = cell.trackID
        self.performSegue(withIdentifier: "showTrack", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTrack" {
            let destinationVC = segue.destination as! MusicDetailViewController
            destinationVC.trackID = trackID
            
        }
    }
}


extension MusicSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.endEditing(true)
        guard let query = searchBar.text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)else {
            return
        }
        self.offset = 0
        let offset = self.offset
        let limit = self.pageSize
        searchMusicWithOffset(query: query,offset: offset,limit: limit) { [weak self] musicList in
            self?.musicList = musicList
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                //self?.offset = self!.offset + Int(self!.pageSize+self!.pageSize/2)
                //print("offset=\(self!.offset)")
                
                if self!.musicList.count != 0{
                    self?.dataLoadingLabel.text = "搜尋完成，已載入\(self!.musicList.count)筆資料"
                }
                else{
                    self?.dataLoadingLabel.text = "請在搜尋欄輸入關鍵字"
                }
            }
        }
    }
    
    
    
    
}

extension UITextField {
    //輸入每頁載入資料時在數字鍵盤上新增Done、Cancel
    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        let onCancel = onCancel ?? (target: self, action: #selector(cancelButtonTapped))
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: onCancel.target, action: onCancel.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    // Default actions:
    @objc func doneButtonTapped() {
        self.resignFirstResponder() }
    @objc func cancelButtonTapped() { self.resignFirstResponder() }
}



