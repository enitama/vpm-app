# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::PackageVersionsController < Api::V1::ApplicationController
    account_load_and_authorize_resource :package_version, through: :package, through_association: :package_versions

    # GET /api/v1/packages/:package_id/package_versions
    def index
    end

    # GET /api/v1/package_versions/:id
    def show
    end

    # POST /api/v1/packages/:package_id/package_versions
    def create
      if @package_version.save
        render :show, status: :created, location: [:api, :v1, @package_version]
      else
        render json: @package_version.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/package_versions/:id
    def update
      if @package_version.update(package_version_params)
        render :show
      else
        render json: @package_version.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/package_versions/:id
    def destroy
      @package_version.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def package_version_params
        strong_params = params.require(:package_version).permit(
          *permitted_fields,
          :name,
          :description,
          # 🚅 super scaffolding will insert new fields above this line.
          *permitted_arrays,
          # 🚅 super scaffolding will insert new arrays above this line.
        )

        process_params(strong_params)

        strong_params
      end
    end

    include StrongParameters
  end
else
  class Api::V1::PackageVersionsController
  end
end
