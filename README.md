# INTELIST

![toppage](https://user-images.githubusercontent.com/61620946/132851617-8251a267-a536-4c8c-81f4-e2b5260a45c8.gif)

## アプリ概要
[「INTELIST（いんたりすと）」](https://inte-list.com)は気になるものを何でもかんでもリスト化して管理・シェアするためのSNSアプリです。

- 気になるものをジャンル問わず投稿し、友人とシェアできる
- リスト化しておくことで後から確認できる
- 他のユーザーの興味をランキングで確認し、トレンドを把握できる

といった特徴があります。
<br>

## 製作背景
このご時世の中、「落ち着いたら〇〇行ってみよう」「〇〇って漫画がおすすめ」といったような会話をすることが増えたのですが、いかんせん増えすぎたせいで<br>
**「行きたいって話してたのどこだっけ…」**<br>
**「勧められたのなんだっけ…」**<br>
**「この話誰としたんだっけ…」**<br>
とド忘れしてしまうものが出てきました。そのような会話自体もLineやDiscordなどの様々な媒体を使用していたり、通話で話しただけだったりと後から拾いなおすのが難しく、せっかくの楽しみな情報が抜け落ちてしまうのがもったいなかったので、**このド忘れを解消する方法として製作したのがINTELISTです。**<br>
記録するにあたり、飲食店、読書、音楽などに特化したサービスは比較的すぐ見つかったのですが、**ざっくばらんに何でもかんでも記録＆シェアするというサービス**は見当たらないようだったので、転職用のポートフォリオ目的も兼ねて自分で製作してみた次第です。
<br>
<br>

## URL
+ URL： https://inte-list.com
+ ゲストログイン機能でとりあえず見るだけというのも可能です。
<br>
<br>

# アプリの機能紹介
## 機能一覧
| #  | 機能名             | 説明 |
|:--:|:-------------------|:---|
| 1  | ユーザー機能        | 新規登録、登録内容変更、アバター画像設定、ログイン、ログアウト。 |
| 2  | ゲストログイン機能   | 登録せずゲストとしてアプリを使用可能。ゲストユーザーは削除/編集不可。 |
| 3  | フォロー機能  　　　 | ユーザーをフォロー可能（Ajax）。<br>原則はフォローしているユーザーのみを自身のタイムラインに表示。 |
| 4  | 投稿機能            | 投稿、編集、削除。投稿にはアイテム/コメント/参考URL/タグを登録可能。<br>参考URLを入力した場合は外部APIを使用してリンクサムネイルを自動作成。<br>投稿時に非公開設定をした場合は自分以外は閲覧不可。 |
| 5  | 投稿へのいいね機能   | 投稿をいいねが可能（Ajax）。<br>いいねした投稿をマイページで一覧表示。 |
| 6  | 投稿へのコメント機能 | 投稿へのコメント追加/削除が可能（Ajax）。<br>コメントした投稿をマイページで一覧表示。 |
| 7  | タグ付け機能        | 投稿へのタグ登録/編集/削除が可能。タイムライン等で表示されているタグをクリックすると、同じタグを含むアイテム一覧を表示。 |
| 8  | マイアイテム機能    | 自分の投稿したアイテムを一覧表示。<br>完了/未完了を登録し、ステータスで絞り込みが可能（Ajax）。 |
| 9  | 検索機能           | ユーザー一覧、アイテム一覧、タグ一覧、マイアイテム一覧の絞り込み検索が可能（Ajax）。 |
| 10  | ソート機能         | ユーザー一覧、アイテム一覧、タグ一覧、マイアイテム一覧では一部項目による昇順/降順ソートが可能。<br>検索条件がある場合は検索結果を引き継いでソート（Ajax）。 |
| 11 | ランキング機能      | 全ユーザーorフォローのみ、期間を指定した投稿数上位10位のランキングを一覧表示。 |
| 12 | 通知機能           | 他のユーザーからフォロー、いいね、コメントを受けたことがわかる通知を一覧表示。新しい通知がある場合、ヘッダーの通知欄にバッチを表示。 |
<br>

## 使用イメージ(一部機能抜粋。番号は機能一覧の#と同一)
### 4. 投稿機能
![postmodal](https://user-images.githubusercontent.com/61620946/132853755-0622d149-d432-4062-aa1e-9c572291e551.gif)
+ 「新規投稿」ボタンから投稿画面を開き、気になるアイテムを登録します。<br>
（投稿画面はBootstrapのモーダル機能を利用しています。）
+ 投稿にはアイテム名、投稿内容（コメント）、参考URL、タグ名を登録できます。
+ 参考URLを入力した場合、投稿完了時に自動的にサムネイルを作成します。
+ タグはエンターを入力することでバッチ化します（tagsinputを使用）。
<br>

### 7. タグ付け機能
![tagimage](https://user-images.githubusercontent.com/61620946/132854363-6d53b944-c592-4ccb-9442-6e6e00e6f8cc.gif)
+ 前述の通り、投稿時にはタグを登録でき、タグを利用することで似たジャンルのアイテムを探すことができます。
+ 画面に表示されているタグバッチをクリックすると同名タグを含むアイテム一覧を表示します。<br>
（上のgifではボドゲ→ゲームの順でタグをクリックし、絞り込みを行っています）
+ 投稿作成時にはタグ名称でTagテーブルを検索し、同名タグがあれば既存レコードを使用、なければ新規に作成します。
<br>

### 8. マイアイテム機能
![myitem](https://user-images.githubusercontent.com/61620946/132854936-f5830a83-d040-4c2f-be1f-6e862f7120f0.gif)
+ ヘッダー → アカウント → 「マイアイテム一覧画面」 からは、自分が登録したアイテムをリストで確認できます。
+ アイテムごとに完了済/未完了のステータスを設定することができ、実際に行ってみた場合などには完了済にできます。
+ マイアイテム一覧ではステータスごとで絞り込みを行えるため、まだ行っていないアイテムだけを確認することもできます。
<br>

### 9. 検索機能
![search](https://user-images.githubusercontent.com/61620946/132855069-91ac8e37-20e9-4ca4-ac01-31e2ae02e554.gif)
+ ユーザー一覧/アイテム一覧/マイアイテム一覧では複数ワードによる絞り込み検索ができます。<br>
（上のgifではアイテム一覧ページにて、タグ：ボドゲ、アイテム名：魔女、にて絞り込みを行っています。例ではあえて２ステップ踏んでいますが、もちろん１ステップでも可能です。）
+ 検索は原則Like検索で、複数ワードがある場合はAND検索します。
+ リセットボタンを押すと検索が解除されます。
<br>

### 11. ランキング機能
![ranking](https://user-images.githubusercontent.com/61620946/132855461-a2254c7e-2754-40e7-a9d1-3ae0b53f8b0a.gif)
+ ランキングページで他のユーザーに人気のものをチェックできます。
+ 全ユーザー/フォローのみ、週間/月間/全期間での条件ごとで絞り込んだランキングを表示できます。<br>
（上のgifでは「全ユーザー&週間」→「全ユーザー&月間」→「フォローのみ&月間」と切り替えています。）
<br>
<br>

# 使用技術/設計等
## 言語/ツール等
### フロントエンド
+ HTML
+ Sass
+ JavaScript（jQuery 3.6.0）
+ Bootstrap 4.6.0

### バックエンド
+ Ruby 3.0.2
+ Ruby on Rails 6.1.4
+ MySQL 8.0.23
+ 各種gem

| gem名| 用途（記載している#は機能一覧の#を表します） |
|:- |:- |
| devise | #1のユーザー機能に使用。 |
| carrierwave<br>mini_magick<br>fog-aws | #1のアバター画像設定に使用。fog-awsを使用し保存先をS3バケットに設定。 |
| httparty | #4のサムネイル作成機能において、外部APIへのデータ送信およびレスポンスのHash変換に使用。 |
| kaminari | 各種ページのページネーションに使用。 |
| counter_culture | 一部モデルの件数を取得する際のN+1問題回避のため使用。 |
| bullet | N+1問題の検出に使用。 |
| better_errors<br>binding_of_caller |  エラー画面を見やすくするために使用 |
| rspec<br>factory_bot_rails<br>rubocop | テストに使用 |

### インフラ
+ 本番環境
    + AWS（VPC、EC2、RDS、S3、Route53、ALB、ACM、IAM）
    + Nginx 1.20.0
    + Unicorn 6.0.0
    + Capistrano 3.16.0
    + CircleCI 2.1
+ 開発環境
    + Docker 20.10.8
    + docker-compose 1.29.2

### その他のツール
+ git 2.25.1 / GitHub
<br>


## インフラ構成図
![intelist_infra](https://user-images.githubusercontent.com/61620946/132853062-a910be1a-8587-4e80-ace4-487c606f9d32.jpg)
+ ローカルではWSL2とDocker、docker-composeを使用して開発しています。
+ ローカルで開発した内容をGitHubへpush→CircleCIで自動テスト（RuboCop&RSpec）→CapistranoでEC2上に自動デプロイという流れを経て公開しています。
+ ユーザーからの接続はRoute53を使用して独自ドメイン化、ALBとACMを使用して常時SSL接続を使用するよう設定しています。
+ EC2内ではwebサーバーにNginx、アプリケーションサーバーにUnicornを使用しています。
+ ユーザーのアバター画像用にS3バケットを使用しています。
+ 投稿時のサムネイル作成用に外部サービスlinkpreviewのAPIを使用しています。
<br>

## ER図
![intelist_er_rev3](https://user-images.githubusercontent.com/61620946/137347068-90866027-6620-4311-a2a1-f3bd9a015689.jpg)
+ 投稿時にはアイテム名を入力しますが、入力されたアイテム名でItemテーブルを検索し、同名アイテムが見つかれば既存レコードを使用、見つからなければ新規レコードを作成します。
+ 投稿時にはタグ名を入力できますが、PostTagMapテーブルを中間テーブルとたTagテーブルを入力されたタグ名で検索し、同様に既存レコード使用or新規レコード作成を行います。
+ どちらのテーブルも同名のレコードが存在する場合はそれを引用、同名が見つからない場合のみ新規レコードを作成することでデータ数が無駄に増加するのを抑えています。
<br>
<br>

# 工夫した点
### 非同期通信（Ajax）
各種ページに非同期通信を採用し、リロードによるストレスを軽減するよう心がけました。
  + フォロー・いいね・コメントのAjax化
  + 各種ページのタブ切替のAjax化
  + 検索結果表示のAjax化

### サムネイルの自動生成（外部API）
投稿作成時に入力した参考URLをもとに、サムネイルを自動生成する機能を実装しました。
+ 背景として、アイテム名を見ただけでは他のユーザーが面白そうかイメージがわかないため、何か画像が欲しいと考えました。
+ とはいえ投稿者がいちいち画像を用意して添付するのは手間が増えすぎるため、[linkpreview](https://www.linkpreview.net/)という外部APIを利用しています。
+ このAPIでは投稿者が入力したURLをもとにサムネイル用のデータをJSONで返す機能が利用できるため、メソッドに組み込んでPostテーブルにサムネイル関連情報を保存→viewで表示できるよう実装しました。
+ 小さな工夫として、サムネイル作成に少し時間がかかるためローディングサークルを表示して待機時間と分かるようにしました。

### ランキング機能
利用者に人気のあるアイテムのトレンドが知れるようランキング機能を設けました。
+ タイムラインだけではフォローしている知人の興味しかわかりませんが、ランキングにより全く別傾向のものにも出会えます。
+ 全ユーザー/フォローのみ、週間/月間/全期間での条件ごとでランキングを表示できます。
+ ここから気になったユーザーをフォローするなどして、面白いものをどんどん見つけられます。
