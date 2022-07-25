
<p align="center">
    <a href="https://pub.dartlang.org/packages/shirne_dialog">
        <img src="https://img.shields.io/pub/v/shirne_dialog.svg" alt="pub package" />
    </a>
</p>

# Dialog

A package for flutter to use alert and toast within one line code.

## function

* toast
* alert
* confirm
* modal
* popup
* imagePreview
* snack
* loading

## Notice



## Usage

initialize 
```
// initialize in mainApp's first page
MyDialog.initialize(context);

// Or use Mydialog.navigatorKey with MaterialApp
// and set theme for dialog
 MaterialApp(
    //...
    navigatorKey: MyDialog.navigatorKey,
    theme: ThemeData.light().copyWith(extensions: [const ShirneDialogTheme()]);
    //...
 );
 

```
usage
```
// call in anywhere
MyDialog.confirm('aaa');
MyDialog.alert('test');
MyDialog.toase('test');

MyDialog.toast('tip message');

MyDialog.alert(Text('alert message'));

MyDialog.confirm(Text('alert message')).then((v){

});

MyDialog.popup(Text('popup contents'));

MyDialog.snack('tip');
```


[Demo](https://www.shirne.com/demo/easydialog/)