
# line 1 "lib/halunke/lexer.rl"
=begin

# line 34 "lib/halunke/lexer.rl"

=end

module Halunke
  class Lexer
    def initialize
      
# line 14 "lib/halunke/lexer.rb"
class << self
	attr_accessor :_lexer_actions
	private :_lexer_actions, :_lexer_actions=
end
self._lexer_actions = [
	0, 1, 0, 1, 1, 1, 2, 1, 
	5, 1, 6, 1, 7, 1, 8, 1, 
	9, 1, 10, 1, 11, 1, 12, 1, 
	13, 1, 14, 1, 15, 1, 16, 1, 
	17, 1, 18, 1, 19, 1, 20, 1, 
	21, 2, 2, 3, 2, 2, 4
]

class << self
	attr_accessor :_lexer_key_offsets
	private :_lexer_key_offsets, :_lexer_key_offsets=
end
self._lexer_key_offsets = [
	0, 1, 3, 26, 27, 32, 34, 37, 
	39
]

class << self
	attr_accessor :_lexer_trans_keys
	private :_lexer_trans_keys, :_lexer_trans_keys=
end
self._lexer_trans_keys = [
	34, 48, 57, 32, 34, 39, 40, 41, 
	43, 45, 91, 93, 95, 123, 124, 125, 
	9, 13, 48, 57, 60, 62, 65, 90, 
	97, 122, 34, 95, 65, 90, 97, 122, 
	48, 57, 46, 48, 57, 48, 57, 95, 
	65, 90, 97, 122, 0
]

class << self
	attr_accessor :_lexer_single_lengths
	private :_lexer_single_lengths, :_lexer_single_lengths=
end
self._lexer_single_lengths = [
	1, 0, 13, 1, 1, 0, 1, 0, 
	1
]

class << self
	attr_accessor :_lexer_range_lengths
	private :_lexer_range_lengths, :_lexer_range_lengths=
end
self._lexer_range_lengths = [
	0, 1, 5, 0, 2, 1, 1, 1, 
	2
]

class << self
	attr_accessor :_lexer_index_offsets
	private :_lexer_index_offsets, :_lexer_index_offsets=
end
self._lexer_index_offsets = [
	0, 2, 4, 23, 25, 29, 31, 34, 
	36
]

class << self
	attr_accessor :_lexer_trans_targs
	private :_lexer_trans_targs, :_lexer_trans_targs=
end
self._lexer_trans_targs = [
	2, 0, 7, 2, 2, 3, 4, 2, 
	2, 5, 5, 2, 2, 8, 2, 2, 
	2, 2, 6, 2, 8, 8, 2, 2, 
	0, 4, 4, 4, 2, 6, 2, 1, 
	6, 2, 7, 2, 8, 8, 8, 2, 
	2, 2, 2, 2, 2, 2, 2, 2, 
	0
]

class << self
	attr_accessor :_lexer_trans_actions
	private :_lexer_trans_actions, :_lexer_trans_actions=
end
self._lexer_trans_actions = [
	7, 0, 0, 35, 25, 5, 44, 11, 
	13, 0, 0, 19, 21, 0, 15, 23, 
	17, 25, 5, 9, 0, 0, 27, 7, 
	0, 41, 41, 41, 39, 5, 31, 0, 
	5, 29, 0, 29, 0, 0, 0, 31, 
	37, 35, 33, 39, 31, 29, 29, 31, 
	0
]

class << self
	attr_accessor :_lexer_to_state_actions
	private :_lexer_to_state_actions, :_lexer_to_state_actions=
end
self._lexer_to_state_actions = [
	0, 0, 1, 0, 0, 0, 0, 0, 
	0
]

class << self
	attr_accessor :_lexer_from_state_actions
	private :_lexer_from_state_actions, :_lexer_from_state_actions=
end
self._lexer_from_state_actions = [
	0, 0, 3, 0, 0, 0, 0, 0, 
	0
]

class << self
	attr_accessor :_lexer_eof_trans
	private :_lexer_eof_trans, :_lexer_eof_trans=
