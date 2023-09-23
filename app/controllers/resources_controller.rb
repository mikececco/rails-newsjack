class ResourcesController < ApplicationController
  def index
    @resources = Resource.all
  end

  def show
    @resource = Resource.friendly.find(params[:id])
  end

  def new
    @resource = Resource.new
  end

  def create
    @resource = Resource.new(resource_params)

    if @resource.save
      redirect_to @resource, notice: 'Blog post was successfully created.'
    else
      render :new
    end
  end

  private

  def resource_params
    params.require(:resource).permit(:title, :content)
  end
end
