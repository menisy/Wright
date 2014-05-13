class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy, :play, :generate_words, :new_page]

  # GET /books
  # GET /books.json
  def index
    @books = Book.all
  end

  # GET /books/1
  # GET /books/1.json
  def show
    if params[:reload]
      @reload = true
    end
    @pages = @book.pages
  end

  def generate_words
    @book.generating = true
    @book.save
    logger.error 'in generation *********************'
    Thread.new do
      logger.error 'in thread %%%%%%%%%%%%%%%%%%%%'
      @book.generate_words
      ActiveRecord::Base.connection.close
    end
    #GenWorker.perform_async(@book.id.to_s)
    redirect_to book_path(@book, reload: true), notice: "Words will be generated shortly\nPlease wait till the page reloads!"
  end

  def play
    @lang = @book.lang
    @words = @book.words.asc(:played).take(20)
    @words.map(&:inc_played)
  end

  def play_random
    @lang = 'ara'
    @words = Word.asc(:played).take(20)
    @words.map(&:inc_played)
    render 'play'
  end

  def new_page
    filename = page_params[:attachment].original_filename
    unless @book.can_add? filename
      render json: {message: 'Already loaded a page with the same name!'}, status: :unprocessable_entity
      return
    end
    @page = @book.pages.build page_params
    @page.filename = filename
    respond_to do |format| 
      if @page.save
        format.html { redirect_to @page, notice: 'Photo was successfully created.' }
        format.json { 
          data = {id: @page.id, filename: @page.filename, thumb: view_context.image_tag(@page.attachment.url(:thumb))} 
          render json: data, status: :created, location: @book
      }
      else 
        format.html { render action: "new" }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render action: 'show', status: :created, location: @book }
      else
        format.html { render action: 'new' }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  def submit_score
    total = 0
    params[:data].to_a.each do |e|
      id = e[1][:id]
      guess = e[1][:guess]
      word = Word.find(id)
      score = word.add_guess guess
      total += score
    end
    time = params[:time].to_i
    total *= 100
    total -= (time*10)
    render json: {total: I18n.t(:score_is, total: total, time: time), score: total, time: time}
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:name, :reference, :attachment, :lang)
    end

    def page_params
      params.require(:page).permit(:attachment)
    end
end