end
self._lexer_eof_trans = [
	41, 42, 0, 43, 44, 48, 47, 47, 
	48
]

class << self
	attr_accessor :lexer_start
end
self.lexer_start = 2;
class << self
	attr_accessor :lexer_first_final
end
self.lexer_first_final = 2;
class << self
	attr_accessor :lexer_error
end
self.lexer_error = -1;

class << self
	attr_accessor :lexer_en_main
end
self.lexer_en_main = 2;


# line 41 "lib/halunke/lexer.rl"
      @tokens = []
    end

    def tokenize(data)
      data.chomp!
      eof = data.length

      
# line 160 "lib/halunke/lexer.rb"
begin
	p ||= 0
	pe ||= data.length
	cs = lexer_start
	ts = nil
	te = nil
	act = 0
end

# line 49 "lib/halunke/lexer.rl"
      
# line 172 "lib/halunke/lexer.rb"
begin
	_klen, _trans, _keys, _acts, _nacts = nil
	_goto_level = 0
	_resume = 10
	_eof_trans = 15
	_again = 20
	_test_eof = 30
	_out = 40
	while true
	_trigger_goto = false
	if _goto_level <= 0
	if p == pe
		_goto_level = _test_eof
		next
	end
	end
	if _goto_level <= _resume
	_acts = _lexer_from_state_actions[cs]
	_nacts = _lexer_actions[_acts]
	_acts += 1
	while _nacts > 0
		_nacts -= 1
		_acts += 1
		case _lexer_actions[_acts - 1]
			when 1 then
# line 1 "NONE"
		begin
ts = p
		end
# line 202 "lib/halunke/lexer.rb"
		end # from state action switch
	end
	if _trigger_goto
		next
	end
	_keys = _lexer_key_offsets[cs]
	_trans = _lexer_index_offsets[cs]
	_klen = _lexer_single_lengths[cs]
	_break_match = false
	
	begin
	  if _klen > 0
	     _lower = _keys
	     _upper = _keys + _klen - 1

	     loop do
	        break if _upper < _lower
	        _mid = _lower + ( (_upper - _lower) >> 1 )

	        if data[p].ord < _lexer_trans_keys[_mid]
	           _upper = _mid - 1
	        elsif data[p].ord > _lexer_trans_keys[_mid]
	           _lower = _mid + 1
	        else
	           _trans += (_mid - _keys)
	           _break_match = true
	           break
	        end
	     end # loop
	     break if _break_match
	     _keys += _klen
	     _trans += _klen
	  end
	  _klen = _lexer_range_lengths[cs]
	  if _klen > 0
	     _lower = _keys
	     _upper = _keys + (_klen << 1) - 2
	     loop do
	        break if _upper < _lower
	        _mid = _lower + (((_upper-_lower) >> 1) & ~1)
	        if data[p].ord < _lexer_trans_keys[_mid]
	          _upper = _mid - 2
	        elsif data[p].ord > _lexer_trans_keys[_mid+1]
	          _lower = _mid + 2
	        else
	          _trans += ((_mid - _keys) >> 1)
	          _break_match = true
	          break
	        end
	     end # loop
	     break if _break_match
	     _trans += _klen
	  end
	end while false
	end
	if _goto_level <= _eof_trans
	cs = _lexer_trans_targs[_trans]
	if _lexer_trans_actions[_trans] != 0
		_acts = _lexer_trans_actions[_trans]
		_nacts = _lexer_actions[_acts]
		_acts += 1
		while _nacts > 0
			_nacts -= 1
			_acts += 1
			case _lexer_actions[_acts - 1]
when 2 then
# line 1 "NONE"
		begin
te = p+1
		end
when 3 then
# line 21 "lib/halunke/lexer.rl"
		begin
act = 3;		end
when 4 then
# line 31 "lib/halunke/lexer.rl"
		begin
act = 13;		end
when 5 then
# line 20 "lib/halunke/lexer.rl"
		begin
te = p+1
 begin  emit(:STRING, data[ts+1...te-1])  end
		end
