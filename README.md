# redmine_issue_assigned_history

This is a plugin for [Redmine](http://www.redmine.org) that provides an API with the assigned history of the person in charge of the issue.

## Installation

Clone this repository to the Redmine plugin directory.

```
cd {RAILS_ROOT}/plugins
git clone https://github.com/onozaty/redmine_issue_assigned_history.git
```

## Information provided by the API

The information will be available at the following URL.

* {Redmine URL Root}/issue_assigned_histories.json

The information you can get is as follows.

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

The `old_assigned_to` is the assigned person before the change and the `new_assigned_to` is the assigned person after the change. The `changed_on` is the timing of the change.

The `issue` and `project` are not the information at the time of the change, but the current information.

The default is the last 5 minutes of history, but by specifying the `period` as a query parameter, you can get up to the last 60 minutes of history.

* {Redmine URL Root}/issue_assigned_histories.json?period=60

## Notes on using the API

As with the other APIs, you will need the following.

* https://www.redmine.org/projects/redmine/wiki/rest_api#Authentication

## License

MIT

## Author

[onozaty](https://github.com/onozaty)
