require 'sinatra/base'
require 'sinatra/flash'
require './lib/user'
require './lib/data_mapper_setup'

class Makersbnb < Sinatra::Base
  enable :sessions
  register Sinatra::Flash

  get '/' do
    @properties = Space.all
    @user = User.get(session[:id])
    erb :index
  end

  get '/users/new' do
    erb :users
  end

  post '/users' do
    user = User.create(email: params['email'], password: params['password'], username: params['username'])
    if user.save
      session[:id] = user.id
      redirect('/')
    else
      flash.now[:notice] = "NO!"
      redirect('/users/new')
    end
  end

  post '/sessions' do
    user = User.authenticate(params[:username], params[:password])
    session[:id] = user.id
    redirect('/')
  end

  post '/sessions/destroy' do
    session.clear
    redirect('/')
  end

  post '/properties' do
    Space.create(address: params['address'], price: params['price'])
    redirect('/')
  end

  get '/profile' do
    @user = User.get(session[:id])
    erb :profile
  end

  run! if app_file == $PROGRAM_NAME
end
