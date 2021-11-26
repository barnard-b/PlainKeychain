# PlainKeychain
A really simple key-value wrapper for keychain.

## Features
✅ Key-value pairs using `kSecClassGenericPassword`.

❌ Internet passwords (`kSecClassInternetPassword`).

❌ Biometric authentication (TouchID or FaceID).

❌ Cross-app access with `kSecAttrAccessGroup`.


## Example
```swift
let keychain = PlainKeychain(service: "MyApp")

try keychain.setItem("John", forKey: "nickname")

try keychain.getItem(forKey: "nickname") // John

try keychain.deleteItem(forKey: "nickname")
```
