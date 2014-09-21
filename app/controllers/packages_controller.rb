class PackagesController < ApplicationController
  def index
    @versions = Package.latest_versions
  end

  def show
    @package = Package.new(params[:id])
  end
end
