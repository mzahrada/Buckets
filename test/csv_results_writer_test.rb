$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'buckets/csv_results_writer'
require 'buckets/instance_results'

class CsvResultsWriterTest < Test::Unit::TestCase

  OUTFILE = "outfile.csv"

  def test_write_results
    ir = Buckets::InstanceResults.new(1, :sco, 2, 4, 15, "first >> 0,1 >> 0,3 >> 2,3")
    Buckets::CsvResultsWriter.add_result(ir)
    assert_equal(1, Buckets::CsvResultsWriter::results.size)

    Buckets::CsvResultsWriter.write_results(OUTFILE)

    file = File.open(OUTFILE, "r")
    assert_equal(Buckets::CsvResultsWriter::CSV_HEADER.chomp, file.readline.chomp)
    assert_equal("1;sco;2;4;15;first >> 0,1 >> 0,3 >> 2,3", file.readline.chomp)
 
  end

  def teardown
    Buckets::CsvResultsWriter.results.clear
  end
end
