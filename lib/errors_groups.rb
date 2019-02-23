class ErrorsGroups
  UNIQUE_VIOLATION_ERRORS = [
    PG::UniqueViolation,
    ActiveRecord::RecordNotUnique
  ].freeze
end
