//
//  MEAddMemoViewController.swift
//  Memo
//
//  Created by huangshuni on 2017/3/4.
//  Copyright © 2017年 huangshuni. All rights reserved.
//

import UIKit

class MEAddMemoViewController: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var dataPicker: UIDatePicker!
    @IBOutlet weak var dataPickerHeight: NSLayoutConstraint!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var isTurnOnNotifySwitch: UISwitch!
    var imagesArr : Array<Any> = []
    public var memoModel: MEItemModel?
    public var memoEditing = false
    public var firstInThisView = true//是否第一次进这个页面
    
      // MARK: - life cycle
    
    convenience init() {
        self.init(nibName: "MEAddMemoViewController", bundle: nil)
    }
    
   override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "新增备忘录"
        scrollView.contentSize = CGSize.init(width: UIView.screenWidth, height: UIView.screenHeight+200)
        contentTextView.layer.cornerRadius = 5;
        contentTextView.layer.borderColor = UIColor.darkGray.cgColor
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.masksToBounds = true
        
        photoCollectionView.register(UINib.init(nibName: "MEAddMemoPhotoCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if firstInThisView == true {
            if memoModel != nil {
                if memoEditing == true {
                    reloadMemoModel(memoModel!, allowEditing: true)
                }else{
                    reloadMemoModel(memoModel!, allowEditing: false)
                }
            }
        }
    }

      // MARK: - 屏幕手势
    func tapAction() -> Void {
        view.endEditing(true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.superview?.isKind(of: MEAddMemoPhotoCell.self))! {
            return false
        }
        return true
    }
    
      // MARK: - 给模型赋值
    public func reloadMemoModel(_ memoModel: MEItemModel, allowEditing: Bool) {
        titleTF.isUserInteractionEnabled = allowEditing
        contentTextView.isUserInteractionEnabled = allowEditing
        isTurnOnNotifySwitch.isUserInteractionEnabled = allowEditing
        dataPicker.isUserInteractionEnabled = allowEditing
         doneBtn.isHidden = !allowEditing
        titleTF.text = (memoModel.title)!
        contentTextView.text = (memoModel.content)!
        for photoPath in (memoModel.imgList)! {
            let path = YHFileManager.documentsPath.appending(photoPath)
            let image = UIImage.init(contentsOfFile: path)
            let item = YHPhotoResult.init(image, image)
            imagesArr.append(item)
        }
        photoCollectionView.reloadData()
        isTurnOnNotifySwitch.isOn = (memoModel.isTurnNotify)
        if (memoModel.isTurnNotify) {
            dataPickerHeight.constant = 109
        }else{
            dataPickerHeight.constant = 0
        }
    }
    
      // MARK: - 完成按钮
    @IBAction func addMemoAction(_ sender: UIButton) {
        
        if titleTF.text?.length == 0 {
            alertAction("您还没有添加标题")
            return;
        }
        if contentTextView.text?.length == 0 {
            alertAction("您还没有添加内容")
            return;
        }
        
        var imagePathArr : Array<String> = []
        for item in self.imagesArr {
            var path = YHFileManager.documentsPath.appending("/addMemo/")
            let _ = YHFileManager.directoryIsExist(path)
            let id = NSDate.getCurrentDateStamp()
            path = path.appending(id).appending(".png")
            var imagePath = "/addMemo/"
            imagePath = imagePath.appending(id).appending(".png")
            let image = (item as!YHPhotoResult).highImage
            let imageData: NSData = UIImagePNGRepresentation(image!)! as NSData
            let _ = imageData.write(toFile: path, atomically: true)
            imagePathArr.append(imagePath)
        }
        
        let modelId = NSDate.getCurrentDateStamp()
        let model = MEItemModel.init(id:modelId,  title: titleTF.text!, content: contentTextView.text, imgList: imagePathArr, editDate: NSDate.getCurrentDateStamp(), notifyDate: NSDate.getDateStamp(dataPicker.date as NSDate), isTurnNotify: isTurnOnNotifySwitch.isOn)
        MEDataBase.defaultDB.insertAndUpdateModelToDatabase(model: model)
    }
    
      // MARK: - 是否提醒
    @IBAction func isNotifySwitchAction(_ sender: UISwitch) {
        if sender.isOn {
            dataPickerHeight.constant = 109
        }else{
            dataPickerHeight.constant = 0
        }
    }
    
      // MARK: - 时间选择器值改变
    @IBAction func dataPickerValueChange(_ sender: UIDatePicker) {
       print(sender.date)
       let str = NSDate.getDateStamp(sender.date as NSDate)
       print(str)
    }
    
      // MARK: - 选择照片
    func addPhoto() -> Void {
        
        firstInThisView = false
        
        let picker = YHPhotoPickManagerViewController.init()
        picker.selectCount = (3 - self.imagesArr.count) < 0 ? 0 : (3 - self.imagesArr.count)
        picker.completionAction = { (list) in
            self.imagesArr = self.imagesArr + list
            DispatchQueue.main.async(execute: {
               self.photoCollectionView.reloadData()
            })
        }
       present(picker, animated: true, completion: nil)
    }
    
      // MARK: - 工具类
    func alertAction(_ message: String) {
        let alert =  UIAlertController.init(title: "温馨提示", message: message, preferredStyle: .alert)
        let cancleAction = UIAlertAction.init(title: "知道了", style: .cancel) { (action) in
            
        }
        alert.addAction(cancleAction)
        present(alert, animated: true, completion: nil)
    }
    
      // MARK: - UICollectionViewDeleaget/DataSourse/Flowlayout
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var num = 0
        if (memoModel != nil && memoEditing == false) {
            num = imagesArr.count == 3 ? 3 : imagesArr.count
        }else{
             num = imagesArr.count == 3 ? 3 : (imagesArr.count + 1)
        }
        return num
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: MEAddMemoPhotoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MEAddMemoPhotoCell
        
        if indexPath.row < imagesArr.count {
            let result: YHPhotoResult = self.imagesArr[indexPath.row] as! YHPhotoResult
            cell.photoImageView.image = result.thumbnail
            cell.deletePhotoBtn.isHidden = false
            
            //隐藏删除照片的按钮
            if (memoModel != nil && memoEditing == false) {
                cell.deletePhotoBtn.isHidden = true
            }else{
                cell.deletePhotoBtn.isHidden = false
            }
            
        }else{
            cell.photoImageView.image = UIImage.init(named: "addImage")
            cell.deletePhotoBtn.isHidden = true
        }
        
        cell.deleteBlcok = {(button) -> Void in
            self.imagesArr.remove(at: indexPath.row)
            self.photoCollectionView.reloadData()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == imagesArr.count {
            addPhoto()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
