//
//  IHRefresh.swift
//  BusinessPods
//
//  Created by Jekin on 2019/4/9.
//

import UIKit
import MJRefresh
public class IHHeaderRefresh: MJRefreshHeader {
    public var offsetY: CGFloat = 0 {
        didSet {
            self.placeSubviews()
        }
    }
    private var stateTitleMapper: [String: String] = [:]
    public let stateLabel: UILabel = UILabel.init(frame: CGRect.zero)
    public let arrowImageView: UIImageView = UIImageView.init(frame: CGRect.zero)
    public let loadingImageView: UIImageView = UIImageView.init(frame: CGRect.zero)
    public override var state: MJRefreshState {
        didSet {
            let stateKey = "\(state.rawValue)"
            self.stateLabel.text = self.stateTitleMapper[stateKey]
            self.setNeedsLayout()
        }
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    deinit {
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        stateLabel.textColor = UIColor(fromHexValue: 0xbabfc9).withAlphaComponent(0.5)
        stateLabel.textAlignment = .center
        stateLabel.font = UIFont.systemFont(ofSize: 14)
        addSubview(stateLabel)
        addSubview(arrowImageView)
        addSubview(loadingImageView)
    }
    
    // MARK: override
    public override func prepare() {
        super.prepare()
        self.mj_h = 44
        self.setTitle("下拉刷新", .idle)
        self.setTitle("松开刷新", .pulling)
        self.setTitle("加载中...", .refreshing)
        
    }
    
    public override func placeSubviews() {
        super.placeSubviews()
        self.stateLabel.sizeToFit()
        if self.stateLabel.isHidden == true {
            self.arrowImageView.center = CGPoint.init(x: self.mj_w * 0.5, y: self.mj_h * 0.5 + self.offsetY)
            self.loadingImageView.center = self.arrowImageView.center
        } else {
            var rect: CGRect = self.arrowImageView.frame
            self.stateLabel.center = CGPoint.init(x: self.mj_w * 0.5 + rect.size.width/2, y: self.mj_h * 0.5 + self.offsetY)
            rect.origin = CGPoint.init(x: self.stateLabel.x - self.arrowImageView.width - 4, y: 0.5 * (self.height - self.arrowImageView.height) + self.offsetY)
            self.arrowImageView.frame = rect
            self.loadingImageView.center = self.arrowImageView.center
        }
    }
    
    public func setTitle(_ title: String, _ state: MJRefreshState) {
        let stateKey = "\(state.rawValue)"
        if self.stateTitleMapper[stateKey] == title {
            return
        }
        self.stateTitleMapper[stateKey] = title
        self.stateLabel.text = self.stateTitleMapper[stateKey]
        self.setNeedsLayout()
    }
}

public class IHFooterRefresh: MJRefreshAutoStateFooter {
    public var isFirstPage: Bool = false {
        didSet {
            if isFirstPage == true {
                self.setTitle("", .noMoreData)
            } else {
                self.setTitle("- 到底啦 -", .noMoreData)
            }
        }
    }
    private var stateTitleMapper: [String: String] = [:]
    public var offsetY: CGFloat = 0
    public override var state: MJRefreshState {
        didSet {
            let stateKey = "\(state.rawValue)"
            self.stateLabel?.text = self.stateTitleMapper[stateKey]
            self.setNeedsLayout()
        }
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.stateLabel?.font = UIFont.systemFont(ofSize: 14)
        self.stateLabel?.textColor = UIColor(fromHexValue: 0xbabfc9)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func setTitle(_ title: String, _ state: MJRefreshState) {
        let stateKey = "\(state.rawValue)"
        if self.stateTitleMapper[stateKey] == title {
            return
        }
        self.stateTitleMapper[stateKey] = title
        self.stateLabel?.text = self.stateTitleMapper[stateKey]
        self.setNeedsLayout()
    }
    
    // MARK: override
    public override func prepare() {
        super.prepare()
        self.mj_h = 50
        self.setTitle("", .idle)
        self.setTitle("加载更多", .pulling)
        self.setTitle("加载中...", .refreshing)
        self.setTitle("- 到底啦 -", .noMoreData)
    }
    
    public override func placeSubviews() {
        super.placeSubviews()
        self.stateLabel?.sizeToFit()
        self.stateLabel?.center = CGPoint(x: self.mj_w * 0.5, y: self.mj_h * 0.5)
    }
    
    // MARK: override
    public override func scrollViewContentSizeDidChange(_ change: [AnyHashable: Any]!) {
        super.scrollViewContentSizeDidChange(change)
        self.mj_y = self.scrollView!.mj_contentH + self.offsetY
    }
    
    public override func scrollViewContentOffsetDidChange(_ change: [AnyHashable: Any]!) {
        super.scrollViewContentOffsetDidChange(change)
        if self.state != .idle || self.scrollView?.mj_contentH == 0 {
            return
        }
        if self.scrollView!.mj_insetT + self.scrollView!.mj_contentH > self.scrollView!.mj_h, self.scrollView!.mj_offsetY >= self.scrollView!.mj_contentH - self.scrollView!.mj_h + self.mj_h + self.scrollView!.mj_insetB - self.mj_h {
            guard let old = change["old"] as? CGPoint, let new = change["new"] as? CGPoint else { return }
            if new.y <= old.y {
                return
            }
            self.beginRefreshing()
        }
    }
    
    public override func scrollViewPanStateDidChange(_ change: [AnyHashable: Any]!) {
        super.scrollViewPanStateDidChange(change)
        if self.state != .idle || self.scrollView?.mj_contentH == 0 {
            return
        }
        if self.scrollView!.panGestureRecognizer.state == .ended {// 手松开
            if self.scrollView!.mj_insetT + self.scrollView!.mj_contentH <= self.scrollView!.mj_h {  // 不够一个屏幕
                if self.scrollView!.mj_offsetY >= -self.scrollView!.mj_insetT { // 向上拽
                    self.beginRefreshing()
                }
            } else { // 超出一个屏幕
                if self.scrollView!.mj_offsetY >= self.scrollView!.mj_contentH + self.scrollView!.mj_insetB - self.scrollView!.mj_h {
                    self.beginRefreshing()
                }
            }
        }
    }
    
    
    
}

class IHRefresh: UIView {
    
    
}
