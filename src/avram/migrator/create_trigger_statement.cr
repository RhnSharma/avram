class Avram::Migrator::CreateTriggerStatement
  def initialize(
    @table_name : Symbol,
    @trigger_name : String,
    @function : String,
    callback @trigger_when : Symbol = :before,
    on @trigger_operation : Array(Symbol) = [:update]
  )
  end

  def build
    <<-SQL
    CREATE TRIGGER #{@trigger_name}
    #{@trigger_when.to_s.upcase} #{operation_statement} ON #{@table_name}
    FOR EACH ROW
    EXECUTE PROCEDURE #{@function}();
    SQL
  end

  private def operation_statement
    @trigger_operation.map { |op|
      op.to_s.upcase
    }.join(" OR ")
  end
end
