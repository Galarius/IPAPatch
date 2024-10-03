# Tapped Out Notes

## Steps

1. Download decrypted ipa from https://decrypt.day/app/id498375892 (ver 4.69.5)
2. On Apple developer portal register a new bundle ID (it should preferably be of the same length as the original `com.ea.simpsonssocial.bv2`).
3. Replace `com.ea.simpsonssocial.bv2` with the new bundle ID in the `Tapped Out` executable using Hex Editor:
    3.1. Unzip `com.ea.simpsonssocial.bv2_4.69.5_und3fined.ipa`
    3.2. Upload `Payload/Tapped Out.app/Tapped Out` to https://hexed.it, search for `com.ea.simpsonssocial.bv2` and replace bytes. (alternatively use vim in xxd mode)
    3.3. Compress the app back to ipa while keeping the same structure.
4. Place modified `.ipa` to `Assets/` renaming it to `app.ipa`.
5. Update `com.apple.security.application-groups` in `IPAPatch-DummyApp/IPAPatch-DummyApp.entitlements`
6. Update all occurrences of `PRODUCT_BUNDLE_IDENTIFIER` in `IPAPatch.xcodeproj/project.pbxproj`
7. Update TeamID under `keychain-access-groups` in `IPAPatch-DummyApp/IPAPatch-DummyApp.entitlements`

(I'm using `gs` instead of `ea` in this project.)
