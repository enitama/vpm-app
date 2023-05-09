require "controllers/api/v1/test"

class Api::V1::PackageVersionsControllerTest < Api::Test
  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @package = create(:package, team: @team)
    @package_version = build(:package_version, package: @package)
    @other_package_versions = create_list(:package_version, 3)

    @another_package_version = create(:package_version, package: @package)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @package_version.save
    @another_package_version.save
  end

  # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
  # data we were previously providing to users _will_ break the test suite.
  def assert_proper_object_serialization(package_version_data)
    # Fetch the package_version in question and prepare to compare it's attributes.
    package_version = PackageVersion.find(package_version_data["id"])

    assert_equal_or_nil package_version_data['name'], package_version.name
    assert_equal_or_nil package_version_data['description'], package_version.description
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal package_version_data["package_id"], package_version.package_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/packages/#{@package.id}/package_versions", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    package_version_ids_returned = response.parsed_body.map { |package_version| package_version["id"] }
    assert_includes(package_version_ids_returned, @package_version.id)

    # But not returning other people's resources.
    assert_not_includes(package_version_ids_returned, @other_package_versions[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/package_versions/#{@package_version.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/package_versions/#{@package_version.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    package_version_data = JSON.parse(build(:package_version, package: nil).to_api_json.to_json)
    package_version_data.except!("id", "package_id", "created_at", "updated_at")
    params[:package_version] = package_version_data

    post "/api/v1/packages/#{@package.id}/package_versions", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/packages/#{@package.id}/package_versions",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/package_versions/#{@package_version.id}", params: {
      access_token: access_token,
      package_version: {
        name: 'Alternative String Value',
        description: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @package_version.reload
    assert_equal @package_version.name, 'Alternative String Value'
    assert_equal @package_version.description, 'Alternative String Value'
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/package_versions/#{@package_version.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("PackageVersion.count", -1) do
      delete "/api/v1/package_versions/#{@package_version.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/package_versions/#{@another_package_version.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
