//
//  MEAddMemoViewController.swift
//  Memo
//
//  Created by huangshuni on 2017/3/4.
//  Copyright © 2017年 huangshuni. All rights reserved.
//

import UIKit

public let photoDirectory = "/addMemo/"

class MEAddMemoViewController: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    let maxPhotoCount = 3
    let addMemoNotifiyDateLblHeight:CGFloat = 200.0
    let addMemoConcreteDateLblHeight:CGFloat = 40.0
    let scrollViewContentSizeHeight = UIView.screenHeight
    let addMemoLineViewLeading:CGFloat = 20.0
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var dataPicker: UIDatePicker!
    @IBOutlet weak var dataPickerHeight: NSLayoutConstraint!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var isTurnOnNotifySwitch: UISwitch!
    @IBOutlet weak var notifyOneChangeLineViewLeading: NSLayoutConstraint!
    
    @IBOutlet weak var notifyTwoChangeLineViewLeading: NSLayoutConstraint!
    @IBOutlet weak var notifiyDateLbl: UIView!
    @IBOutlet weak var notifiyDateLblHeight: NSLayoutConstraint!
    @IBOutlet weak var concreteNotifyDateLbl: UILabel!
    var rightBarButtonItem : UIBarButtonItem?
    
    var imagesArr : Array<Any> = []
    public var memoModel: MEItemModel?
    public var memoEditing = false
    public var firstInThisView = true//是否第一次进这个页面
    var showDatePicker = false
    
    
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
        
        title = addMemo_Title
        scrollView.contentSize = CGSize.init(width: UIView.screenWidth, height: scrollViewContentSizeHeight)
        scrollView.showsVerticalScrollIndicator = false
