-- --[[
-- Serialzation bytes stream like ActionScript flash.utils.ByteArray.
-- It depends on lpack.
-- A sample: https://github.com/zrong/lua#ByteArray

-- @see http://underpop.free.fr/l/lua/lpack/
-- @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/utils/ByteArray.html
-- @author zrong(zengrong.net)

-- Creation 2013-11-14
-- Last Modification 2014-07-09
-- ]]
-- ByteArray = class("ByteArray")

-- ByteArray.ENDIAN_LITTLE = "ENDIAN_LITTLE"
-- ByteArray.ENDIAN_BIG = "ENDIAN_BIG"
-- ByteArray.radix = {[10]="%03u",[8]="%03o",[16]="%02X"}

-- --- Return a string to display.
-- -- If self is ByteArray, read string from self.
-- -- Else, treat self as byte string.
-- -- @param __radix radix of display, value is 8, 10 or 16, default is 10.
-- -- @param __separator default is " ".
-- -- @return string, number
-- function ByteArray.toString(self, __radix, __separator)
-- 	__radix = __radix or 16 
-- 	__radix = ByteArray.radix[__radix] or "%02X"
-- 	__separator = __separator or " "
-- 	local __fmt = __radix..__separator
-- 	local __format = function(__s)
-- 		return string.format(__fmt, string.byte(__s))
-- 	end
-- 	if type(self) == "string" then
-- 		return string.gsub(self, "(.)", __format)
-- 	end
-- 	local __bytes = {}
-- 	for i=1,#self._buf do
-- 		__bytes[i] = __format(self._buf[i])
-- 	end
-- 	return table.concat(__bytes) ,#__bytes
-- end

-- function ByteArray:ctor(__endian)
-- 	self._endian = __endian
-- 	self._buf = {}
-- 	self._pos = 1
-- end

-- function ByteArray:getLen()
-- 	return #self._buf
-- end

-- function ByteArray:getAvailable()
-- 	return #self._buf - self._pos + 1
-- end

-- function ByteArray:getPos()
-- 	return self._pos
-- end

-- function ByteArray:setPos(__pos)
-- 	self._pos = __pos
-- 	return self
-- end

-- function ByteArray:getEndian()
-- 	return self._endian
-- end

-- function ByteArray:setEndian(__endian)
-- 	self._endian = __endian
-- end

-- --- Get all byte array as a lua string.
-- -- Do not update position.
-- function ByteArray:getBytes(__offset, __length)
-- 	__offset = __offset or 1
-- 	__length = __length or #self._buf
-- 	-- printf("getBytes,offset:%u, length:%u", __offset, __length)
-- 	return table.concat(self._buf, "", __offset, __length)
-- end

