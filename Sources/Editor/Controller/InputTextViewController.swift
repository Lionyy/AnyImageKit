//
//  InputTextViewController.swift
//  AnyImageKit
//
//  Created by 蒋惠 on 2019/12/2.
//  Copyright © 2019 AnyImageProject.org. All rights reserved.
//

import UIKit

protocol InputTextViewControllerDelegate: class {
    
    func inputTextDidCancel(_ controller: InputTextViewController)
    func inputText(_ controller: InputTextViewController, didFinishInput data: TextData)
}

final class InputTextViewController: UIViewController {
    
    private lazy var coverImageView: UIImageView = {
        let view = UIImageView(image: coverImage)
        view.contentMode = .scaleAspectFill
        return view
    }()
    private lazy var coverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.45)
        return view
    }()
    private lazy var cancelButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setTitle(BundleHelper.editorLocalizedString(key: "Cancel"), for: .normal)
        view.setTitleColor(UIColor.white, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        view.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
        return view
    }()
    private lazy var doneButton: UIButton = {
        let view = UIButton(type: .custom)
        view.layer.cornerRadius = 4
        view.backgroundColor = manager.photoConfig.tintColor
        view.setTitle(BundleHelper.editorLocalizedString(key: "Done"), for: .normal)
        view.setTitleColor(UIColor.white, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        view.contentEdgeInsets = UIEdgeInsets(top: 5, left: 12, bottom: 5, right: 10)
        view.addTarget(self, action: #selector(doneButtonTapped(_:)), for: .touchUpInside)
        return view
    }()
    private lazy var toolView: EditorTextToolView = {
        let view = EditorTextToolView(frame: .zero, config: manager.photoConfig, idx: data.colorIdx, isTextSelected: data.isTextSelected)
        view.delegate = self
        return view
    }()
    private var textLayer: CAShapeLayer?
    private lazy var textCoverView: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var textView: UITextView = {
        let view = UITextView()
        view.delegate = self
        view.backgroundColor = .clear
        view.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        view.tintColor = manager.photoConfig.tintColor
        let color = manager.photoConfig.textColors[data.colorIdx]
        view.textColor = data.isTextSelected ? color.subColor : color.color
        view.frame = CGRect(x: 10, y: 0, width: UIScreen.main.bounds.width-40, height: 55) // 预设
        return view
    }()
    /// 仅用于计算TextView最后一行的文本
    private lazy var calculatelabel: UILabel = {
        let view = UILabel()
        view.isHidden = true
        view.font = UIFont.systemFont(ofSize: 32)
        return view
    }()
    
    private weak var delegate: InputTextViewControllerDelegate?
    private let manager: EditorManager
    private let coverImage: UIImage?
    private let data: TextData
    
    private let lineHeight: CGFloat = 36
    private var isBegin: Bool = true
    
    init(manager: EditorManager, data: TextData, coverImage: UIImage?, delegate: InputTextViewControllerDelegate) {
        self.delegate = delegate
        self.manager = manager
        self.coverImage = coverImage
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeNotification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupView()
        addNotification()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isBegin {
            isBegin = false
            if !data.text.isEmpty {
                textView.text = data.text
                textViewDidChange(textView)
            }
            textView.becomeFirstResponder()
        }
    }
    
    private func setupView() {
        view.addSubview(coverImageView)
        view.addSubview(coverView)
        view.addSubview(cancelButton)
        view.addSubview(doneButton)
        view.addSubview(toolView)
        view.addSubview(textCoverView)
        textCoverView.addSubview(textView)
        view.addSubview(calculatelabel)
        
        coverImageView.snp.makeConstraints { (maker) in
            maker.left.right.equalToSuperview()
            maker.centerY.equalToSuperview()
            if let image = coverImage {
                let height = UIScreen.main.bounds.width * image.size.height / image.size.width
                maker.height.equalTo(height)
            } else {
                maker.height.equalTo(0)
            }
        }
        coverView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(coverImageView)
        }
        cancelButton.snp.makeConstraints { (maker) in
            if #available(iOS 11.0, *) {
                maker.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            } else {
                maker.top.equalToSuperview().offset(30)
            }
            maker.left.equalToSuperview().offset(15)
        }
        doneButton.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(cancelButton)
            maker.right.equalToSuperview().offset(-15)
        }
        toolView.snp.makeConstraints { (maker) in
            maker.left.right.equalToSuperview().inset(20)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            } else {
                maker.bottom.equalToSuperview().offset(-40)
            }
            maker.height.equalTo(30)
        }
        textCoverView.snp.makeConstraints { (maker) in
            maker.top.equalTo(cancelButton.snp.bottom).offset(50)
            maker.left.equalToSuperview().offset(10)
            maker.right.equalToSuperview().offset(-10)
            maker.height.equalTo(lineHeight+10*2)
        }
        textView.snp.makeConstraints { (maker) in
            maker.top.bottom.equalToSuperview()
            maker.left.right.equalToSuperview().inset(10)
        }
        calculatelabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(cancelButton.snp.bottom).offset(200)
            maker.left.right.equalToSuperview().inset(25)
            maker.height.equalTo(55)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

