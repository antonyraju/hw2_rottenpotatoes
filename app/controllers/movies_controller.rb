class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    order = params[:order]
    ratings = params[:ratings]
    @all_ratings = Movie.all_ratings
    title_th = title_trd = order_sql = ''
    redirect = false

    if ratings != nil
      session[:ratings] = ratings
    else
      if session.has_key?(:ratings) == false
        session[:ratings] = { 'G' => 1, 'PG' => 1, 'PG-13' => 1, 'R' => 1 }
      end
      redirect = true
    end

    if order != nil
      session[:order] = order
    else
      if session.has_key?(:order) == false
        session[:order] = ''
      end
      redirect = true
    end

    if redirect == true
      flash.keep
      redirect_to movies_path(:order => session[:order], :ratings => session[:ratings])
      return
    end

    if ratings == nil
      @filter_checked = Hash.new
    else
      @filter_checked = ratings
    end

    if order == 'title'
      order_sql = 'title ASC'
      @class_th = 'hilite'
    elsif order == 'release_date'
      order_sql = 'release_date ASC'
      @class_trd = 'hilite'
    end

    if ratings == nil
      @movies = Movie.all(:order => order_sql)
    else
      @movies = Movie.find_all_by_rating(ratings.keys, :order => order_sql)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end