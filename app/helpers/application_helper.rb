module ApplicationHelper
  # シンタックスハイライト
  class HTMLwithCoderay < Redcarpet::Render::HTML
    def block_code(code, language)
      case language.to_s
      when 'rb'
        lang = 'ruby'
      when 'yml'
        lang = 'yaml'
      when ''
        # 空欄のままだと「Invalid id given:」エラー
        lang = 'md'
      else
        lang = language
      end

      CodeRay.scan(code, lang).div
    end
  end

  # マークダウン
  def markdown(text)
    html_render = HTMLwithCoderay.new(filter_html: true, hard_wrap: true)
    options = {
      autolink: true,
      space_after_headers: true,
      fenced_code_blocks: true,
    }
    markdown    = Redcarpet::Markdown.new(html_render, options)
    markdown.render(text)
  end

  # 土曜／日曜／祝日のクラスを追加
  def day_class(day)
    if day.wday == 0 or day.national_holiday?
      return 'sunday'
    elsif day.wday == 6
      return 'saturday'
    end
  end

  # 今日のクラスを追加
  def today_class(day)
    if day.strftime("%Y/%m/%d") == Time.now.strftime("%Y/%m/%d")
      today_class = "today"
    end
  end

  # 日付のポップオーバータイトル
  def schedule_popover_title(schedule)
    if schedule.start_at.present? and schedule.end_at.present?
      return nil if schedule.start_at == schedule.end_at
      return schedule.start_at.strftime("%H:%M") + "〜" + schedule.end_at.strftime("%H:%M")
    end
  end
end
