class Account::PackagesController < Account::ApplicationController
  account_load_and_authorize_resource :package, through: :team, through_association: :packages

  # GET /account/teams/:team_id/packages
  # GET /account/teams/:team_id/packages.json
  def index
    delegate_json_to_api
  end

  # GET /account/packages/:id
  # GET /account/packages/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/packages/new
  def new
  end

  # GET /account/packages/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/packages
  # POST /account/teams/:team_id/packages.json
  def create
    respond_to do |format|
      if @package.save
        format.html { redirect_to [:account, @package], notice: I18n.t("packages.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @package] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @package.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/packages/:id
  # PATCH/PUT /account/packages/:id.json
  def update
    respond_to do |format|
      if @package.update(package_params)
        format.html { redirect_to [:account, @package], notice: I18n.t("packages.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @package] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @package.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/packages/:id
  # DELETE /account/packages/:id.json
  def destroy
    @package.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :packages], notice: I18n.t("packages.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  if defined?(Api::V1::ApplicationController)
    include strong_parameters_from_api
  end

  def process_params(strong_params)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