when 6 then
# line 22 "lib/halunke/lexer.rl"
		begin
te = p+1
 begin  emit(:BAREWORD, data[ts...te])  end
		end
when 7 then
# line 23 "lib/halunke/lexer.rl"
		begin
te = p+1
 begin  emit(:OPEN_PAREN, data[ts...te])  end
		end
when 8 then
# line 24 "lib/halunke/lexer.rl"
		begin
te = p+1
 begin  emit(:CLOSE_PAREN, data[ts...te])  end
		end
when 9 then
# line 25 "lib/halunke/lexer.rl"
		begin
te = p+1
 begin  emit(:OPEN_CURLY, data[ts...te])  end
		end
when 10 then
# line 26 "lib/halunke/lexer.rl"
		begin
te = p+1
 begin  emit(:CLOSE_CURLY, data[ts...te])  end
		end
when 11 then
# line 27 "lib/halunke/lexer.rl"
		begin
te = p+1
 begin  emit(:OPEN_BRACKET, data[ts...te])  end
		end
when 12 then
# line 28 "lib/halunke/lexer.rl"
		begin
te = p+1
 begin  emit(:CLOSE_BRACKET, data[ts...te])  end
		end
when 13 then
# line 29 "lib/halunke/lexer.rl"
		begin
te = p+1
 begin  emit(:BAR, data[ts...te])  end
		end
when 14 then
# line 30 "lib/halunke/lexer.rl"
		begin
te = p+1
		end
when 15 then
# line 31 "lib/halunke/lexer.rl"
		begin
te = p+1
 begin  raise "Could not lex '#{ data[ts...te] }'"  end
		end
when 16 then
# line 19 "lib/halunke/lexer.rl"
		begin
te = p
p = p - 1; begin  emit(:NUMBER, data[ts...te].to_r)  end
		end
when 17 then
# line 22 "lib/halunke/lexer.rl"
		begin
te = p
p = p - 1; begin  emit(:BAREWORD, data[ts...te])  end
		end
when 18 then
# line 31 "lib/halunke/lexer.rl"
		begin
te = p
p = p - 1; begin  raise "Could not lex '#{ data[ts...te] }'"  end
		end
when 19 then
# line 19 "lib/halunke/lexer.rl"
		begin
 begin p = ((te))-1; end
 begin  emit(:NUMBER, data[ts...te].to_r)  end
		end
when 20 then
# line 31 "lib/halunke/lexer.rl"
		begin
 begin p = ((te))-1; end
 begin  raise "Could not lex '#{ data[ts...te] }'"  end
		end
when 21 then
# line 1 "NONE"
		begin
	case act
	when 3 then
	begin begin p = ((te))-1; end
 emit(:UNASSIGNED_BAREWORD, data[ts+1 ...te]) end
	when 13 then
	begin begin p = ((te))-1; end
 raise "Could not lex '#{ data[ts...te] }'" end
end 
			end
# line 388 "lib/halunke/lexer.rb"
			end # action switch
		end
	end
	if _trigger_goto
		next
	end
	end
	if _goto_level <= _again
	_acts = _lexer_to_state_actions[cs]
	_nacts = _lexer_actions[_acts]
	_acts += 1
	while _nacts > 0
		_nacts -= 1
		_acts += 1
		case _lexer_actions[_acts - 1]
when 0 then
# line 1 "NONE"
		begin
ts = nil;		end
# line 408 "lib/halunke/lexer.rb"
		end # to state action switch
	end
	if _trigger_goto
		next
	end
	p += 1
	if p != pe
		_goto_level = _resume
		next
	end
	end
	if _goto_level <= _test_eof
	if p == eof
	if _lexer_eof_trans[cs] > 0
		_trans = _lexer_eof_trans[cs] - 1;
		_goto_level = _eof_trans
		next;
	end
end
	end
	if _goto_level <= _out
		break
	end
	end
	end

# line 50 "lib/halunke/lexer.rl"

      @tokens
    end

    private

    def emit(type, value)
      @tokens << [ type, value ]
    end
  end
end
