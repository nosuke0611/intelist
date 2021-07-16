# ユーザー作成
50.times do |n|
name  = "testuser-#{n+1}"
email = "example-#{n+1}@railstutorial.org"
password = "password"
User.create!(name:                  name,
             email:                 email,
             password:              password,
             password_confirmation: password)
end

# リレーションシップ作成
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

# テストアイテム作成
10.times do |n|
  item_name = "example-item#{n+1}"
  Item.create!(item_name: item_name)
end

# テストタグ作成
10.times do |n|
  tag_name = "example-tag#{n+1}"
  Tag.create!(tag_name: tag_name)
end

# テスト投稿作成
10.times do |n|
  user = User.find(n+1)
  10.times do |i|
    item_id = i+1
    content = "example-content#{i+1}"
    tag_id = i+1
    post = user.posts.build(content: content)
    post.item_id = item_id
    post.tag_ids = tag_id
    post.save
  end
end