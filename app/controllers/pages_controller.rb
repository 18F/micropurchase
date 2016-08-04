require 'swagger'

class PagesController < ApplicationController
  before_action :load_swagger

  private

  def load_swagger
    path = Rails.root.join('public', 'api', 'v0', 'swagger.json')
    @swagger = Swagger::Specification.load_json(path)
  end
end
