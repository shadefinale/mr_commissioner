class StaticPagesController < ApplicationController

  layout 'login', only: :login

  def login
  end

  def table
  end
end
