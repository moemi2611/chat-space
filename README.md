Chat-space DB設計

### groupsテーブル

|Column|Type|Options|
|------|----|-------|
|id|integer|
|group_name|string|null: false|
### Association
- belongs_to :group
- has_many :groups_users
- has_many :messages
- has_many :users



### usersテーブル

|Column|Type|Options|
|------|----|-------|
|id|integer|null: false|
|email|string|null: false|
|password|string|null: false|
|username|string|null: false|
### Association
- belongs_to :user
- has_many :groups_users
- has_many :groups
- has_many :messages



### groups_usersテーブル

|Column|Type|Options|
|------|----|-------|
|user_id|integer|null: false, foreign_key: true|
|group_id|integer|null: false, foreign_key: true|
### Association
- belongs_to :group
- belongs_to :user


### messagesテーブル

|Column|Type|Options|
|------|----|-------|
|body|text|null: false|
|image|string|null: false|
|username|string|null: false|
|group_name|string|null: false|
### Association
- belongs_to :group
- belongs_to :user