// MARK: - Target
extension InputTextViewController {
    
    @objc private func cancelButtonTapped(_ sender: UIButton) {
        delegate?.inputTextDidCancel(self)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func doneButtonTapped(_ sender: UIButton) {
        updateTextCoverView()
        textView.resignFirstResponder()
        data.text = textView.text
        data.imageData = textCoverView.screenshot.pngData() ?? Data()
        delegate?.inputText(self, didFinishInput: data)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Private
extension InputTextViewController {
    
    /// 设置蒙层
    private func setupMaskLayer(_ height: CGFloat = 0) {
        let height = height == 0 ? textCoverView.bounds.height : height
        textLayer?.removeFromSuperlayer()
        let array = getLinesArrayOfString(in: calculatelabel)
        if array.isEmpty { return }
        let lastLineWidth = string(text: array.last!, font: textView.font!, widthOfHeight: 100) + 30
        textLayer = createMaskLayer(CGSize(width: textCoverView.bounds.width, height: height), lastLineWidth: lastLineWidth, hasMultiLine: array.count > 1)
        textCoverView.layer.insertSublayer(textLayer!, at: 0)
    }
    
    /// 计算行数
    private func getLinesArrayOfString(in label: UILabel) -> [String] {
        var linesArray = [String]()
        let rect = label.frame
        guard let text = label.text, let font = label.font else { return linesArray }
        let attr = NSMutableAttributedString(string: text)
        attr.addAttribute(.font, value: font, range: NSRange(location: 0, length: attr.length))
        let frameSetter: CTFramesetter = CTFramesetterCreateWithAttributedString(attr)
        let path: CGMutablePath = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: rect.size.width, height: 100000), transform: .identity)
        
        let frame: CTFrame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil)
        guard let lines = CTFrameGetLines(frame) as? [Any] else {return linesArray}
        
        for line in lines {
            let lineRef = line as! CTLine
            let lineRange: CFRange = CTLineGetStringRange(lineRef)
            let range = NSRange(location: lineRange.location, length: lineRange.length)
            let lineString: String = (text as NSString).substring(with: range)
            linesArray.append(lineString)
        }
        return linesArray
    }
    
