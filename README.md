# TryViewModelWithSharedState

MVVMアーキテクチャにおいて、「画面間で状態を共有したいとき」って結局どうするのがいいのだっけ？というのがわからなかったので、サンプルアプリを作成して色々試してみる。
なおここでは「Reduxパターンは利用しない」という前提で考える

## サンプルアプリ

- フォルダとファイルの概念がある
- フォルダを選択すると、そのフォルダ内の画面に遷移する
- ファイルを選択すると、ファイルの選択状態がon/offになる
- 画面間でファイルの選択状態を共有したい（画面下のボタン押下で、現状の選択中のファイルのIDを表示する）

|画面1|画面2|画面3|
|--|--|--|
|![Simulator Screen Shot - iPhone 12 - 2021-10-17 at 13 08 29](https://user-images.githubusercontent.com/2215663/137610857-0dcc0c72-df95-4f91-8638-b4f1f21eacdb.png)|![Simulator Screen Shot - iPhone 12 - 2021-10-17 at 13 08 34](https://user-images.githubusercontent.com/2215663/137610853-325f02a3-fe28-4fe4-8c9c-61c6b6dd4a83.png)|![Simulator Screen Shot - iPhone 12 - 2021-10-17 at 13 08 36](https://user-images.githubusercontent.com/2215663/137610851-5dccc55c-7308-4cf7-a585-b2fcef09a21c.png)|

## パターン

### パターン1: クロージャを利用したパターン

https://github.com/ushisantoasobu/TryViewModelWithSharedState/pull/5/files

#### 概要

TODO

#### 俺はこう思ったっす

TODO

### パターン2: シングルトンを利用したパターン

https://github.com/ushisantoasobu/TryViewModelWithSharedState/pull/4/files

#### 概要

TODO

#### 俺はこう思ったっす

TODO

### パターン3: PublishRelayを次の画面に渡していくパターン

https://github.com/ushisantoasobu/TryViewModelWithSharedState/pull/3/files

#### 概要

TODO

#### 俺はこう思ったっす

TODO

### パターン4: NotificationCenterを利用したパターン 

https://github.com/ushisantoasobu/TryViewModelWithSharedState/pull/2/files

#### 概要

TODO

#### 俺はこう思ったっす

TODO
