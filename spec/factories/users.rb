FactoryBot.define do

  factory :user_simon_ninon, class: User do
    login           "Cylix"
    name            "Simon Ninon"
    email           "simon.ninon@gmail.com"
    avatar_url      "pic.com/cylix"
    github_ext_id   100
  end

  factory :user_mengying_li, class: User do
    login           "chasing_future"
    name            "Mengying Li"
    email           "mengying.li@gmail.com"
    avatar_url      "pic.com/chasing_future"
    github_ext_id   101
  end

end
