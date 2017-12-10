FactoryBot.define do

  factory :user_simon_ninon, class: User do
    name            "Simon Ninon"
    email           "simon.ninon@gmail.com"
    github_ext_id   "100"
  end

  factory :user_mengying_li, class: User do
    name            "Mengying Li"
    email           "mengying.li@gmail.com"
    github_ext_id   "101"
  end

end
