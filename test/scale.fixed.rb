# This is a generated file! Please edit source .ksy file and use kaitai-struct-compiler to rebuild

require 'kaitai/struct/struct'

unless Gem::Version.new(Kaitai::Struct::VERSION) >= Gem::Version.new('0.9')
  raise "Incompatible Kaitai Struct Ruby API: 0.9 or later is required, but you have #{Kaitai::Struct::VERSION}"
end

class Scale < Kaitai::Struct::Struct
  def initialize(_io, _parent = nil, _root = self)
    super(_io, _parent, _root)
    _read
  end

  def _read
    self
  end
  class String < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      _read
    end

    def _read
      @length = CompactInt.new(@_io, self, @_root)
      @value = (@_io.read_bytes(length.value)).force_encoding("UTF-8")
      self
    end
    attr_reader :length
    attr_reader :value
  end
  class Bytes < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      _read
    end

    def _read
      @length = CompactInt.new(@_io, self, @_root)
      @value = @_io.read_bytes(length.value)
      self
    end
    attr_reader :length
    attr_reader :value
  end
  class MaybeString < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      _read
    end

    def _read
      @has_value = @_io.read_u1
      if has_value != 0
        @value = String.new(@_io, self, @_root)
      end
      self
    end
    attr_reader :has_value
    attr_reader :value
  end
  class CompactInt < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      _read
    end

    def _read
      @data = @_io.read_bits_int_be(6)
      @mode = @_io.read_bits_int_be(2)
      @_io.align_to_byte
      @extra = @_io.read_bytes((((mode & 1) + (((mode & 2) / 2) * 3)) + (((mode & 3) / 3) * data)))
      self
    end
    def value
      return @value unless @value.nil?
      @value = data
      extra.each_byte.each_with_index { |b, i| @value += b << (8 * i + 6) }
      @value
    end
    attr_reader :data
    attr_reader :mode
    attr_reader :extra
  end
  class MaybeCompactInt < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      _read
    end

    def _read
      @has_value = @_io.read_u1
      if has_value != 0
        @value = CompactInt.new(@_io, self, @_root)
      end
      self
    end
    attr_reader :has_value
    attr_reader :value
  end
  class StringList < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      _read
    end

    def _read
      @num_values = CompactInt.new(@_io, self, @_root)
      @values = []
      (num_values.value).times { |i|
        @values << String.new(@_io, self, @_root)
      }
      self
    end
    attr_reader :num_values
    attr_reader :values
  end
end