//        scrollView.isPagingEnabled = false
//        scrollView.isScrollEnabled = false
        
        photoCollectionView.register(UINib.init(nibName: "MEAddMemoPhotoCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
        let ges = UITapGestureRecognizer.init(target: self, action: #selector(showDatePickerAction))
        notifiyDateLbl.addGestureRecognizer(ges)
        
        rightBarButtonItem = UIBarButtonItem.init(title: addMemo_done_title, style: .plain, target: self, action: #selector(addMemoAction))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        concreteNotifyDateLbl.text = NSDate.getFormatterDateTime(date: dataPicker.date as NSDate, formatter: "yyyy-MM-dd HH:mm:ss")
        
        notifiyDateLblHeight.constant = addMemoConcreteDateLblHeight
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if firstInThisView == true {
            if memoModel != nil {
                if memoEditing == true {
                    rightBarButtonItem?.title = addMemo_done_title
                    reloadMemoModel(memoModel!)
                    reloadUI(allowEditing: true)
                }else{
                    rightBarButtonItem?.title = addMemo_modify_title
                    reloadMemoModel(memoModel!)
                    reloadUI(allowEditing: false)
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
    public func reloadMemoModel(_ memoModel: MEItemModel) {
        titleTF.text = (memoModel.title)!
        contentTextView.text = (memoModel.content)!
        DispatchQueue.global().async {
            for photoPath in (memoModel.imgList)! {
                let path = MEItemModel.getImagePath(imgName: photoPath)
                let image = UIImage.init(contentsOfFile: path)
                let item = YHPhotoResult.init(image, image)
                self.imagesArr.append(item)
            }
            DispatchQueue.main.async {
                self.photoCollectionView.reloadData()
            }
        }
        
        isTurnOnNotifySwitch.isOn = (memoModel.isTurnNotify)
        concreteNotifyDateLbl.text = NSDate.getFormatterDateTime(dateStamp: memoModel.notifyDate!, formatter: "yyyy-MM-dd HH:mm:ss")
    }
    
      // MARK: - 转变界面的编辑状态
    public func reloadUI(allowEditing: Bool){
        titleTF.isUserInteractionEnabled = allowEditing
        contentTextView.isUserInteractionEnabled = allowEditing
        isTurnOnNotifySwitch.isUserInteractionEnabled = allowEditing
        dataPicker.isUserInteractionEnabled = allowEditing
        notifiyDateLbl.isUserInteractionEnabled = allowEditing
        photoCollectionView.reloadData()
        if (isTurnOnNotifySwitch.isOn) {
            notifiyDateLblHeight.constant = addMemoConcreteDateLblHeight
        }else{
            notifiyDateLblHeight.constant = 0
        }
//        showDatePicker = true
    }
    
      // MARK: - 展示dataPick
    func showDatePickerAction() {
        showDatePicker = !showDatePicker
        notifiyDateLblHeight.constant = (showDatePicker == true ? addMemoNotifiyDateLblHeight : addMemoConcreteDateLblHeight)
        notifyTwoChangeLineViewLeading.constant = (showDatePicker == true ? addMemoLineViewLeading : 0)
    }
    
      // MARK: - 完成按钮
    @IBAction func addMemoAction(_ sender: UIButton) {
        
        if rightBarButtonItem?.title == addMemo_modify_title {
            rightBarButtonItem?.title = addMemo_done_title
            self.memoEditing = true
            reloadUI(allowEditing: true)
            return
        }
        
        if titleTF.text?.length == 0 {
            alertAction(addMemo_Notification_noTitle)
            return;
        }
        if contentTextView.text?.length == 0 {
            alertAction(addMemo_Notification_noContent)
            return;
        }
        
        DispatchQueue.global().async {
        
            var imagePathArr : Array<String> = []
            for item in self.imagesArr {
                var path = YHFileManager.documentsPath.appending(photoDirectory)
                let _ = YHFileManager.directoryIsExist(path)
                let id = NSDate.getCurrentDateStamp()
                path = path.appending(id).appending(".png")
                let imagePath = id.appending(".png")
                let image = (item as!YHPhotoResult).highImage
                let imageData: NSData = UIImagePNGRepresentation(image!)! as NSData
                let flag = imageData.write(toFile: path, atomically: true)
                log.debug("图片写入文件成功： \(flag) \n path: \(path)")
                imagePathArr.append(imagePath)
            }
            
            var identifier: String!
            var regModel: MEItemModel!
            if self.memoModel != nil {
                self.memoModel?.title = self.titleTF.text
                self.memoModel?.content = self.contentTextView.text
                self.memoModel?.imgList = imagePathArr
                self.memoModel?.editDate = NSDate.getCurrentDateStamp()
                self.memoModel?.notifyDate = NSDate.getDateStamp(self.dataPicker.date as NSDate)
                self.memoModel?.isTurnNotify = self.isTurnOnNotifySwitch.isOn
                MEDBManager.manager.saveItem(model: self.memoModel!)
                identifier = self.memoModel?.id
                regModel = self.memoModel!
            }else{
                let modelId = NSDate.getCurrentDateStamp()
                let model = MEItemModel.init(id:modelId,  title: self.titleTF.text!, content: self.contentTextView.text, imgList: imagePathArr, editDate: NSDate.getCurrentDateStamp(), notifyDate: NSDate.getDateStamp(self.dataPicker.date as NSDate), isTurnNotify: self.isTurnOnNotifySwitch.isOn)
                MEDBManager.manager.saveItem(model: model)
                identifier = modelId
                regModel = model
            }
            if self.isTurnOnNotifySwitch.isOn {
                //注册或修改通知
                //提醒时间可能修改，因此先移除旧通知，再添加新通知
                MENotifyCenter.center.removeNotification(identifier: identifier)
                MENotifyCenter.center.registerNotification(model: regModel)
            }
        }
          _ = self.navigationController?.popViewController(animated: true)
        
    }
    
      // MARK: - 是否提醒
    @IBAction func isNotifySwitchAction(_ sender: UISwitch) {
        if sender.isOn {
            notifiyDateLblHeight.constant = self.addMemoConcreteDateLblHeight
            notifyOneChangeLineViewLeading.constant = addMemoLineViewLeading
        }else{
            notifiyDateLblHeight.constant = 0
            notifyOneChangeLineViewLeading.constant = 0
            showDatePicker = false
        }
    }
    
      // MARK: - 时间选择器值改变
    @IBAction func dataPickerValueChange(_ sender: UIDatePicker) {
        
       concreteNotifyDateLbl.text = NSDate.getFormatterDateTime(date: sender.date as NSDate, formatter: "yyyy-MM-dd HH:mm:ss")
    }
    
      // MARK: - 选择照片
    func addPhoto() -> Void {
        
        firstInThisView = false
        
        let alert = UIAlertController.init(title: "", message: addPhoto_alert_title, preferredStyle: .actionSheet)
        let action1 = UIAlertAction.init(title: addPhoto_alert_camera, style: .default) { (action) in
            self.selectPhotoFromCamera()
        }
        let action2 = UIAlertAction.init(title: addPhoto_alert_album, style: .default) { (action) in
            self.selectPhotoFromAlbum()
        }
        let action3 = UIAlertAction.init(title: addPhoto_alert_cancle, style: .cancel, handler: nil)
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        present(alert, animated: true, completion: nil)
    }
    
      // MARK: -从相机选择
    func selectPhotoFromCamera(){
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) && UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.rear) {
            let picker = UIImagePickerController.init()
            picker.sourceType = .camera
            picker.isEditing = false
            picker.delegate = self
            present(picker, animated: true, completion: nil)
        }
    }
    
      // MARK: -从相册选择
    func selectPhotoFromAlbum(){
        let picker = YHPhotoPickManagerViewController.init()
        picker.selectCount = (maxPhotoCount - self.imagesArr.count) < 0 ? 0 : (maxPhotoCount - self.imagesArr.count)
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
        let alert =  UIAlertController.init(title: addMemo_alert_title, message: message, preferredStyle: .alert)
        let cancleAction = UIAlertAction.init(title: addMemo_alert_cancle, style: .cancel) { (action) in
            
        }
        alert.addAction(cancleAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - UINavigationControllerDelegate,UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let result = YHPhotoResult.init(info[UIImagePickerControllerOriginalImage] as! UIImage?, info[UIImagePickerControllerOriginalImage] as! UIImage?)
        UIImageWriteToSavedPhotosAlbum(info[UIImagePickerControllerOriginalImage] as! UIImage, nil, nil, nil)//保存到相册
        picker.dismiss(animated: true) {
            self.imagesArr.append(result)
            self.photoCollectionView.reloadData()
        }
    }

    
      // MARK: - UICollectionViewDeleaget/DataSourse/Flowlayout
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var num = 0
        if (memoModel != nil && memoEditing == false) {
            num = imagesArr.count == maxPhotoCount ? maxPhotoCount : imagesArr.count
        }else{
             num = imagesArr.count == maxPhotoCount ? maxPhotoCount : (imagesArr.count + 1)
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
