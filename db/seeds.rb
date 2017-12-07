# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Comment.destroy_all
Category.destroy_all

User.destroy_all
user1 = User.create([{name: "Joe Westersund", email: "westersund.joe@deq.state.or.us", password: "JoeTest", password_confirmation: "JoeTest", admin:true}])

CategoryStatusType.destroy_all
category_status_types = CategoryStatusType.create([{ status_text: "needs review", order_in_list: 1},{ status_text: "under review", order_in_list: 2},{ status_text: "review complete", order_in_list: 3},{ status_text: "other, see action needed", order_in_list: 4}])

CommentStatusType.destroy_all
comment_status_types = CommentStatusType.create([{ status_text: "needs review", order_in_list: 1},{ status_text: "under review", order_in_list: 2},{ status_text: "review complete", order_in_list: 3},{ status_text: "other, see action needed", order_in_list: 4}])

categories = Category.create([{category_name: "test comments", category_status_type_id: CategoryStatusType.first.id, order_in_list: 1},{category_name: "should set lower RALs", category_status_type_id: CategoryStatusType.last.id, order_in_list: 2}])