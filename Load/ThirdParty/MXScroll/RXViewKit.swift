//
//  RXViewKit.swift
//  Load
//
//  Created by Timotius Leonardo Lianoto on 24/04/22.
//  Copyright © 2022 Haresh Bhai. All rights reserved.
//

import Foundation
import EasyPeasy
#if !RX_NO_MODULE
import RxCocoa
import RxSwift
#endif

extension Reactive where Base == UIView {
    var MatchHeightEqualToContent:Binder<CGFloat>{
        return Binder(self.base){(scroll,value) in
            scroll.easy.layout(
                Height(value)
            )
        }
    }
    
    // export to public the real content height.
    var realContentHeight: Observable<CGFloat> {
        return self.observeWeakly(CGRect.self, "frame").map{$0?.height ?? 0}
    }
    
    
}
