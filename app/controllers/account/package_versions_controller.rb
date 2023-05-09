class Account::PackageVersionsController < Account::ApplicationController
  account_load_and_authorize_resource :package_version, through: :package, through_association: :package_versions

  # GET /account/packages/:package_id/package_versions
  # GET /account/packages/:package_id/package_versions.json
  def index
    delegate_json_to_api
  end

  # GET /account/package_versions/:id
  # GET /account/package_versions/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/packages/:package_id/package_versions/new
  def new
  end

  # GET /account/package_versions/:id/edit
  def edit
  end

  # POST /account/packages/:package_id/package_versions
  # POST /account/packages/:package_id/package_versions.json
  def create
    respond_to do |format|
      if @package_version.save
        format.html { redirect_to [:account, @package_version], notice: I18n.t("package_versions.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @package_version] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @package_version.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/package_versions/:id
  # PATCH/PUT /account/package_versions/:id.json
  def update
    respond_to do |format|
      if @package_version.update(package_version_params)
        format.html { redirect_to [:account, @package_version], notice: I18n.t("package_versions.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @package_version] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @package_version.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/package_versions/:id
  # DELETE /account/package_versions/:id.json
  def destroy
    @package_version.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @package, :package_versions], notice: I18n.t("package_versions.notifications.destroyed") }
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
