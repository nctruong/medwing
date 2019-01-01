class ReadingQueries::Average
  def self.get(attributes, after_where_clause = '')
    attributes = attributes
    sql = ::UtilQueries::AverageQueryBuilder.new(attributes, 'readings', after_where_clause).get
    result(ActiveRecord::Base.connection.exec_query(sql))
  end

  private

  def self.result(exec_result)
    result = {}
    exec_result&.columns.each_with_index do |col,idx|
      result[col] = exec_result&.rows[0][idx]
    end
    result
  end
end