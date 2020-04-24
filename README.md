# FloatingSideMenu

## About
Customizable side menu with floating design.

## Usage
### Quickstart
Create menu items as ```SideMenuItem```.
```swift
let view1 = SideMenuItemController()
view1.view.backgroundColor = .green
let item1 = SideMenuItem(icon: nil, title: "Green Page", viewController: view1)
        
let view2 = SideMenuItemController()
view2.view.backgroundColor = .yellow
let item2 = SideMenuItem(icon: nil, title: "Yellow Page", viewController: view2)
```

Initialize menu with array of items.
```swift   
let menu = SideMenu(items: [item1, item2])
```

Then use menu as you need.
For example:
```swift
var window: UIWindow?
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = menu
    window!.makeKeyAndVisible()
    return true
}
```

#### Views proportioning
All frames proportioning automatically, except views with constraints.
In case you want to manually change the proportions, you can use the following variables:

```SideMenuItemController.proportion``` - proportion to previous frame size.

```SideMenuItemController.absoluteProportion``` - proportion to ```UIScreen.main.bounds```.


For example ```absoluteProportion``` can be used in table:

```swift
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60 * self.absoluteProportion
}
```

### Customization
You can easily customize menu style.

#### Add top & bottom views
```swift
let topView = TopViewController()
let bottomView = BottomViewController()

menu.topView = topView.view
menu.bottomView = bottomView.view
```
#### Customize menu titles
Create custom class by inheriting ```UIView``` & ```SideMenuItemCellDelegate```.
```swift
class CustomSideMenuItemCell: UIView, SideMenuItemCellDelegate {
    func setData(item: SideMenuItem) {
        self.title.text = item.title
    }

    func select(_ select: Bool) {
        title.textColor = select ? UIColor.red : UIColor.black
    }

    static func cellHeight(stackWidth: CGFloat) -> CGFloat {
        return 52
    }
}
```
Then set it in menu object.
```swift
menu.menuItemCellClass = CustomSideMenuItemCell.self
```

#### Menu configuration

```swift 
SideMenu.disableViewInteraction: Bool
``` 
- disable interaction on view when it collapsed. `true` by default.
```swift 
SideMenu.openSwipeIsEnabled: Bool
``` 
- enable swipe to expand view. `true` by default.
```swift 
SideMenu.closeSwipeIsEnabled: Bool
``` 
- enable swipe to collapse view. `true` by default.


## Demo
<p align="left"><img height="600" src="https://raw.githubusercontent.com/LesGrob/FloatingSideMenu/master/Screenshots/FloatingSideMenu-demo.gif" /></p>

## Requirements
- iOS 11.0+
- Swift 4.2+
- Xcode 10.1+

## Installation
### CocoaPods
FloatingSideMenu is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "FloatingSideMenu"
```

## Documentation
 - <a href="https://github.com/LesGrob/FloatingSideMenu/blob/master/docs/index.html">Documentation Link</a>

## License
FloatingSideMenu is available under the MIT license. See the LICENSE file for more info.
