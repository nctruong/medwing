module UtilQueries
  class AverageQueryBuilder
    attr_reader :attributes
    attr_reader :table
    attr_reader :conditions

    def initialize(attributes, table, conditions = '')
      @attributes = attributes
      @table = table
      @conditions = conditions
    end

    def get
      build_query
    end

    private

    def build_query
      sql = "SELECT #{average_col} FROM #{table}"
      conditions.blank? ? sql : (sql << " WHERE #{conditions}")
    end

    def average_col
      attributes.collect { |col| "AVG(#{col}) as #{col}" }.join(',')
    end
  end
end