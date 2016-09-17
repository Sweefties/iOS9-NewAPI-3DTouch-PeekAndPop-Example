![](https://img.shields.io/badge/build-pass-brightgreen.svg?style=flat-square)
![](https://img.shields.io/badge/platform-iOS9+-ff69b4.svg?style=flat-square)
![](https://img.shields.io/badge/Require-XCode8-lightgrey.svg?style=flat-square)


# iOS 9 - New API - 3D Touch - UIKit Peek & Pop Example
iOS 9~ Experiments - New API Components - Previewing with 3DTouch.

## Example

![](https://raw.githubusercontent.com/Sweefties/iOS9-NewAPI-3DTouch-PeekAndPop-Example/master/source/iPhone6S_Simulator2x-3DTouch-PeekAndPop.jpg)


## Requirements

- >= XCode 8.0
- >= Swift 3.
- >= iOS 9.0.
- >= 3D Touch Devices.

Tested on iOS 9.0, iOS 10 Simulators iPhone 6S, 6S Plus , 7 only with forceTouchCapability Unavailable.


## Important

this is the Xcode 8 / Swift 3 updated project.


## Adopting 3D Touch on iPhone

Read : [UIKit Peek and Pop](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/Adopting3DTouchOniPhone/3DTouchAPIs.html#//apple_ref/doc/uid/TP40016543-CH4-SW1)
Protocol Reference : [UIViewControllerPreviewing](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIViewControllerPreviewing_Protocol/index.html#//apple_ref/doc/uid/TP40016568)


## Usage

To run the example project, download or clone the repo.


### Example Code!


```swift
// Check Force touch Capability
if traitCollection.forceTouchCapability == UIForceTouchCapability.Available {
    // register UIViewControllerPreviewingDelegate to enable Peek & Pop
    registerForPreviewingWithDelegate(self, sourceView: view)
    }else {
    // 3D Touch Unavailable : present alertController or
    // Provide alternatives such as touch and hold..
}
```

- We need to conform to UIViewControllerPreviewingDelegate
```swift
func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
    guard let indexPath = tableView.indexPathForRowAtPoint(location), cell = tableView.cellForRowAtIndexPath(indexPath) else { return nil }

    let vc = DetailViewController(data: sampleData[indexPath.row])

    vc.preferredContentSize = CGSize(width: 0.0, height: 320.0)
    previewingContext.sourceRect = cell.frame

    return detailViewController
}
```

- Reuse an existing preview and show it
```swift
func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
    showViewController(viewControllerToCommit, sender: self)
}
```


- Build and Run!
- By pressing lightly (`Peek`) and pressing a little more firmly to actually open content (`Pop`)
- CAUTION! : Untested on physical hardware!
- Devices : with iPhone 6s and others 3D Touch devices!
