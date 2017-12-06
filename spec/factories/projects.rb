FactoryBot.define do

  factory :project_cpp_redis, class: Project do
    slug            "cpp-redis"
    name            "cpp redis"
    description     "C++11 Redis client"
    repository_url  "https://github.com/cylix/cpp_redis"
    git_url         "git@github.com:Cylix/cpp_redis.git"
    homepage_url    "https://cylix.github.io/cpp_redis"
  end

end
