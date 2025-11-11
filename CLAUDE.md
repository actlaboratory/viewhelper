# CLAUDE.md

このファイルは、このリポジトリでコードを操作する際に Claude Code (claude.ai/code) にガイダンスを提供します。

## プロジェクト概要

viewHelper は Windows ネイティブ DLL で、Windows UI コントロール（特にラジオボタンとチェックボックス）をカスタマイズするためのヘルパー関数を提供します。この DLL は外部アプリケーション（おそらくアクセシビリティツール）から呼び出され、ウィンドウプロシージャのサブクラス化を通じてコントロールの外観と動作を変更するように設計されています。

## ビルドシステム

プロジェクトは MSVC コンパイラで `nmake`（Microsoft の make ユーティリティ）を使用します：

**DLL のビルド（デフォルトは x86）：**
```
nmake
```

**x64 用のビルド：**
```
nmake ARCH=x64
```

**ビルド成果物のクリーンアップ：**
```
nmake clean
```

**出力：** アーキテクチャに応じて `viewHelper_x86.dll` または `viewHelper_x64.dll`

**コンパイラフラグ：**
- `/O2` - 最適化有効
- `/EHsc` - 例外処理
- `/W3` - 警告レベル 3
- `/wd4819` - 警告 4819（文字エンコーディング）を無効化

## アーキテクチャ

### DLL エントリポイント

すべてのエクスポート関数は `dll_funcdef` マクロ（defs.h から）を使用して定義され、`extern "C" __declspec(dllexport)` に展開されます。

**エクスポート関数：**
- `ScRadioButton(HWND)` - ラジオボタンコントロールをサブクラス化（ctlcolor.cpp:44）
- `ScCheckbox(HWND)` - チェックボックスコントロールをサブクラス化（ctlcolor.cpp:51）
- `findRadioButtons(HWND)` - ウィンドウ階層内のすべてのラジオボタンコントロールを検索（findradiobuttons.cpp:35）
- `releasePtr(char*)` - DLL が割り当てたメモリを解放（common.cpp:7）
- `copyMemory(void*, void*, size_t)` - メモリコピーのラッパー（common.cpp:12）

### ウィンドウプロシージャのサブクラス化

DLL は `WM_CTLCOLORSTATIC` メッセージをインターセプトしてコントロールの外観をカスタマイズします：
- 背景を黒（RGB 0,0,0）に設定
- テキスト色を白（RGB 255,255,255）に設定
- 透明な背景モードを使用

**主要コンポーネント：**
- `RadioButtonProc` / `CheckboxProc` - メッセージをインターセプトするカスタムウィンドウプロシージャ
- `DefRadioButtonProc` / `DefCheckboxProc` - 委譲用に保存された元のウィンドウプロシージャ
- `bkBrush` / `whBrush` - レンダリング用のグローバルブラシオブジェクト（`initCtlcolor()`/`freeCtlcolor()` で初期化/解放）

### DLL ライフサイクル

`DllMain` が初期化とクリーンアップを処理します：
- `DLL_PROCESS_ATTACH`: COM（`CoInitialize`）とコントロールカラーリソースを初期化
- `DLL_PROCESS_DETACH`: COM とブラシオブジェクトをクリーンアップ

### メモリ管理

`findRadioButtons()` 関数は戻り値のためにメモリを割り当てます。呼び出し側はメモリリークを防ぐために `releasePtr()` を**必ず**呼び出す必要があります。

## 開発ノート

- これは Windows 専用コードです（Win32 API を広範に使用）
- MSVC ツールチェーン（cl.exe、link.exe）が必要
- UNICODE 文字セットを使用
- ウィンドウプロシージャのサブクラス化は元のプロシージャをグローバルに 1 セットのみ保存（複数の同時サブクラス化操作に対してスレッドセーフではない）
- `findRadioButtons` 関数は `BS_RADIOBUTTON` スタイルをチェックしてラジオボタンを識別（スタイル値 % 16 == 9）