-- --- Get pack style string by lpack.
-- -- The result use ByteArray.getBytes to get is unavailable for lua socket.
-- -- E.g. the #self:_buf is 18, but #ByteArray.getBytes is 63.
-- -- I think the cause is the table.concat treat every item in ByteArray._buf as a general string, not a char.
-- -- So, I use lpack repackage the ByteArray._buf, theretofore, I must convert them to a byte number.
-- function ByteArray:getPack(__offset, __length)
-- 	__offset = __offset or 1
-- 	__length = __length or #self._buf
-- 	local __t = {}
-- 	for i=__offset,__length do
-- 		__t[#__t+1] = string.byte(self._buf[i])
-- 	end
-- 	local __fmt = self:_getLC("b"..#__t)
-- 	--print("fmt:", __fmt)
-- 	local __s = string.pack(__fmt, unpack(__t))
-- 	return __s
-- end

-- --- rawUnPack perform like lpack.pack, but return the ByteArray.
-- function ByteArray:rawPack(__fmt, ...)
-- 	local __s = string.pack(__fmt, ...)
-- 	self:writeBuf(__s)
-- 	return self
-- end

-- --- rawUnPack perform like lpack.unpack, but it is only support FORMAT parameter.
-- -- Because ByteArray include a position itself, so we haven't to save another.
-- function ByteArray:rawUnPack(__fmt)
-- 	-- read all of bytes.
-- 	local __s = self:getBytes(self._pos)
-- 	local __next, __val = string.unpack(__s, __fmt)
-- 	-- update position of the ByteArray
-- 	self._pos = self._pos + __next
-- 	-- Alternate value and next
-- 	return __val, __next
-- end

-- function ByteArray:readBool()
-- 	-- When char > 256, the readByte method will show an error.
-- 	-- So, we have to use readChar
-- 	return self:readChar() ~= 0
-- end

-- function ByteArray:writeBool(__bool)
-- 	if __bool then 
-- 		self:writeByte(1)
-- 	else
-- 		self:writeByte(0)
-- 	end
-- 	return self
-- end

-- function ByteArray:readDouble()
-- 	local __, __v = string.unpack(self:readBuf(8), self:_getLC("d"))
-- 	return __v
-- end

-- function ByteArray:writeDouble(__double)
-- 	local __s = string.pack( self:_getLC("d"), __double)
-- 	self:writeBuf(__s)
-- 	return self
-- end

-- function ByteArray:readFloat()
-- 	local __, __v = string.unpack(self:readBuf(4), self:_getLC("f"))
-- 	return __v
-- end

-- function ByteArray:writeFloat(__float)
-- 	local __s = string.pack( self:_getLC("f"),  __float)
-- 	self:writeBuf(__s)
-- 	return self
-- end

-- function ByteArray:readInt()
-- 	local __, __v = string.unpack(self:readBuf(4), self:_getLC("i"))
-- 	return __v
-- end

-- function ByteArray:writeInt(__int)
-- 	local __s = string.pack( self:_getLC("i"),  __int)
-- 	self:writeBuf(__s)
-- 	return self
-- end

-- function ByteArray:readUInt()
-- 	local __, __v = string.unpack(self:readBuf(4), self:_getLC("I"))
-- 	return __v
-- end

-- function ByteArray:writeUInt(__uint)
-- 	local __s = string.pack(self:_getLC("I"), __uint)
-- 	self:writeBuf(__s)
-- 	return self
-- end

-- function ByteArray:readShort()
-- 	local __, __v = string.unpack(self:readBuf(2), self:_getLC("h"))
-- 	return __v
-- end

-- function ByteArray:writeShort(__short)
-- 	local __s = string.pack( self:_getLC("h"),  __short)
-- 	self:writeBuf(__s)
-- 	return self
-- end

-- function ByteArray:readUShort()
-- 	local __, __v = string.unpack(self:readBuf(2), self:_getLC("H"))
-- 	return __v
-- end

-- function ByteArray:writeUShort(__ushort)
-- 	local __s = string.pack(self:_getLC("H"),  __ushort)
-- 	self:writeBuf(__s)
-- 	return self
-- end

-- --[[
-- -- 2014-07-09 Remove all of methods about Long in ByteArray.
-- -- @see http://zengrong.net/post/2134.htm
-- function ByteArray:readLong()
-- 	local __, __v = string.unpack(self:readBuf(8), self:_getLC("l"))
-- 	return __v
-- end

-- function ByteArray:writeLong(__long)
-- 	local __s = string.pack( self:_getLC("l"),  __long)
-- 	self:writeBuf(__s)
-- 	return self
-- end

-- function ByteArray:readULong()
-- 	local __, __v = string.unpack(self:readBuf(4), self:_getLC("L"))
-- 	return __v
-- end


-- function ByteArray:writeULong(__ulong)
-- 	local __s = string.pack( self:_getLC("L"), __ulong)
-- 	self:writeBuf(__s)
-- 	return self
-- end
-- ]]

-- function ByteArray:readUByte()
-- 	local __, __val = string.unpack(self:readRawByte(), "b")
-- 	return __val
-- end

-- function ByteArray:writeUByte(__ubyte)
-- 	local __s = string.pack("b", __ubyte)
-- 	self:writeBuf(__s)
-- 	return self
-- end

-- function ByteArray:readLuaNumber(__number)
-- 	local __, __v = string.unpack(self:readBuf(8), self:_getLC("n"))
-- 	return __v
-- end

-- function ByteArray:writeLuaNumber(__number)
-- 	local __s = string.pack(self:_getLC("n"), __number)
-- 	self:writeBuf(__s)
-- 	return self
-- end

-- --- The differently about (read/write)StringBytes and (read/write)String 
-- -- are use pack libraty or not.
-- function ByteArray:readStringBytes(__len)
-- 	assert(__len, "Need a length of the string!")
-- 	if __len == 0 then return "" end
-- 	self:_checkAvailable()
-- 	local __, __v = string.unpack(self:readBuf(__len), self:_getLC("A"..__len))
-- 	return __v
-- end

-- function ByteArray:writeStringBytes(__string)
-- 	local __s = string.pack(self:_getLC("A"), __string)
-- 	self:writeBuf(__s)
-- 	return self
-- end

-- function ByteArray:readString(__len)
-- 	assert(__len, "Need a length of the string!")
-- 	if __len == 0 then return "" end
-- 	self:_checkAvailable()
-- 	return self:readBuf(__len)
-- end

-- function ByteArray:writeString(__string)
-- 	self:writeBuf(__string)
-- 	return self
-- end

-- function ByteArray:readStringUInt()
-- 	self:_checkAvailable()
-- 	local __len = self:readUInt()
-- 	return self:readStringBytes(__len)
-- end

-- function ByteArray:writeStringUInt(__string)
-- 	self:writeUInt(#__string)
-- 	self:writeStringBytes(__string)
-- 	return self
-- end

-- --- The length of size_t in C/C++ is mutable.
-- -- In 64bit os, it is 8 bytes.
-- -- In 32bit os, it is 4 bytes.
-- function ByteArray:readStringSizeT()
-- 	self:_checkAvailable()
-- 	local __s = self:rawUnPack(self:_getLC("a"))
-- 	return  __s
-- end

-- --- Perform rawPack() simply.
-- function ByteArray:writeStringSizeT(__string)
-- 	self:rawPack(self:_getLC("a"), __string)
-- 	return self
-- end

-- function ByteArray:readStringUShort()
-- 	self:_checkAvailable()
-- 	local __len = self:readUShort()
-- 	return self:readStringBytes(__len)
-- end

-- function ByteArray:writeStringUShort(__string)
-- 	local __s = string.pack(self:_getLC("P"), __string)
-- 	self:writeBuf(__s)
-- 	return self
-- end

-- --- Read some bytes from buf
-- -- @return a bit string
-- function ByteArray:readBytes(__bytes, __offset, __length)
-- 	assert(iskindof(__bytes, "ByteArray"), "Need a ByteArray instance!")
-- 	local __selfLen = #self._buf
-- 	local __availableLen = __selfLen - self._pos
-- 	__offset = __offset or 1
-- 	if __offset > __selfLen then __offset = 1 end
-- 	__length = __length or 0
-- 	if __length == 0 or __length > __availableLen then __length = __availableLen end
-- 	__bytes:setPos(__offset)
-- 	for i=__offset,__offset+__length do
-- 		__bytes:writeRawByte(self:readRawByte())
-- 	end
-- end

-- --- Write some bytes into buf
-- function ByteArray:writeBytes(__bytes, __offset, __length)
-- 	assert(iskindof(__bytes, "ByteArray"), "Need a ByteArray instance!")
-- 	local __bytesLen = __bytes:getLen()
-- 	if __bytesLen == 0 then return end
-- 	__offset = __offset or 1
-- 	if __offset > __bytesLen then __offset = 1 end
-- 	local __availableLen = __bytesLen - __offset
-- 	__length = __length or __availableLen
-- 	if __length == 0 or __length > __availableLen then __length = __availableLen end
-- 	local __oldPos = __bytes:getPos()
-- 	__bytes:setPos(__offset)
-- 	for i=__offset,__offset+__length do
-- 		self:writeRawByte(__bytes:readRawByte())
-- 	end
-- 	__bytes:setPos(__oldPos)
-- 	return self
-- end

-- --- Actionscript3 readByte == lpack readChar
-- -- A signed char
-- function ByteArray:readChar()
-- 	local __, __val = string.unpack( self:readRawByte(), "c")
-- 	return __val
-- end

-- function ByteArray:writeChar(__char)
-- 	self:writeRawByte(string.pack("c", __char))
-- 	return self
-- end

-- --- Use the lua string library to get a byte
-- -- A unsigned char
-- function ByteArray:readByte()
-- 	return string.byte(self:readRawByte())
-- end

-- --- Use the lua string library to write a byte.
-- -- The byte is a number between 0 and 255, otherwise, the lua will get an error.
-- function ByteArray:writeByte(__byte)
-- 	self:writeRawByte(string.char(__byte))
-- 	return self
-- end

-- function ByteArray:readRawByte()
-- 	self:_checkAvailable()
-- 	local __byte = self._buf[self._pos]
-- 	self._pos = self._pos + 1
-- 	return __byte
-- end

-- function ByteArray:writeRawByte(__rawByte)
-- 	if self._pos > #self._buf+1 then
-- 		for i=#self._buf+1,self._pos-1 do
-- 			self._buf[i] = string.char(0)
-- 		end
-- 	end
-- 	self._buf[self._pos] = string.sub(__rawByte, 1,1)
-- 	self._pos = self._pos + 1
-- 	return self
-- end

-- --- Read a byte array as string from current position, then update the position.
-- function ByteArray:readBuf(__len)
-- 	--printf("readBuf,len:%u, pos:%u", __len, self._pos)
-- 	local __ba = self:getBytes(self._pos, self._pos + __len - 1)
-- 	self._pos = self._pos + __len
-- 	return __ba
-- end

-- --- Write a encoded char array into buf
-- function ByteArray:writeBuf(__s)
-- 	for i=1,#__s do
-- 		self:writeRawByte(string.sub(__s,i,i))
-- 	end
-- 	return self
-- end

-- --clear content and reset pos
-- function ByteArray:clear()
-- 	self._buf = {}
-- 	self._pos = 1
-- end

-- ----------------------------------------
-- -- private
-- ----------------------------------------
-- function ByteArray:_checkAvailable()
-- 	assert(#self._buf >= self._pos, string.format("End of file was encountered. pos: %d, len: %d.", self._pos, #self._buf))
-- end

-- --- Get Letter Code
-- function ByteArray:_getLC(__fmt)
-- 	__fmt = __fmt or ""
-- 	if self._endian == ByteArray.ENDIAN_LITTLE then
-- 		return "<"..__fmt
-- 	elseif self._endian == ByteArray.ENDIAN_BIG then
-- 		return ">"..__fmt
-- 	end
-- 	return "="..__fmt
-- end


ByteArray = class("ByteArray")

function ByteArray:ctor()
    self.bytesAvailable = 0  --可从字节数组的当前位置到数组末尾读取的数据的字节数。
    self.length = 0 --ByteArray 对象的长度（以字节为单位）。
    self.position = 1 --当前位置 从1开始索引
    self.buffer = ""
end

--从字节流中读取带符号的字节。
function ByteArray:readByte()
    local byte = string.sub(self.buffer, self.position ,self.position)
    self.bytesAvailable = self.bytesAvailable - 1
    self.position = self.length - self.bytesAvailable + 1
    byte = string.byte(byte,1,1)
    return byte
end

function ByteArray:readShort()
    local byte1 = self:readByte()
    local byte2 = self:readByte()
    local short = byte1 * 256 + byte2
    return short
end

function ByteArray:readInt()
    local short1 = self:readShort()
    local short2 = self:readShort()
    local int = short1 * 65536 + short2
    return int
end

---实际是一个字符串
---用8位长度的string来存储64位数据
function ByteArray:readInt64()
    local int64 = ""
    local len = 8
    local i = 1
    local byte = 0
    for i = 1,len do
        byte = self:readByte()
        if byte == 0 then
            int64 = int64 .. "\\0"
        else
            int64 = int64 .. string.char(byte)
        end
    end
    return Utils:string_to_int64(int64)
end

function ByteArray:readBytes(len)
    len = len or self.length - self.position + 1 --
    
    local str = string.sub( self.buffer ,self.position, self.position + len - 1)
    
    self.position = self.position + len
    self.bytesAvailable = self.bytesAvailable - len
    return str
    
end

--从字节流中读取一个 UTF-8 字符串。假定字符串的前缀是无符号的短整型（以字节表示长度）。
function ByteArray:readUTF()
    local str = ""
    local len = self:readShort() --短整型（以字节表示长度）
    local i = 1
    local byte = 0;
    for i = 1, len do
        byte = self:readByte()
        str = str .. string.char(byte)
    end

    return str
end

function ByteArray:readUTF8()
    local str = ""
    local len = self:readByte() --短整型（以字节表示长度）
    local i = 1
    local byte = 0;
    for i = 1, len do
        byte = self:readByte()
        str = str .. string.char(byte)
    end

    return str
end

function ByteArray:readUTF32()
    local str = ""
    local len = self:readInt() --短整型（以字节表示长度）
    local i = 1
    local byte = 0;
    for i = 1, len do
        byte = self:readByte()
        str = str .. string.char(byte)
    end

    return str
end

function ByteArray:writeByte(byte)

    self.buffer = self.buffer .. string.char(byte)
    
    self.length = string.len(self.buffer)
    self.bytesAvailable = self.bytesAvailable + 1
end
--
function ByteArray:writeShort( short )
    local byte2 = short % 256
    local byte1 = ( short - byte2 ) / 256
    self:writeByte(byte1)
    self:writeByte(byte2)
end

--
function ByteArray:writeInt( int )
    local short2 = int % 65536
    local short1 = (int - short2) / 65536
    self:writeShort(short1)
    self:writeShort(short2)
end
--
-------64位整形 实际为8位字符串来存储
--function ByteArray:writeInt64( int64 )
--    local str = int64
--    local i = 1
--    local len = 0
--    local byte = string.byte(str, i)
--    while byte ~= nil do      
--        len = len + 1
--        i = i + 1
--        byte = string.byte(str, i)
--    end
--
--    self:writeByte(len)
--    i = 1
--    while(i <= len) do
--        byte = string.byte(str, i)
--        if string.char(byte) == "\\" then
--            i = i + 1
--            byte = 0
--        end
--        self:writeByte(byte)
--        i = i + 1
--    end
--end
--
----32位字符串
--function ByteArray:writeInt32( int32 )
--    local len = string.len(int32)
--    local i = 1
--    local byte = nil
--    for i = 1, len do
--        byte = string.byte(int32, i)
--        self:writeByte(byte)
--    end
--end



--写二进制串
function ByteArray:writeBytes( bytes )

    self.buffer = self.buffer .. bytes
    
    local len = string.len(self.buffer)
    
    self.bytesAvailable = len
    self.length = len
    
--    for index=1, len do
--        local byte = string.sub(bytes,index,index)
--        self:writeByte(byte)
--    end
end

--function ByteArray:writeUTF( str )
--    local i = 1
--    local len = 0
--    local byte = string.byte(str, i)
--    while byte ~= nil do
--        len = len + 1
--        i = i + 1
--        byte = string.byte(str, i)
--    end
--
--    self:writeShort(len)
--    for i=1,len do
--        byte = string.byte(str, i)
--        self:writeByte(byte)
--    end
--end

function ByteArray:getLength()
    return self.length
end

function ByteArray:toString()
    return self.buffer
end