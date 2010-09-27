## from boot.j:
# struct UTF8String <: String
#     data::Array{Uint8,1}
# end

# length(str::UTF8String) = str.data

utf8_offset = [
    int64(0),
    int64(12416),
    int64(925824),
    int64(63447168),
    int64(4194836608),
    int64(2181570688),
]

utf8_encoding_bytes = [
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
    3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3, 4,4,4,4,4,4,4,4,5,5,5,5,6,6,6,6,
]

is_utf8_start(b::Uint8) = ((b&192)!=128)

function read_char(str::UTF8String, i::Index)
    if !is_utf8_start(str.data[i])
        error(strcat("not a valid UTF8 char at byte ", string(i)))
    end
    bytes = utf8_encoding_bytes[str.data[i]+1]
    c = 0
    for j = 1:bytes-1
        c += str.data[i]
        c <<= 6
        i += 1
    end
    c += str.data[i]; i += 1
    c -= utf8_offset[bytes]
    char(c), i
end

start(str::String) = 1
next(str::String,i) = read_char(str,i)
done(str::String,i) = (i > length(str))