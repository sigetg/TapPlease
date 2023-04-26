//
//  WebView.swift
//  TapPlease!
//
//  Created by George Sigety on 4/24/23.
//

import Foundation
import SwiftUI
import WebKit
 
struct WebView: UIViewRepresentable {
 
    var url: URL
 
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        
        webView.load(request)
        
    }
}

