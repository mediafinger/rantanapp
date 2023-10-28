class PicturesController < ApplicationController
  skip_before_action :authenticate, only: %i[index show] # allow everyone to see the pictures

  def index
    authorize! current_user, to: :index?, with: PicturePolicy

    # pictures = authorized_scope(Picture.all, type: :relation, as: :current_team_scope)
    pictures = Picture.all

    @pictures = pictures.order(created_at: :desc)
  end

  def show
    @picture = Picture.urlsafe_find!(params[:id])
    authorize! @picture
  end

  def new
    @picture = Picture.new(team: current_team)
    authorize! @picture
  end

  def edit
    @picture = Picture.urlsafe_find!(params[:id])
    authorize! @picture
  end

  def create
    unless picture_params[:file].is_a?(ActionDispatch::Http::UploadedFile)
      raise CustomError.new("File not valid", status: 422, code: :unprocessable_entity)
    end

    @picture = Picture.new(
      file: ImageUploadConversionService.call(file: picture_params[:file], name: picture_params[:name]),
      name: picture_params[:name], # looks redundant, but image filename is parameterized
      date: picture_params[:date],
      team: current_team
    )

    authorize! @picture

    Picture.transaction do
      @picture.save
      RecordHistoryService.call(record: @picture, team: current_team, user: current_user, event: :created)
    end

    if @picture.persisted?
      redirect_to @picture, notice: "Picture was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @picture = Picture.urlsafe_find!(params[:id])
    authorize! @picture

    Picture.transaction do
      @picture.update(picture_params)
      RecordHistoryService.call(record: @picture, team: current_team, user: current_user, event: :updated)
    end

    if @picture.changed? # == picture still dirty, not saved
      render :edit, status: :unprocessable_entity
    else
      redirect_to @picture, notice: "Picture was successfully updated."
    end
  end

  def destroy
    @picture = Picture.urlsafe_find!(params[:id])
    authorize! @picture

    Picture.transaction do
      RecordHistoryService.call(record: @picture, team: current_team, user: current_user, event: :deleted)
      @picture.destroy!
    end

    redirect_to pictures_url, notice: "Picture was successfully destroyed."
  end

  private

  # switch to dry-validation / dry-contract
  def picture_params
    params.require(:picture).permit(:file, :date, :name)
  end
end
