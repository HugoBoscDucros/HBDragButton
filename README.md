# HBDragButton
A draggable button easy to set in swift.
A drag button is a good way to ensure the user is voluntary doing a sensible action whithout using a confirmation alert


### Installation

The only file needed to use this button is **HBDragButton.swift**.
Just drag and drop it to your project folder.


### Instanciate

#### Using Interface Builder

Put a *UIView* in your *UIViewController*, reclass it as HBDragButton. In this view, put any object heriting from UIView and link it to *draggableAreaView* HBDragButton's IBOutlet. If you use an UIImageView make sure you've checked the > user interaction enable < option.

#### By code

Instanciate a HBDragButton has you do it for a UIView set his frame, and instanciate an object heriting from UIView has his draggableAreaView. Set the initial frame to draggableArea but Don't add any constraints. Their will be added by the setting's method.


### Settings

You need only one methode to set a HBDragButton.
```sh
func set(style:HBDragButtonStyle, endingStyle:HBDragButtonEndingStyle)
```

For exemple you can use it like that :
```sh
dragButton.set(HBDragButtonStyle.Slide, endingStyle:HBDragButtonEndingStyle.ComeBack)
```

you have different style of animation for the button.

#### Styles

HBDragButtonStyle is an enum containing two values in this version. it define the animation during user's dragging.

   - **.Drag** : the button's width is decreasing with the draggableAreaView's dragging
   - **.Slide** : only the draggableAreaView is movving when user is dragging it

#### endingStyles

HBDragButtonEndingStyle is an enum containing four values in this version. it define the animation happening when user dragging right the draggableAreaView to the right border of the dragButton. It's corresponding to the action callback.

   - **.ComeBack**
   - **.Block**
   - **.BlogAndGoToCenter**
   - **.Desapear**


### Action callBack

The action callBack is call when the user drag right the draggableAreaView to the dragButton right border. To use it, you have to define the dragButton *delegate*. This delegate has to respect **HBDragButtonDelegate** protocol.

