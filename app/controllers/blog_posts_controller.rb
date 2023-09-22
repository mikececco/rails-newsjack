class BlogPostsController < ApplicationController
  def index
    @blog_posts = BlogPost.all
  end

  def show
    @blog_post = BlogPost.friendly.find(params[:id])
  end

  def new
    @blog_post = BlogPost.new
  end

  def create
    @blog_post = BlogPost.new(blog_post_params)

    if @blog_post.save
      redirect_to @blog_post, notice: 'Blog post was successfully created.'
    else
      render :new
    end
  end

  private

  def blog_post_params
    params.require(:blog_post).permit(:title, :content)
  end
end
