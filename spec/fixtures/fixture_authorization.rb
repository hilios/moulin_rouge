class FixtureAuthorization < MoulinRouge::Authorization
  role(:fixture) do
    can(:be, :used, :for, :testing)
  end
end