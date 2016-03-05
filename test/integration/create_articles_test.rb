require 'test_helper'

class CreateArticlesTest < ActionDispatch::IntegrationTest

  def setup
    @user = User.create(
        username: "john",
        email: "john@example.com",
        password: "password",
        admin: true
    )

    @article = Article.create(
        title: "Test Article",
        description: "This article tests creation of a new article.",
        user_id: @user.id
    )
  end

  test "get new article form and create article" do
    sign_in_as(@user, "password")
    get new_article_path
    assert_template 'articles/new'
    assert_difference 'Article.count', 1 do
      post_via_redirect articles_path, article: {
          title: "New Article",
          description: "Description for test article.",
          user_id: @user.id
      }
    end
    assert_template 'articles/show'
    assert_match "New Article", response.body
  end

  test "invalid article submission results in failure" do
    sign_in_as(@user, "password")
    get new_article_path
    assert_template 'articles/new'
    assert_no_difference 'Article.count' do
      post articles_path, article: {
          title: "laksjfhdlaksjdfhlajllsakjdhflaksjdhflaksjdfhlasjdhflsklskdjf"
      }
    end
    assert_template 'articles/new'
    assert_match "Title is too long", response.body

  end
end