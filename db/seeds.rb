user = User.new(username: "tester01", password: "test01", password_confirmation: "test01", email: "iarkeus@gmail.com", ip: "134.134.134.134", signature: "This is a motherfucking signature", avatar: "http://s13.postimage.org/fnei7jztv/autumn.png")
user.save!

character = Character.new(user_id: 1, active: true, name: "Arkeus")
character.save!

character = Character.new(user_id: 1, active: false, name: "Kal")
character.save!

ForumCategory.new(name: "General Chat", description: "Chat about anything to do with Trisphere.").save!
ForumCategory.new(name: "Help", description: "Got a question? Ask for help here!").save!