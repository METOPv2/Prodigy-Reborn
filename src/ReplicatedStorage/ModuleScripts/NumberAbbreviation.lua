export type Constructor = {
    Comas: (number) -> string,
}

local NumberAbbreviation = {}

function NumberAbbreviation:Comas(number: number): string
    number = math.round(number)

    local formatted = tostring(number)
    local k = 0

    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1,%2")
        if k == 0 then
            break
        end
    end

    return formatted
end

return NumberAbbreviation
