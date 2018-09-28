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
    @sort = params[:sort]
    @ratings = params[:ratings]

     # remember settings
    if @sort.blank? && !session[:sort].blank?
      @sort = session[:sort]
      retrieve_sort = 1
    end
    if @ratings.blank? && !session[:ratings].blank?
      @ratings = session[:ratings]
      retrieve_ratings = 1
    end
    if retrieve_sort == 1 || retrieve_ratings == 1
      flash.keep
      redirect_to :ratings => @ratings, :sort => @sort 
      return
    end
    
    # sort: change header background
    @title_header = 'hilite' if @sort == 'title'
    @release_date_header = 'hilite' if @sort == 'release_date'


    # rating selection
    @all_ratings = Movie.ratings
    if @ratings == nil
      @ratings = Hash.new
      @all_ratings.each { |r| @ratings[r] =  "1" }
    end
       
    # list movies
    @movies = Movie.where({rating: @ratings.keys}).order(@sort).all
    
    # save sessions 
    session[:sort] = @sort
    session[:ratings] = @ratings
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
