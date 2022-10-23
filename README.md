# Avatar

An iOS package for automatic creating and editing avatars.

![Avatar1](./Docs/1.png)
![Avatar2](./Docs/2.png)
![Avatar3](./Docs/3.png)
![Avatar4](./Docs/4.png)
![Avatar5](./Docs/5.png)    

### Avatar editing
```swift
#import Avatar
...
let vc = EditAvatarViewController.instantiate()
vc.avatar = Avatar.decompress(value: avatarId) // provide existing avatar id or some random int64 value
vc.delegate = self
self.present(vc, animated: true, completion: nil)
```
### Show avatar
Put AvatarView into your layout (storyboard or xib) and set avatar id to it:
```swift
@IBOutlet weak var avatarView: AvatarView!
...
avatarView.avatarId = avatarId
```
![AvatarView](./Docs/AvatarView.png)

### Installation

