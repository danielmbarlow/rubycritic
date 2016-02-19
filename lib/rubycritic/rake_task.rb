require 'rake'
require 'rake/tasklib'


module Rubycritic
  # A rake task that runs RubyCritic on a set of source files.
  #
  # Example:
  #
  #   require 'rubycritic/rake_task'
  #
  #   RubyCritic::RakeTask.new do |task|
  #     task.paths = FileList['lib/**/*.rb', #TODO]
  #   end
  #
  # This will create a task that can be run with:
  #
  #   rake rubycritic
  #
  # Examples:
  #
  #   rake rubycritic
  #   rake rubycritic .... # TODO
  #
  # @public
  #
  class RakeTask < ::Rake::TaskLib
    # Name of RubyCritic task. Defaults to :rubycritic.
    # @public
    attr_writer :name

    # Glob pattern to match source files.
    # Defaults to FileList['lib/**/*.rb'].
    # @public
    attr_reader :paths

    # Use verbose output. If this is set to true, the task will print
    # the rubycritic command to stdout. Defaults to false.
    # @public
    attr_writer :verbose

    # @public
    def initialize(name = :rubycritic)
      @name    = name
      @paths   = FileList['lib/**/*.rb']
      @options = ''
      @verbose = false

      yield self if block_given?
      define_task
    end

    private

    attr_reader :name, :paths, :verbose, :options

    def define_task
      desc 'Run RubyCritic'
      task(name) { run_task }
    end

    def run_task
      puts "\n\n!!! Running #{name} rake command: #{command}\n\n" if verbose
      system(*command)
      abort("\n\n!!! RubyCritic returned a non-zero return status - exiting!") if sys_call_failed?
    end

    def command
      ['rubycritic', *options_as_arguments, *paths].
        compact.
        reject(&:empty?)
    end

    def sys_call_failed?
      !$CHILD_STATUS.success?
    end

    def options_as_arguments
      options.split(/\s+/)
    end
  end
end
