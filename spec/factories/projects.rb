FactoryBot.define do

  factory :project_cpp_redis, class: Project do
    slug            "cpp-redis"
    name            "cpp redis"
    description     "C++11 Redis client"
    repository_url  "https://github.com/cylix/cpp_redis"
    git_url         "git@github.com:Cylix/cpp_redis.git"
    homepage_url    "https://cylix.github.io/cpp_redis"

    # associations
    owner           { User.where(github_ext_id: FactoryBot::build(:user_simon_ninon).github_ext_id).first || FactoryBot::create(:user_simon_ninon) }
  end

  factory :project_tacopie, class: Project do
    slug            "tacopie"
    name            "tacopie"
    description     "C++11 TCP client & server"
    repository_url  "https://github.com/cylix/tacopie"
    git_url         "git@github.com:Cylix/tacopie.git"
    homepage_url    "https://cylix.github.io/tacopie"

    # associations
    owner           { User.where(github_ext_id: FactoryBot::build(:user_simon_ninon).github_ext_id).first || FactoryBot::create(:user_simon_ninon) }
  end

  factory :project_cse_110, class: Project do
    slug            "cse-110"
    name            "CSE 110"
    description     "CSE 110 project, FriendZoned"
    repository_url  "https://github.com/chasing_future/cse-110"
    git_url         "git@github.com:chasing_future/cse-110.git"
    homepage_url    "https://github.com/chasing_future/cse-110"

    # associations
    owner           { User.where(github_ext_id: FactoryBot::build(:user_mengying_li).github_ext_id).first || FactoryBot::create(:user_mengying_li) }
  end

end
