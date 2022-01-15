 //
//  ChatTrainingLogCell.swift
//  Load
//
//  Created by Haresh Bhai on 30/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//
import UIKit
 
 protocol ChatTrainingLogOREventDelegate:class {
    func ChatTrainingLogReload(index:Int, trainingLog: ChatTrainingLog)
    func ChatEventReload(index:Int, event: ChatEvent)
 }
 
 class ChatTrainingLogCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var imgType: UIImageView!
    @IBOutlet weak var lblTrainingLog: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgChat: UIImageView!
    @IBOutlet weak var logView: CustomView!
    @IBOutlet weak var tableView: UITableView!    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblChatDate: UILabel!

    var trainingLog: ChatTrainingLog?
    weak var delegate: ChatTrainingLogOREventDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tableView.register(UINib(nibName: "TrainingLogCell", bundle: nil), forCellReuseIdentifier: "TrainingLogCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupUI(model: MessageListData) {
        print(self.tag)
        self.setupFont()
        self.layoutIfNeeded()
        self.contentView.layoutIfNeeded()
        self.contentView.layoutSubviews()
        if model.ChatTrainingLog != nil {
            self.trainingLog = model.ChatTrainingLog
            self.imgType.sd_setImage(with: URL(string: SERVER_URL + (self.trainingLog?.iconPath ?? "")), completed: nil)
            self.lblName.text = self.trainingLog?.name
            self.tableViewHeight.constant = CGFloat((self.trainingLog?.data?.count ?? 0) * 35)
            self.lblChatDate.text = convertDateFormater((model.createdAt!), format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ",  dateFormat: "HH:mm a")
            self.tableView.reloadData()
        }
        else {
            SocketIOHandler.shared.getTrainingDetails(id: model.trainingLogId?.intValue ?? 0) { (json) in
                print(json![0])
                if json?.count != 0 && !json![0].isEmpty {
                    let logs = ChatTrainingLog(JSON: json![0].dictionaryObject!)
                    self.trainingLog = logs
                    self.delegate?.ChatTrainingLogReload(index: self.tag, trainingLog: self.trainingLog!)
                }
            }
        }
    }
    
    func changeIcon(isLeft:Bool = true) {
        self.imgChat.image = isLeft ? UIImage(named: "ic_left_message") : UIImage(named: "ic_right_message")
    }
    
    //MARK:- TableView Delegates
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trainingLog?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrainingLogCell") as! TrainingLogCell
        cell.selectionStyle = .none
        let model = self.trainingLog?.data![indexPath.row]
        cell.lblTitle.text = model?.name
        cell.lblName.text = model?.value
        cell.setupUI()
        return cell
    }
    
    func setupFont() {
        self.lblTrainingLog.font = themeFont(size: 13, fontname: .HelveticaBold)
        self.lblName.font = themeFont(size: 12, fontname: .Helvetica)
        
        self.lblTrainingLog.setColor(color: .appthemeBlackColor)
        self.lblName.setColor(color: .appthemeBlackColor)
    }
}
