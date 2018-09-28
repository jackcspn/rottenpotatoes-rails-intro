class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

 
  def index
    # change header background
    @title_header = 'hilite' if params[:sort] == 'title'
    @release_date_header = 'hilite' if params[:sort] == 'release_date'
    
    # rating selection box
    @all_ratings = Movie.ratings
    @ratings = params[:ratings]
    if @ratings == nil
      @ratings = Hash.new
      @all_ratings.each { |d| @ratings[d] =  "1" }
    end
    
    # list movies
    @movies = Movie.where({rating: @ratings.keys}).order(params[:sort]).all
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
