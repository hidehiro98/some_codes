# https://codeiq.jp/magazine/2017/09/53494/

post '/line/callback' do
  body      = request.body.read
  signature = request.env['HTTP_X_LINE_SIGNATURE']

  unless client.validate_signature(body, signature)
    error 400 do 'Bad Request' end
  end

  events = client.parse_events_from(body)
  events.each do |event|
    case event
    when Line::Bot::Event::Message
      case event.type
      when Line::Bot::Event::MessageType::Text
        analyze = AnalyzeText.new(event.message['text'])
        result = analyze.result
        message = {
          type: 'text',
          text: result
        }
        client.reply_message(event['replyToken'], message)
      end
    end
  end
end


@@patterns = [
  Pattern.new(
    /どうしたの？|大丈夫？/,
    [ "乙女心解説:", "めんどくさいな" ]
  ),
  PatternWithRandom.new(
    /疲れた/,
    [ "乙女心解説:", "今日は何もできない" ]
  ),
  # ....
]


class Pattern
  attr_reader :matcher, :response

  def initialize(matcher, response)
    @matcher, @response = matcher, response
  end

  # パターンにマッチするか？
  def match?(text)
    @matcher.match(text) != nil
  end
end


# 1/10の確率で応答するパターン
  class PatternWithRandom < Pattern
    # 1/10でマッチする
    def match?(text)
      rand(10) == 0 && super
    end
  end
