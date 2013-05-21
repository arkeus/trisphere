user = User.new(username: "arkeus", password: "password", password_confirmation: "password", email: "iarkeus@gmail.com", ip: "134.134.134.134")
user.save!

character = Character.new(user_id: 1, active: true, name: "Arkeus")
character.save!

ForumCategory.new(name: "General Chat", description: "Chat about anything to do with Trisphere.").save!
ForumCategory.new(name: "Help", description: "Got a question? Ask for help here!").save!