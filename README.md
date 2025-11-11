# viewHelper

Windows UI コントロール（ラジオボタン、チェックボックス）をカスタマイズするための Windows ネイティブ DLL です。

## ビルド方法

MSVC ツールチェーンが必要です。

**x86 版のビルド:**
```
nmake
```

**x64 版のビルド:**
```
nmake ARCH=x64
```

**クリーンアップ:**
```
nmake clean
```

ビルド成果物は `viewHelper_x86.dll` または `viewHelper_x64.dll` として出力されます。

## エクスポート関数

### ScRadioButton
```c
int ScRadioButton(HWND wnd)
```
ラジオボタンコントロールをサブクラス化し、黒背景に白テキストでカスタマイズします。

### ScCheckbox
```c
int ScCheckbox(HWND wnd)
```
チェックボックスコントロールをサブクラス化し、黒背景に白テキストでカスタマイズします。

### findRadioButtons
```c
char* findRadioButtons(HWND wnd)
```
指定されたウィンドウ内のすべてのラジオボタンのハンドルをカンマ区切りの文字列として返します。
戻り値は `releasePtr()` で解放する必要があります。

### releasePtr
```c
void releasePtr(char *p)
```
DLL が割り当てたメモリを解放します。`findRadioButtons()` の戻り値を解放する際に使用します。

### copyMemory
```c
void copyMemory(void *dest, void *src, size_t sz)
```
メモリをコピーします。

## ライセンス

MIT License
