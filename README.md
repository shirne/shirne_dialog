
<p align="center">
    <a href="https://pub.dartlang.org/packages/shirne_dialog">
        <img src="https://img.shields.io/pub/v/shirne_dialog.svg" alt="pub package" />
    </a>
</p>

# dialog

A package for flutter to use alert and toast within one line code.

## usage

```
MyDialog.of(context).toast('tip message');

MyDialog.of(context).alert(Text('alert message'));

MyDialog.of(context).confirm(Text('alert message')).then((v){

});

MyDialog.of(context).popup(Text('popup contents'));

MyDialog.of(context).snack('tip');
```

[Demo](https://www.shirne.com/demo/easydialog/)