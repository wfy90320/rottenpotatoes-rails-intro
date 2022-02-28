class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    params[:sorting]
    session[:sorting]
    @movies = Movie.all
   
    @ratings = Movie.ob_rate
    
    @save_rating = @ratings
    

    if params.key?(:ratings)
      session[:ratings] = params[:ratings].keys
    end
    
    if session[:ratings]
      @save_rating = session[:ratings]
      @movies = @movies.where(rating: @save_rating)
    end
    
    if params[:sorting] #sort the release date and title 
      session[:sorting] = params[:sorting]
    end
    
    if session[:sorting] == 'title' && session[:sorting] != 'release_date'
      @movies = @movies.order(:title)
      
    end
    
    if session[:sorting] == 'release_date' && session[:sorting] != 'title'
      @movies = @movies.order(:release_date)
    end
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
