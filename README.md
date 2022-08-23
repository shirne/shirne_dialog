# Shirne Dialog 2

A flutter package to use alert, confirm, prompt, toast, popup, snack, imagePreview, loading etc. with customizable style in anywhere.

<a href="https://pub.dev/packages/shirne_dialog2">
    <img src="https://img.shields.io/pub/v/shirne_dialog2.svg" alt="pub package" />
</a>

## Note

This is an older version of [ShirneDialog](https://pub.dev/packages/shirne_dialog), recommand to upgrade with that new version.

## function

* toast
* alert
* confirm
* modal
* popup
* imagePreview
* snack
* loading

## preview

[Online Demo](https://www.shirne.com/demo/easydialog/)

## usage

Direct use
```
MyDialog.of(context).toast('tip message');

MyDialog.of(context).alert(Text('alert message'));

MyDialog.of(context).confirm(Text('alert message')).then((v){

});

MyDialog.of(context).popup(Text('popup contents'));

MyDialog.of(context).snack('tip');
```

Or initialize and use
```

// Use Mydialog.navigatorKey with MaterialApp Or CupertinoApp
MaterialApp(
    //...
    navigatorKey: MyDialog.navigatorKey,
    //...
);

// Or initialize before use [do not recommand]
MyDialog.initialize(context,MyDialogSetting());
 
// call in anywhere
MyDialog.confirm('aaa');
MyDialog.alert('test');
MyDialog.toase('test');

```
