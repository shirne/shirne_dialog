# Shirne Dialog

A flutter package to use alert, toast, popup, snack etc. with customizable style in anywhere.

<a href="https://pub.dartlang.org/packages/shirne_dialog">
    <img src="https://img.shields.io/pub/v/shirne_dialog.svg" alt="pub package" />
</a>

## function

* toast
* alert
* confirm
* prompt [new]
* modal
* popup
* imagePreview
* snack
* loading

## Notice

You must initialize ShirneDialogTheme on theme.extensions in flutter version 3.0.0

## Usage

Direct usage
```

MyDialog.of(context).toast('tip message');

MyDialog.of(context).alert(Text('alert message'));

MyDialog.of(context).confirm(Text('alert message')).then((v){

});

MyDialog.of(context).popup(Text('popup contents'));

MyDialog.of(context).snack('tip');
```

initialize & usage
```
// initialize in mainApp's first page
MyDialog.initialize(context);

// Or use Mydialog.navigatorKey with MaterialApp
// and set theme for dialog
 MaterialApp(
    //...
    navigatorKey: MyDialog.navigatorKey,
    localizationsDelegates:[
        ShirneDialogLocalizations.delegate,

        // flutter locals see [https://docs.flutter.dev/development/accessibility-and-localization/internationalization]
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
    ],
    theme: ThemeData.light().copyWith(extensions: [const ShirneDialogTheme()]);
    //...
 );
 

// call in anywhere
MyDialog.confirm('aaa');
MyDialog.alert('test');
MyDialog.toase('test');
```

[Demo](https://www.shirne.com/demo/easydialog/)