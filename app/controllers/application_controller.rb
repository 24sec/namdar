class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Concerns::TagsConcerns
  include Concerns::Permission
end
