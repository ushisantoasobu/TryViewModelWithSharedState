# TryViewModelWithSharedState

MVVMアーキテクチャにおいて、「画面間で状態を共有したいとき」って結局どうするのがいいのだっけ？というのがわからなかったので、サンプルアプリを作成して色々試してみる。
なおここでは「Reduxパターンは利用しない」という前提で考える

## サンプルアプリ

- フォルダとファイルの概念がある
- フォルダを選択すると、そのフォルダ内の画面に遷移する
- ファイルを選択すると、ファイルの選択状態がon/offになる
- 画面間でファイルの選択状態を共有したい（画面下のボタン押下で、現状の選択中のファイルのIDを表示する）

|画面1|画面2|画面3|ボタン押下時|
|--|--|--|--|
|![Simulator Screen Shot - iPhone 12 - 2021-10-17 at 13 08 29](https://user-images.githubusercontent.com/2215663/137610857-0dcc0c72-df95-4f91-8638-b4f1f21eacdb.png)|![Simulator Screen Shot - iPhone 12 - 2021-10-17 at 13 08 34](https://user-images.githubusercontent.com/2215663/137610853-325f02a3-fe28-4fe4-8c9c-61c6b6dd4a83.png)|![Simulator Screen Shot - iPhone 12 - 2021-10-17 at 13 08 36](https://user-images.githubusercontent.com/2215663/137610851-5dccc55c-7308-4cf7-a585-b2fcef09a21c.png)|![Simulator Screen Shot - iPhone 12 - 2021-10-17 at 13 21 00](https://user-images.githubusercontent.com/2215663/137611146-9eff113e-8d2d-4fd7-81b0-5f43bc404881.png)|

⚠️ 画面間で状態を共有したいときの方法の調査が目的だが、今回のアプリは「同一ViewControllerでの遷移」「どの画面でも共有された状態を確認したい」という要素があって、ここら辺の事情が変わるとそれぞれのパターンのメリット・デメリットが出てくるかもしれないし別のパターンも出てくるかもしれない

## パターン

### パターン1: クロージャを利用したパターン

https://github.com/ushisantoasobu/TryViewModelWithSharedState/pull/5/files

#### 概要

遷移後の画面からクロージャで最新の状態を受け取る

#### 俺はこう思ったっす

- 複数の異なるViewControllerが登場するようなケースだと、それぞれにクロージャを設定しなくちゃいけないので大変そう

### パターン2: シングルトンを利用したパターン

https://github.com/ushisantoasobu/TryViewModelWithSharedState/pull/4/files

#### 概要

共有したい状態をシングルトンで管理してしまう

#### 俺はこう思ったっす

- 基本的にシングルトンパターンは利用したくない。が、iOS開発でもう当たり前になってきた「モジュール化」をすればその単位次第ではシングルトンもありなのか？ 🤔
- シングルトンのものをビューモデルにDIしてあげても良いのか？どちらがいいだろう？ 🤔

### パターン3: PublishRelayを次の画面に渡していくパターン

https://github.com/ushisantoasobu/TryViewModelWithSharedState/pull/3/files

#### 概要

遷移後の画面からRxのストリームでファイルの選択状態を管理する

#### 俺はこう思ったっす

- 「パターン1: クロージャを利用したパターン」とほぼ同じと考えて良さそう

### パターン4: NotificationCenterを利用したパターン 

https://github.com/ushisantoasobu/TryViewModelWithSharedState/pull/2/files

#### 概要

- ファイルの選択状態をNotificationCenterでブロードキャストして、そちらを受け取ることで管理する

#### 俺はこう思ったっす

- 「パターン2: シングルトンを利用したパターン」同様、モジュール化されてる場合などであれば悪くはなさそう？？ 🤔
- NotificationCenterはCombine使った書き方が書けるなら少し良くなりそう（現時点で自分の業務で開発しているアプリのサポートOSバージョンが12ということもあり使ってない）
