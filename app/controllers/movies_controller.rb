class MoviesController < ApplicationController
  before_action :set_movie, only: [:show, :edit, :update, :destroy]

  def query
    puts params, "PARAMS"
    # Also try to find movies by writers directors actors "personalities"
    @movie = Movie.find_by_title(params[:title])

    actor_string = ""
    @movie.actors.each do |a|
      actor_string = actor_string + a.name + ", " if a.name
    end
    actor_string = actor_string[0..-3]

    writer_string = ""
    @movie.writers.each do |w|
      writer_string = writer_string + w.name + ", "
    end
    writer_string = writer_string[0..-3]

    director_string = ""
    @movie.directors.each do |d|
      director_string = director_string + d.name + ", "
    end
    director_string = director_string[0..-3]

    respond_to do |format|
      format.json { render json: @movie.as_json.merge(:actors => actor_string, :writers => writer_string, :directors => director_string, :locations => @movie.locations) }
    end
  end

  def autocomplete
    movies = Movie.where("downcase_title LIKE ?", "#{params[:term].downcase}%")
    options = []
    movies.all.each do |m|
      #options << {:label => m.title, :value => m.id }
      options << m.title
    end
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
