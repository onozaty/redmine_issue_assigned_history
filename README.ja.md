# redmine_issue_assigned_history

チケットの担当者の変更履歴をAPIとして提供する[Redmine](http://www.redmine.org)のプラグインです。

## インストール方法

Redmineのプラグインディレクトリに、本リポジトリをクローンします。

```
cd {RAILS_ROOT}/plugins
git clone https://github.com/onozaty/redmine_issue_assigned_history.git
```

## APIで提供される情報

下記URLで情報が取得できるようになります。

* {Redmine URL Root}/issue_assigned_histories.json

取得できる情報は下記のようなイメージです。

```json
{
    "histories": [
        {
            "type": "change",
            "issue": {
                "id": 10,
                "subject": "YYY",
                "status_id": 5,
                "status_name": "Closed"
            },
            "journal_id": 17,
            "changed_on": "2020-11-29T13:50:24Z",
            "old_assigned_to": {
                "id": 6,
                "login": "tanaka",
                "firstname": "Hanako",
                "lastname": "Tanaka"
            },
            "new_assigned_to": {
                "id": 5,
                "login": "yamada",
                "firstname": "Taro",
                "lastname": "Yamada"
            },
            "project": {
                "id": 1,
                "identifier": "a"
            }
        },
        {
            "type": "change",
            "issue": {
                "id": 10,
                "subject": "YYY",
                "status_id": 5,
                "status_name": "Closed"
            },
            "journal_id": 16,
            "changed_on": "2020-11-29T13:48:13Z",
            "old_assigned_to": null,
            "new_assigned_to": {
                "id": 6,
                "login": "tanaka",
                "firstname": "Hanako",
                "lastname": "Tanaka"
            },
            "project": {
                "id": 1,
                "identifier": "a"
            }
        },
        {
            "type": "new",
            "issue": {
                "id": 9,
                "subject": "XXX",
                "status_id": 1,
                "status_name": "New"
            },
            "journal_id": null,
            "changed_on": "2020-11-29T13:47:49Z",
            "old_assigned_to": null,
            "new_assigned_to": {
                "id": 1,
                "login": "admin",
                "firstname": "Redmine",
                "lastname": "Admin"
            },
            "project": {
                "id": 1,
                "identifier": "a"
            }
        }
    ],
    "total_count": 3
}
```

`old_assigned_to`に変更前の担当者、`new_assigned_to`に変更後の担当者の情報が入ります。`changed_on`は変更されたタイミングとなります。

`issue`、`project` は変更時の情報ではなく、現在の情報になります。

デフォルトは過去5分間の履歴となりますが、クエリパラメータとして`period`を指定することで、最大で過去60分間の履歴が取得可能になります。

* {Redmine URL Root}/issue_assigned_histories.json?period=60

## APIを利用する上での注意点

他のAPIと同様に下記が必要となります。

* https://www.redmine.org/projects/redmine/wiki/rest_api#Authentication

## ライセンス

GNU General Public License v2.0

## 作者

[onozaty](https://github.com/onozaty)
