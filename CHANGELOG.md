## 0.4.5
* Fix `Scrollable.of()` bug in Flutter 3.7.

## 0.4.4
* Removes default paragraph indent of 3.5em

## 0.4.3
* Allow to call `setText()` on headless controller (when detached from UI, i.e.: inside `initState()` method).

## 0.4.2
* Fixes bug: on web the hint text doesn't disappear when `setText()` is called

## 0.4.1
* Adds "Ok" (reset) button to clear controller faults, without having to re-init.
* Exposes the `fault` field of type [Exception?]
* Adds `clearFault` method to clear the fault programmatically 

## 0.4.0 - Stable
* Upgrade to `webview_flutter: ^4.0.1`
* Fix `PointerInterceptor` causing incorrect rendering on web platform.

## 0.3.0 - Stable
* revert to webview 3.0.4
* lints

## 0.2.3
* add assets subfolder

## 0.2.2
* Improve HTML escaping


## 0.2.1
* Fix null pointer exception on native

## 0.2.0
* migrate `webview_flutter` package from `^3.0.4` to `^4.0.1`

## 0.1.0-dev.5
* minor refactorings

## 0.1.0-dev.4
* debug VTT injection and UI

## 0.1.0-dev.3

* resolve 'web-only' lint in web mixin
## 0.1.0-dev.1

* Initial release.
