# encoding: utf-8

module BaseHangul
  # Handle command line interfaces logic.
  class CLI
    # Initialize a CLI.
    def initialize
      @options = {}
    end

    # Entry point for the application logic. Process command line arguments and
    # run the BaseHangul.
    #
    # args - An Array of Strings user passed.
    #
    # Returns an Integer UNIX exit code.
    def run(args = ARGV)
      @options, paths = Option.new.parse(args)
      source = paths.empty? ? $stdin.read : IO.read(paths[0])
      if @options[:decode]
        puts BaseHangul.decode(source)
      else
        puts BaseHangul.encode(source)
      end
      0
    end
  end
end
