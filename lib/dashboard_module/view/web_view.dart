import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:ipodaily/utilities/common/core_app_bar.dart';
import 'package:ipodaily/utilities/navigation/navigator.dart';

class WebView extends StatefulWidget {
  const WebView({super.key, required this.url, required this.title});

  final String url;
  final String title;

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  String? currentUrl;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        currentUrl = widget.url;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        appBar: CoreAppBar(
          showBackButton: true,
          showActions: false,
          title: widget.title,
        ),
        body: InAppWebView(
          initialUrlRequest: URLRequest(url: Uri.parse("https://bhulekh.mahabhumi.gov.in/" ?? currentUrl ?? widget.url)),
          onWebViewCreated: (InAppWebViewController controller) {},
          onReceivedServerTrustAuthRequest: (controller, challenge) async {
            return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
          },

          initialOptions: InAppWebViewGroupOptions(
            android: AndroidInAppWebViewOptions(
              mixedContentMode: AndroidMixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
            ),
            crossPlatform: InAppWebViewOptions(
              javaScriptEnabled: true,
              clearCache: true,
              allowUniversalAccessFromFileURLs: true,
            ),


            // crossPlatform: InAppWebViewOptions(
            //   // javaScriptEnabled: true,
            //   // supportZoom: false,
            //   // allowFileAccessFromFileURLs: false,
            //   allowUniversalAccessFromFileURLs: true,
            //   clearCache: true,
            //   useShouldOverrideUrlLoading: true,
            //   javaScriptEnabled: false,
            //   supportZoom: false,
            // ),
            // android: AndroidInAppWebViewOptions(
            //   allowContentAccess: true,
            //   useWideViewPort: true,
            //   mixedContentMode: AndroidMixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
            // ),
          ),
          onLoadStart: (controller, url) async {
            debugPrint("onLoadStart:::::::::$url");
            // if (url.toString() != widget.url) {
            //   MyNavigator.pop();
            // }
            // evaluateScript(controller);
          },
          onLoadError: (controller, url, code, message) async {
            debugPrint("onLoadError:::::::::$url");
            // if (url.toString() != widget.url) {
            //   MyNavigator.pop();
            // }
          },
          onLoadStop: (controller, url) async {
            debugPrint("onLoadStop:::::::::$url");
            // evaluateScript(controller);

            // if (url.toString() != widget.url) {
            //   MyNavigator.pop();
            // }
          },
          onProgressChanged: (controller, progress) async {
            debugPrint("onProgressChanged:::::::::$progress");
            // evaluateScript(controller);
          },
        ),
      ),
    );
  }
}

void evaluateScript(InAppWebViewController controller) async {
  await controller.evaluateJavascript(source: """
              document.querySelectorAll('a').forEach(function(link) {
                link.onclick = function(event) {
                  event.preventDefault();
                };
              });
            // document.querySelector('.h12Wrapper.backgroundPrimary.h12BotBorder').remove();
            // document.querySelector('.foot21ExploreHead').remove();
            // document.querySelector('.foot21MoreAbout').remove();
            // document.querySelector('.valign-wrapper.foot21Div').remove();
            // document.querySelector('.foot21Box').remove();
            // document.querySelector('.bfc43CategoryContainer').remove();
            // document.querySelector('.bfc43Title.bodyXLargeHeavy').remove();
            // document.querySelector('.bs91SidebarLinks').remove();
            // document.querySelector('.bmp88Disclaimer').remove();

            """);
}

