# DigidentityTestCase

This project is a solution for the **Test Case Mobile Development (Android/iOS)** assignment.  

## Overview
A mobile client that displays a catalog of items from a RESTful JSON API. Each item includes:  

- Photo (URL)  
- Description (string)  
- Confidence value (float)  
- ID  

The app supports:  

- Listing all items with details  
- Detail view on item selection  
- Pull-to-refresh and infinite scrolling  
- Caching between launches  
- Device orientation changes  
- Basic unit tests  

## Configuration
Add your unique API key in `Config.plist` under the key `AUTH_KEY`:

```xml
<key>AUTH_KEY</key>
<string>PROVIDE-YOUR-KEY</string>
```
