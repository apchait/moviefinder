class MoviesController < ApplicationController
  before_action :set_movie, only: [:show, :edit, :update, :destroy]

  def query

    # REFACTOR - Allow queries to be in the form of names of writers, directors and actors
    # Movies with periods and quotes in title have trouble
    @movie = Movie.find_by_title(params[:title])

    # MapBox takes geojson information for markers
    geojson = []
    @movie.locations.each do |l|
      geojson << l.geojson
    end
    
    # Send off the movie along with actor/writer/director relationships as well as geojson
    respond_to do |format|
      format.json { render json: @movie.as_json(:include => [:actors, :writers, :directors]).merge({:locations => geojson}) }
    end
  end

  def autocomplete
    # Search by lowercase title
    # REFACTOR - Make the search term something more predictable on both sides
    movies = Movie.where("downcase_title LIKE ?", "#{params[:term].downcase}%")
    # Gather all the options into an array
    options = []
    movies.all.each do |m|
      options << m.title
    end
    # Send the options array back for the client to use in the search bar autocomplete
    respond_to do |format|
      format.json { render json: options }
    end
  end

  # GET /movies
  # GET /movies.json
  def index
    @movies = Movie.all
  end

  # GET /movies/1
  # GET /movies/1.json
  def show
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies
  # POST /movies.json
  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: 'Movie was successfully created.' }
        format.json { render action: 'show', status: :created, location: @movie }
      else
        format.html { render action: 'new' }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1
  # PATCH/PUT /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: 'Movie was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1
  # DELETE /movies/1.json
  def destroy
    @movie.destroy
    respond_to do |format|
      format.html { redirect_to movies_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def movie_params
      params.require(:movie).permit(:title, :downcase_title, :release_year, :fun_facts, :director_id)
    end
end
