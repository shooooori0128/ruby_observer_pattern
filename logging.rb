require "active_support/all"

class LogObserver
  attr_reader :logger

  def initialize
    FileUtils.mkdir_p("log")

    @logger = []
  end

  def logger=(logger)
    @logger << logger
  end

  def write_logger(message)
    @logger.each do |logger|
      logger.write_log(message)
    end
  end
end

class LoggerInterface
  def initialize(log_file)
    @logger           = ActiveSupport::Logger.new("log/#{log_file}.log", "daily")
    @logger.formatter = ::Logger::Formatter.new
    console           = ActiveSupport::Logger.new(STDOUT)
    @logger.extend ActiveSupport::Logger.broadcast(console)
  end

  def write_log(message); end
end

class DebugLogger < LoggerInterface
  def initialize(log_file)
    super(log_file)
  end

  def write_log(message)
    @logger.debug(message)
  end
end

class InfoLogger < LoggerInterface
  def initialize(log_file)
    super(log_file)
  end

  def write_log(message)
    @logger.info(message)
  end
end

class WarnLogger < LoggerInterface
  def initialize(log_file)
    super(log_file)
  end

  def write_log(message)
    @logger.warn(message)
  end
end

class ErrorLogger < LoggerInterface
  def initialize(log_file)
    super(log_file)
  end

  def write_log(message)
    @logger.error(message)
  end
end

log_observer        = LogObserver.new
log_observer.logger = DebugLogger.new("debug")
log_observer.logger = InfoLogger.new("info")
log_observer.logger = WarnLogger.new("warn")
log_observer.logger = ErrorLogger.new("error")

log_observer.write_logger("ろぐだします")

# この例だと、せっかくログレベルに応じてログファイル分けているのに、ログ出力処理を実行すると全てのログに書かれてしまう。
# なので例が悪いけど、とりあえず一応はオブザーバーパターン？
