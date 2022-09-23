require "json"

app = Proc.new do |env|
    result = nil
    body = JSON.parse(env["rack.input"].read)
    body["operands"].each { |operand|
        result.nil? ? result = operand : result -= operand
    }

    ["200", {
        "Content-Type" => "application/json; charset=utf-8",
    }, [JSON.pretty_generate({'result' => result})]]
end;

run app
