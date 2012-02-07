require 'benchmark'
require 'optparse'
require_relative 'input_reader'
require_relative 'buckets_solver'

# Module that solves buckets problem.
#
# Author:: Martin Zahradnicky  (mailto:mzahrada@gmail.com)
module Buckets

  # Runner class for Buckets module.
  class Runner
    # Usage message printed when probram used wrong.
    USAGE_TEXT = 'Usage: ruby buckets [-bdmesh] infile outfile'
    # Error message raised when file not found.
    FNF_TEXT = "Input file '%s' not found."
    # Error message raised when no solving method specified.
    NO_METHOD_TEXT = "You must specify at least one solving method.\nSee help: ruby buckets -h"

    # Initializes Runner, gets program's options, input and output filename
    # from input arguments _ARGV_.
    # ---
    # * Raises::
    #   - _ArgumentError_ if input or output file or solving method not specified in _ARGV_
    #   - _IOError_ if input file not found
    def initialize
      init_argv_size = ARGV.size

      parse_options!

      raise ArgumentError.new(USAGE_TEXT + "\n" + NO_METHOD_TEXT) if ARGV.size == init_argv_size  # solving method not specified
      raise ArgumentError.new(USAGE_TEXT) if ARGV.size != 2           # input or output file not specified
      raise IOError.new(FNF_TEXT % ARGV[0]) if !File.exist?(ARGV[0])  # input file do not exists

      @infile = ARGV[0]
      @outfile = ARGV[1]
    end

    # Main method for running Buckets module.
    # ---
    # * Output::
    #   - writes solution to file in CSV format
    def run
      Benchmark.bm { |r|
        InputReader.get_instances(@infile).each { |instance|
          r.report("instance #{instance.id}:") {
            @options.each { |method,value|
              if(value == true)
                solver = BucketSolver.new(instance, method)
                solver.solve
              end
            }
          }
        }
      }
      CsvResultsWriter.write_results(@outfile)
    end

    private

      # Parses command line (_ARGV_), removes! options from there and stores them in _options_ hash.
      # Each option stands for one solving method.
      # _options_ hash::
      # - <tt>:bfs => true</tt> .. bfs used for solving
      def parse_options!
        @options = {}
        optparse = OptionParser.new do |opts|
          opts.banner = USAGE_TEXT

          @options[:bfs] = false
          opts.on( '-b', '--bfs', 'BFS method used for solving.' ) do
            @options[:bfs] = true
          end

          @options[:dfs] = false
          opts.on( '-d', '--dfs', 'DFS method used for solving.' ) do
            @options[:dfs] = true
          end

          @options[:man] = false
          opts.on( '-m', '--man', 'Manhattan heuristic used for solving.' ) do
            @options[:man] = true
          end

          @options[:euc] = false
          opts.on( '-e', '--euc', 'Euclidean heuristic used for solving.' ) do
            @options[:euc] = true
          end

          @options[:sco] = false
          opts.on( '-s', '--sco', 'Score heuristic used for solving.' ) do
            @options[:sco] = true
          end
        end
        optparse.parse!
      end
  end
end
