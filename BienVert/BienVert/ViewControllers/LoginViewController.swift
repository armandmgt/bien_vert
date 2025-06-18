//  LoginViewController.swift
//  BienVert
//
//  Created by Armand Mégrot on 12/06/2025.
//

import HotwireNative
import UIKit
import WebKit

class LoginViewController: UIViewController, WKNavigationDelegate {
    private var webView: WKWebView!
    private var urlObservation: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        isModalInPresentation = true
        setupWebView()
        loadLoginPage()
        observeWebViewURL()
    }

    private func setupWebView() {
        webView = WKWebView(frame: .zero)
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func loadLoginPage() {
        let request = URLRequest(url: rootURL.appending(path: "session/new"))
        webView.load(request)
    }

    private func observeWebViewURL() {
        urlObservation = webView.observe(\.url, options: [.new]) { [weak self] webView, change in
            guard let self = self, let url = change.newValue as? URL else { return }
            if self.isLoginSuccessURL(url) {
                self.handleLoginSuccess()
            }
        }
    }

    private func handleLoginSuccess() {
        if let tabBarController = presentingViewController as? HotwireTabBarController {
            tabBarController.load(HotwireTab.all)
        }
        self.dismiss(animated: true)
    }

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let url = navigationAction.request.url {
            if isLoginSuccessURL(url) {
                handleLoginSuccess()
            }
        }
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let url = webView.url {
            if isLoginSuccessURL(url) {
                handleLoginSuccess()
            }
        }
    }

    private func isLoginSuccessURL(_ url: URL) -> Bool {
        return url.path() != "/session/new"
    }

    deinit {
        urlObservation?.invalidate()
    }
}
