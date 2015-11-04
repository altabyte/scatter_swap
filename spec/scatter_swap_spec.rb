require 'spec_helper'
require 'scatter_swap'

describe ScatterSwap do

  it 'has a version number' do
    expect(ScatterSwap::VERSION).not_to be nil
  end

  describe '#hash' do
    it 'should be 10 digits' do
      100.times do |integer|
        expect(ScatterSwap.hash(integer).to_s.length).to eq 10
      end
    end

    it 'should not be sequential' do
      first = ScatterSwap.hash(1)
      second = ScatterSwap.hash(2)
      expect(second).not_to eq(first.to_i + 1)
    end

    it 'should be reversable' do
      100.times do |integer|
        hashed = ScatterSwap.hash(integer)
        expect(ScatterSwap.reverse_hash(hashed).to_i).to eq(integer)
      end
    end
  end


  describe '#swapper_map' do
    before do
      @map_set = []
      s = ScatterSwap::Hasher.new(1)
      10.times do |digit|
        @map_set.push s.swapper_map(digit)
      end
    end

    it 'should create a unique map array for each digit' do
      expect(@map_set.length).to eq(10)
      expect(@map_set.uniq.length).to eq(10)
    end

    it 'should include all 10 digits in each map' do
      @map_set.each do |map|
        expect(map.length).to eq(10)
        expect(map.uniq.length).to eq(10)
      end
    end
  end


  describe '#scatter' do
    it 'should return a number different from original' do
      100.times do |integer|
        s = ScatterSwap::Hasher.new(integer)
        original_array = s.working_array
        s.scatter
        #s.working_array.should_not == original_array
        expect(s.working_array).not_to eq(original_array)
      end
    end

    it 'should be reversable' do
      100.times do |integer|
        s = ScatterSwap::Hasher.new(integer)
        original_array = s.working_array.clone
        s.scatter
        s.unscatter
        expect(s.working_array).to eq(original_array)
      end
    end
  end


  describe '#swap' do
    it 'should be different from original' do
      100.times do |integer|
        s = ScatterSwap::Hasher.new(integer)
        original_array = s.working_array.clone
        s.swap
        expect(s.working_array).not_to eq(original_array)
      end
    end

    it 'should be reversable' do
      100.times do |integer|
        s = ScatterSwap::Hasher.new(integer)
        original_array = s.working_array.clone
        s.swap
        s.unswap
        expect(s.working_array).to eq(original_array)
      end
    end
  end
end
