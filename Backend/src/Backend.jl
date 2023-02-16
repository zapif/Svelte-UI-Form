module Backend
using Dates, HTTP, JSON3, Sockets
struct Request
    date::Dates.Date
    text::String
    number::Integer
    checked::Bool
end
JSON3.StructType(::Type{Request}) = JSON3.Struct()


function create(req::HTTP.Request)
    input = JSON3.read(IOBuffer(HTTP.payload(req)), Request)
    println(input)
    return HTTP.Response(200, JSON3.write(input))
end


function main()
    ROUTER = HTTP.Router()
    HTTP.register!(ROUTER, "POST", "/api/create", create)
    HTTP.serve(ROUTER, Sockets.localhost, 8081)
end
end
