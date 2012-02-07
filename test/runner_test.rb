$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'buckets/runner'
require 'buckets/csv_results_writer'

class RunnerTest < Test::Unit::TestCase

  INFILE = 'test.inst.ok.dat'
  NON_EXISTING_INFILE = 'infile.dat'
  OUTFILE = 'outfile.csv'
  METHOD_S = '-s'

  def test_init_errors
    exception = assert_raise(ArgumentError) { ARGV.replace([METHOD_S]); Buckets::Runner.new }
    assert_equal(Buckets::Runner::USAGE_TEXT, exception.message)
    
    exception = assert_raise(ArgumentError) { ARGV.replace([METHOD_S, INFILE]); Buckets::Runner.new }
    assert_equal(Buckets::Runner::USAGE_TEXT, exception.message)
    
    exception = assert_raise(ArgumentError) { ARGV.replace([INFILE, OUTFILE]); Buckets::Runner.new }
    assert_equal(Buckets::Runner::USAGE_TEXT + "\n" + Buckets::Runner::NO_METHOD_TEXT, exception.message)
    
    exception = assert_raise(IOError) { ARGV.replace([METHOD_S, NON_EXISTING_INFILE, OUTFILE]); Buckets::Runner.new }
    assert_equal(Buckets::Runner::FNF_TEXT % NON_EXISTING_INFILE, exception.message)
  end

  def test_parse_options
    ARGV.replace([METHOD_S, INFILE, OUTFILE])
    runner = Buckets::Runner.new

    Buckets::Runner.send(:public, :parse_options!)

    ARGV.replace(["-b", INFILE, OUTFILE, "--dfs", "-e"])
    runner.parse_options!

    eval "def runner.get_options; @options; end"
    assert_equal(true, runner.get_options[:bfs])
    assert_equal(true, runner.get_options[:dfs])
    assert_equal(false, runner.get_options[:man])
    assert_equal(true, runner.get_options[:euc])
    assert_equal(false, runner.get_options[:sco])
  end

  def test_init
    ARGV.replace([METHOD_S, INFILE, OUTFILE])
    runner = Buckets::Runner.new

    eval "def runner.get_infile; @infile; end"
    assert_equal(INFILE, runner.get_infile)
    
    eval "def runner.get_outfile; @outfile; end"
    assert_equal(OUTFILE, runner.get_outfile)
  end

  def test_run
    ARGV.replace([METHOD_S, INFILE, OUTFILE])
    runner = Buckets::Runner.new
    runner.run

    file = File.open(OUTFILE, "r")
    assert_equal(Buckets::CsvResultsWriter::CSV_HEADER.chomp, file.readline.chomp)
    assert_equal("11;sco;13;23;387;first >> 0,0,1,0,0 >> 0,0,1,0,8 >> 0,0,0,1,8 >> 0,0,6,1,8 >> 0,6,0,1,8 >> 0,6,6,1,8 >> 6,6,0,1,8 >> 6,6,6,1,8 >> 12,6,0,1,8 >> 12,6,6,1,8 >> 12,6,6,1,0 >> 12,6,0,1,6 >> 12,6,6,1,6 >> 12,6,4,1,8", file.readline.chomp)
  end

  def teardown
    Buckets::CsvResultsWriter.results.clear
  end
end
