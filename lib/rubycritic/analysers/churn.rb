module Rubycritic
  module Analyser

    class Churn
      def initialize(analysed_files, source_control_system)
        @analysed_files = analysed_files
        @source_control_system = source_control_system
      end

      def churn
        @analysed_files.each do |analysed_file|
          analysed_file.churn = @source_control_system.revisions_count(analysed_file.path)
        end
      end
    end

  end
end
