module ApplicationHelper
  def file_show_path(obj)
    obj.is_a?(StockedFile) ? super(obj.hash_key) : super(obj)
  end

  def download_path(obj)
    obj.is_a?(StockedFile) ? super(obj.hash_key) : super(obj)
  end

  def easy_file_size(size)
    size < 1.kilobytes ? "#{size} Bytes" :
      size < 1.megabytes ? "#{(size.to_f / 1.kilobytes).round(2)} kB" :
        "#{(size.to_d / 1.megabytes).round(2)} MB"
  end
end
