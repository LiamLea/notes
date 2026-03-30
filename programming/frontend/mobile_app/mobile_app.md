# Mobile App

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Mobile App](#mobile-app)
    - [Overview](#overview)
      - [1.deep link](#1deep-link)
        - [(1) what](#1-what)
        - [(2) how (iOS Universal Links and Android App Links)](#2-how-ios-universal-links-and-android-app-links)

<!-- /code_chunk_output -->


### Overview

#### 1.deep link

##### (1) what
a deep link takes you to a specific screen or piece of content inside a mobile app

##### (2) how (iOS Universal Links and Android App Links)

* The "Claims" in the App Code
    * have a file to say: I am officially claiming `spotify.com` and all its sub-links.
* The Registration on the phone
    * It scans that file and adds `spotify.com` to a local Private Registry of "Reserved Domains" on your phone
* Verification
    * The phone's OS (not the app!) reaches out to `https://spotify.com/.well-known/apple-app-site-association` (for iOS) or a similar file for Android.
* so when os see the link will forward to spotify app