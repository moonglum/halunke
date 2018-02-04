
# line 1 "lib/halunke/lexer.rl"
=begin

# line 28 "lib/halunke/lexer.rl"

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
	13, 1, 14, 1, 15, 1, 16, 2, 
	2, 3, 2, 2, 4
]

class << self
	attr_accessor :_lexer_key_offsets
	private :_lexer_key_offsets, :_lexer_key_offsets=
end
self._lexer_key_offsets = [
	0, 1, 20, 21, 23
]

class << self
	attr_accessor :_lexer_trans_keys
	private :_lexer_trans_keys, :_lexer_trans_keys=
end
self._lexer_trans_keys = [
	34, 32, 34, 40, 41, 43, 45, 60, 
	62, 95, 123, 125, 9, 13, 48, 57, 
	65, 90, 97, 122, 34, 48, 57, 95, 
	65, 90, 97, 122, 0
]

class << self
	attr_accessor :_lexer_single_lengths
	private :_lexer_single_lengths, :_lexer_single_lengths=
end
self._lexer_single_lengths = [
	1, 11, 1, 0, 1
]

class << self
	attr_accessor :_lexer_range_lengths
	private :_lexer_range_lengths, :_lexer_range_lengths=
end
self._lexer_range_lengths = [
	0, 4, 0, 1, 2
]

class << self
	attr_accessor :_lexer_index_offsets
	private :_lexer_index_offsets, :_lexer_index_offsets=
end
self._lexer_index_offsets = [
	0, 2, 18, 20, 22
]

class << self
	attr_accessor :_lexer_trans_targs
	private :_lexer_trans_targs, :_lexer_trans_targs=
end
self._lexer_trans_targs = [
	1, 0, 1, 2, 1, 1, 3, 3, 
	1, 1, 4, 1, 1, 1, 3, 4, 
	4, 1, 1, 0, 3, 1, 4, 4, 
	4, 1, 1, 1, 1, 1, 0
]

class << self
	attr_accessor :_lexer_trans_actions
	private :_lexer_trans_actions, :_lexer_trans_actions=
end
self._lexer_trans_actions = [
	7, 0, 19, 5, 9, 11, 34, 34, 
	17, 17, 0, 13, 15, 19, 31, 0, 
	0, 21, 7, 0, 31, 29, 0, 0, 
	0, 23, 27, 25, 29, 23, 0
]

class << self
	attr_accessor :_lexer_to_state_actions
	private :_lexer_to_state_actions, :_lexer_to_state_actions=
end
self._lexer_to_state_actions = [
	0, 1, 0, 0, 0
]

class << self
	attr_accessor :_lexer_from_state_actions
	private :_lexer_from_state_actions, :_lexer_from_state_actions=
end
self._lexer_from_state_actions = [
	0, 3, 0, 0, 0
]

class << self
	attr_accessor :_lexer_eof_trans
	private :_lexer_eof_trans, :_lexer_eof_trans=
end
self._lexer_eof_trans = [
	27, 0, 28, 29, 30
]

class << self
	attr_accessor :lexer_start
end
self.lexer_start = 1;
class << self
	attr_accessor :lexer_first_final
end
self.lexer_first_final = 1;
class << self
	attr_accessor :lexer_error
end
self.lexer_error = -1;

class << self
	attr_accessor :lexer_en_main
end
self.lexer_en_main = 1;


# line 35 "lib/halunke/lexer.rl"
      @tokens = []
    end

    def tokenize(data)
      data.chomp!
      eof = data.length

      
# line 144 "lib/halunke/lexer.rb"
begin
	p ||= 0
	pe ||= data.length
	cs = lexer_start
	ts = nil
	te = nil
	act = 0
end

# line 43 "lib/halunke/lexer.rl"
      
# line 156 "lib/halunke/lexer.rb"
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
# line 186 "lib/halunke/lexer.rb"
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
# line 16 "lib/halunke/lexer.rl"
		begin
act = 1;		end
when 4 then
# line 23 "lib/halunke/lexer.rl"
		begin
act = 8;		end
when 5 then
# line 17 "lib/halunke/lexer.rl"
		begin
te = p+1
 begin  emit(:STRING, data[ts+1...te-1])  end
		end
when 6 then
# line 19 "lib/halunke/lexer.rl"
		begin
te = p+1
 begin  emit(:OPEN_PAREN, data[ts...te])  end
		end
when 7 then
# line 20 "lib/halunke/lexer.rl"
		begin
te = p+1
 begin  emit(:CLOSE_PAREN, data[ts...te])  end
		end
when 8 then
# line 21 "lib/halunke/lexer.rl"
		begin
te = p+1
 begin  emit(:OPEN_CURLY, data[ts...te])  end
		end
when 9 then
# line 22 "lib/halunke/lexer.rl"
		begin
te = p+1
 begin  emit(:CLOSE_CURLY, data[ts...te])  end
		end
when 10 then
# line 23 "lib/halunke/lexer.rl"
		begin
te = p+1
 begin  emit(:OPERATOR, data[ts ... te])  end
		end
when 11 then
# line 24 "lib/halunke/lexer.rl"
		begin
te = p+1
		end
when 12 then
# line 25 "lib/halunke/lexer.rl"
		begin
te = p+1
 begin  raise "Could not lex '#{ data[ts...te] }'"  end
		end
when 13 then
# line 18 "lib/halunke/lexer.rl"
		begin
te = p
p = p - 1; begin  emit(:BAREWORD, data[ts...te])  end
		end
when 14 then
# line 25 "lib/halunke/lexer.rl"
		begin
te = p
p = p - 1; begin  raise "Could not lex '#{ data[ts...te] }'"  end
		end
when 15 then
# line 25 "lib/halunke/lexer.rl"
		begin
 begin p = ((te))-1; end
 begin  raise "Could not lex '#{ data[ts...te] }'"  end
		end
when 16 then
# line 1 "NONE"
		begin
	case act
	when 1 then
	begin begin p = ((te))-1; end
 emit(:NUMBER, data[ts...te].to_i) end
	when 8 then
	begin begin p = ((te))-1; end
 emit(:OPERATOR, data[ts ... te]) end
end 
			end
# line 342 "lib/halunke/lexer.rb"
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
# line 362 "lib/halunke/lexer.rb"
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

# line 44 "lib/halunke/lexer.rl"

      @tokens
    end

    private

    def emit(type, value)
      @tokens << [ type, value ]
    end
  end
end