    /// 创建蒙层
    private func createMaskLayer(_ size: CGSize, lastLineWidth: CGFloat, hasMultiLine: Bool) -> CAShapeLayer {
        let radius: CGFloat = 12
        let lastLineWidth = lastLineWidth < size.width ? lastLineWidth : size.width
        let width: CGFloat = !hasMultiLine ? lastLineWidth : size.width
        let height: CGFloat = size.height
        let lastLineHeight: CGFloat = lineHeight + 2
        
        let bezier: UIBezierPath
        if hasMultiLine && width - lastLineWidth > 20 { // 一半的情况
            bezier = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: width, height: height), byRoundingCorners: [.topLeft, .topRight, .bottomLeft], cornerRadii: CGSize(width: radius, height: radius))
            let cropBezier1 = UIBezierPath(roundedRect: CGRect(x: lastLineWidth, y: height-lastLineHeight, width: width-lastLineWidth, height: lastLineHeight), byRoundingCorners: .topLeft, cornerRadii: CGSize(width: radius, height: radius))
            bezier.append(cropBezier1)
            let cropBezier2 = createReversePath(CGPoint(x: lastLineWidth-radius, y: height-radius), radius: radius)
            bezier.append(cropBezier2)
            let cropBezier3 = createReversePath(CGPoint(x: width-radius, y: height-lastLineHeight-radius), radius: radius)
            bezier.append(cropBezier3)
        } else {
            bezier = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: width, height: height), cornerRadius: radius)
        }
        
        let layer = CAShapeLayer()
        layer.frame = CGRect(origin: .zero, size: size)
        layer.path = bezier.cgPath
        layer.fillRule = .evenOdd
        layer.cornerRadius = radius
        let color = manager.photoConfig.textColors[data.colorIdx]
        layer.fillColor = data.isTextSelected ? color.color.withAlphaComponent(0.95).cgColor : nil
        return layer
    }
    
    /// 创建反向扇形图形
    private func createReversePath(_ origin: CGPoint, radius: CGFloat) -> UIBezierPath {
        let rect = CGRect(origin: origin, size: CGSize(width: radius, height: radius))
        let cropBezier = UIBezierPath(rect: rect)
        cropBezier.move(to: origin)
        cropBezier.addArc(withCenter: origin, radius: radius, startAngle: CGFloat.pi/2, endAngle: 0, clockwise: false)
        return cropBezier.reversing()
    }
    
    /// 计算文本宽度
    private func string(text: String, font: UIFont, widthOfHeight height: CGFloat) -> CGFloat {
        let attr = NSMutableAttributedString(string: text)
        attr.addAttribute(.font, value: font, range: NSRange(location: 0, length: text.count))
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        return attr.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil).integral.width
    }
    
    /// 更新宽度
    private func updateTextCoverView() {
        let array = getLinesArrayOfString(in: calculatelabel)
        if array.count == 1 {
            let lastLineWidth = string(text: array.last!, font: textView.font!, widthOfHeight: 100) + 30
            let offset = textCoverView.bounds.width - lastLineWidth + 10
            textCoverView.snp.updateConstraints { (maker) in
                maker.right.equalToSuperview().offset(-offset)
            }
        }
    }
}

// MARK: - UITextViewDelegate
extension InputTextViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        calculatelabel.text = textView.text
        let line = CGFloat(getLinesArrayOfString(in: calculatelabel).count)
        let height: CGFloat = max(lineHeight * line + 10 * 2, textView.contentSize.height)
        textCoverView.snp.updateConstraints { (maker) in
            maker.height.equalTo(height)
        }
        
        setupMaskLayer(height)
    }
}

// MARK: - EditorTextToolViewDelegate
extension InputTextViewController: EditorTextToolViewDelegate {
    
    func textToolView(_ toolView: EditorTextToolView, textButtonTapped isSelected: Bool) {
        data.isTextSelected = isSelected
        let color = manager.photoConfig.textColors[data.colorIdx]
        textView.textColor = data.isTextSelected ? color.subColor : color.color
        setupMaskLayer()
    }
    
    func textToolView(_ toolView: EditorTextToolView, colorDidChange idx: Int) {
        data.colorIdx = idx
        let color = manager.photoConfig.textColors[data.colorIdx]
        textView.textColor = data.isTextSelected ? color.subColor : color.color
        if data.isTextSelected {
            setupMaskLayer()
        }
    }
}

// MARK: - Notification
extension InputTextViewController {
    
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChanged(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChanged(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardFrameChanged(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let offset = UIScreen.main.bounds.height - frame.origin.y
        toolView.snp.remakeConstraints { (maker) in
            maker.left.right.equalToSuperview().inset(20)
            if offset == 0 {
                if #available(iOS 11.0, *) {
                    maker.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
                } else {
                    maker.bottom.equalToSuperview().offset(-40)
                }
            } else {
                maker.bottom.equalToSuperview().offset(-offset-20)
            }
            maker.height.equalTo(30)
        }
        view.layoutIfNeeded()
    }
}
