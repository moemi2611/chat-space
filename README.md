Chat-space DB設計

### groupsテーブル

|Column|Type|Options|
|------|----|-------|
|id|integer|
|name|string|null: false|
### Association
- has_many :groups_users
- has_many :messages
- has_many :users, through: groups_users



### usersテーブル

|Column|Type|Options|
|------|----|-------|
|id|integer|null: false|
|email|string|null: false|
|password|string|null: false|
|name|string|null: false|
### Association
- has_many :groups_users
- has_many :groups, through: groups_users
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
|body|text|
|image|string|
|user_id|integer|null: false, foreign_key: true|
|group_id|integer|null: false, foreign_key: true|
### Association
- belongs_to :group
- belongs_to :user